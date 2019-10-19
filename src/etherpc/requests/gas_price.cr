require "big"

require "../request"

module Etherpc::Requests
    struct GasPrice < Etherpc::Request
        getter method_name : String

        def initialize
            @method_name = "eth_gasPrice"
        end

        def get_params : Array(JSON::Any)
            [] of JSON::Any
        end

        def GasPrice.deserialize_response(response : JSON::Any)
            response.as_s[2..].to_big_i(16)
        end
    end
end
