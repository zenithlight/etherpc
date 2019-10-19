require "../transport"

module Etherpc::Transports
    class WebSocket < Etherpc::Transport
        def initialize(@web_socket : HTTP::WebSocket)
            @web_socket.on_message do |message|
                parsed_message = Hash(String, JSON::Any).from_json(message)
                @on_response.try &.call(parsed_message["id"].as_i, parsed_message["result"])
            end

            spawn do
                @web_socket.run
            end
        end

        def on_response(&@on_response : Int32, JSON::Any ->)
        end

        def send(id, method_name, params)
            message = {
                "jsonrpc": "2.0",
                "method": method_name,
                "params": params,
                "id": id
            }.to_json

            @web_socket.send message
        end
    end
end
