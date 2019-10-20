require "big"

require "../request"

module Etherpc::Requests
    struct Call < Etherpc::Request
        getter method_name : String

        def initialize(@to : String, @data : String)
            @method_name = "eth_call"
        end

        def get_params : JSON::Any
            JSON::Any.new [JSON::Any.new({
                "to" => JSON::Any.new(@to),
                "data" => JSON::Any.new(@data)
            }), JSON::Any.new "latest"]
        end

        def Call.deserialize_response(response : JSON::Any)
            response
        end
    end
end
