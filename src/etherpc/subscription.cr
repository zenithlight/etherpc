require "big"

require "./request"

module Etherpc
    abstract struct Subscription < Etherpc::Request
        getter method_name : String = "eth_subscribe"

        def Subscription.deserialize_response(response : JSON::Any)
            # The response is the subscription ID
            response.as_s
        end
    end
end
