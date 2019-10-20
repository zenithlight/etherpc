require "json"

# TODO: these should be code-generated at some point. Maybe using macros?

module Etherpc
    abstract struct Request
        abstract def method_name : String
        abstract def get_params : JSON::Any

        # Abstract class methods not allowed (yet?)
        # abstract def deserialize_response(response : JSON::Any)
    end
end
