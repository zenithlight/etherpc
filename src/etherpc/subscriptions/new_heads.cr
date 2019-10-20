require "big"

require "../request"

module Etherpc::Subscriptions
    struct NewHeads < Etherpc::Subscription
        def get_params : JSON::Any
            # TODO: better handling for default block parameter
            JSON::Any.new [JSON::Any.new "newHeads"]
        end

        def NewHeads.deserialize_response(response : JSON::Any)
            response
        end
    end
end
