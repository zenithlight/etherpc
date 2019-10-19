require "json"

require "./request"
require "./transport"

# TODO: helper factories to quickly create a Client with given WS/HTTP address

module Etherpc
    class Client
        def initialize(@transport : Etherpc::Transport)
            # One fiber for each request in flight.
            @pending_requests = {} of Int32 => Channel(JSON::Any)

            @transport.on_response do |id, result|
                @pending_requests[id].send result if @pending_requests.has_key?(id)
            end

            @next_request_id = 1
        end

        def call(request : Etherpc::Request)
            id = @next_request_id
            @next_request_id += 1

            request_channel = Channel(JSON::Any).new
            @pending_requests[id] = request_channel

            @transport.send(id, request.method_name, request.get_params)
            response = request_channel.receive
            @pending_requests.delete id

            request.class.deserialize_response response
        end
    end
end
