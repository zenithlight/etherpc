require "json"

require "./request"
require "./subscription"
require "./transport"

# TODO: helper factories to quickly create a Client with given WS/HTTP address

module Etherpc
    class Client
        def initialize(@transport : Etherpc::Transport)
            # One fiber for each request in flight.
            @pending_requests = {} of Int32 => Channel(JSON::Any)
            @next_request_id = 1

            @transport.on_response do |id, result|
                @pending_requests[id].send result if @pending_requests.has_key?(id)
            end

            # One fiber for each active subscription.
            @active_subscriptions = {} of String => Channel(JSON::Any)

            @transport.on_event do |id, result|
                @active_subscriptions[id].send result if @active_subscriptions.has_key?(id)
            end
        end

        # TODO: you should probably not be allowed to `call` a `Subscription`
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

        def subscribe(subscription : Etherpc::Subscription, &block : JSON::Any ->)
            id = self.call(subscription).as_s

            subscription_channel = Channel(JSON::Any).new
            @active_subscriptions[id] = subscription_channel

            while true
                yield subscription_channel.receive
            end
        end
    end
end
