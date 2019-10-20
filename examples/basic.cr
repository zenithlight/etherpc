require "big"
require "http"

require "../src/etherpc"

WEI_IN_GWEI = BigInt.new(10) ** 9
WEI_IN_ETH = BigInt.new(10) ** 18

if ARGV.size < 3
    puts "USAGE: basic [endpoint] [address] [token address]"
    exit
end

endpoint = ARGV[0]
address = ARGV[1]
token_address = ARGV[2]

web_socket = HTTP::WebSocket.new endpoint
transport = Etherpc::Transports::WebSocket.new web_socket
client = Etherpc::Client.new transport

gas_price_request = Etherpc::Requests::GasPrice.new
price = (client.call gas_price_request) / WEI_IN_GWEI
puts "Gas costs #{price.format('.', ',')} gwei"

get_balance_request = Etherpc::Requests::GetBalance.new address
balance = (client.call get_balance_request) / WEI_IN_ETH
puts "You have #{balance.format('.', ',')} ether"

new_heads_subscription = Etherpc::Subscriptions::NewHeads.new
client.subscribe new_heads_subscription do |event|
    height = event["number"].as_s[2..].to_i(16)
    puts "New block at height #{height}"

    token_balance_request = Etherpc::Requests::Call.new to: token_address, data: ("0x70a08231000000000000000000000000" + address[2..])
    token_balance = client.call token_balance_request
    puts "You have #{token_balance.as_s[2..].to_big_i(16)} token bits"
end
