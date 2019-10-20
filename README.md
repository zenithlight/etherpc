# Etherpc

Idiomatic Ethereum/Infura JSON-RPC client for Crystal, supporting WebSockets and subscriptions.

*Below is the aspirational API and doesn't work yet.*

```crystal
client = Etherpc::WebSocketClient.new "wss://mainnet.infura.io/ws/v3/#{PROJECT_ID}"

price = client.gas_price
puts "Gas costs #{price.to_gwei} gwei"

token = Etherpc::Contracts::Erc20 "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2", client
balance = token.balance_of "0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8"
puts "You have #{balance} #{token.symbol}"

number_of_messages = 0
client.new_heads do |subscription|
    subscription.each_event do |event|
        number_of_messages += 1
        subscription.cancel if number_of_messages == 10
    end
end
```

## Examples

Examples can be found in the [examples](examples) folder.

To run them, do:

```
$ crystal run examples/basic.cr -- [endpoint] [address]
$ crystal run examples/subscription.cr -- [endpoint]
```

## Roadmap

High-priority items that need to be done before v0.1:

- [ ] Refactor subscription API
- [ ] HTTP transport
- [ ] Helper factories to create clients with a given transport
- [ ] Support for most of the geth/Infura RPC calls
- [ ] Thorough specs
- [ ] Error handling

Longer term:

- [ ] Contract ABI support
- [ ] Use mappings for deserialization
- [ ] Move common internal functions into `util.cr`
- [ ] `to_ether`/`to_gwei`/`to_bloom_filter` utility functions
- [ ] Infura authenticated endpoint helpers
- [ ] `parity_subscribe` support
- [ ] Possibly high-level account/wallet API
