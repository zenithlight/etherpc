require "big"
require "http"

require "../src/etherpc"

WEI_IN_GWEI = BigInt.new(10) ** 9
WEI_IN_ETH = BigInt.new(10) ** 18

if ARGV.size < 2
    puts "USAGE: basic [endpoint] [address]"
    exit
end

endpoint = ARGV[0]
address = ARGV[1]

web_socket = HTTP::WebSocket.new endpoint
transport = Etherpc::Transports::WebSocket.new web_socket
client = Etherpc::Client.new transport

gas_price_request = Etherpc::Requests::GasPrice.new
price = (client.call gas_price_request) / WEI_IN_GWEI
puts "Gas costs #{price.format('.', ',')} gwei"

get_balance_request = Etherpc::Requests::GetBalance.new address
balance = (client.call get_balance_request) / WEI_IN_ETH
puts "You have #{balance.format('.', ',')} ether"
