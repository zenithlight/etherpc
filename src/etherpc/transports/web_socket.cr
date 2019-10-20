require "../transport"

module Etherpc::Transports
    class WebSocket < Etherpc::Transport
        def initialize(@web_socket : HTTP::WebSocket)
            @web_socket.on_message do |message|
                parsed_message = Hash(String, JSON::Any).from_json(message)
                if parsed_message.has_key?("method") && parsed_message["method"] == "eth_subscription"
                    @on_event.try &.call(
                        parsed_message["params"]["subscription"].as_s,
                        parsed_message["params"]["result"]
                    )
                else
                    @on_response.try &.call(parsed_message["id"].as_i, parsed_message["result"])
                end
            end

            spawn do
                @web_socket.run
            end
        end

        def on_event(&@on_event : String, JSON::Any ->)
        end

        def on_response(&@on_response : Int32, JSON::Any ->)
        end

        def send(id, method_name, params)
            message = {
                "jsonrpc" => "2.0",
                "method" => method_name,
                "params" => params,
                "id" => id
            }.to_json

            @web_socket.send message
        end
    end
end
