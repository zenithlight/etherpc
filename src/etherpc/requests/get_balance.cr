require "big"

require "../request"

module Etherpc::Requests
    struct GetBalance < Etherpc::Request
        getter method_name : String

        def initialize(@address : String)
            @method_name = "eth_getBalance"
        end

        def get_params : JSON::Any
            # TODO: better handling for default block parameter
            JSON::Any.new [JSON::Any.new(@address), JSON::Any.new("latest")]
        end

        def GetBalance.deserialize_response(response : JSON::Any)
            response.as_s[2..].to_big_i(16)
        end
    end
end
