module Etherpc
    abstract class Transport
        abstract def send(id, method_name, params)
    end
end
