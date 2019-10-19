require "spec"

require "../../../src/etherpc/requests/get_balance"

ADDRESS = "0x3a26316CC4B8dc935Fb933b59e28573c3FE4dA6F"

module Etherpc::Requests
    describe GetBalance do
        describe "#get_params" do
            it "returns an array containing the address and 'latest'" do
                request = GetBalance.new ADDRESS
                request.get_params.should eq [ADDRESS, "latest"]
            end
        end

        describe ".deserialize_response" do
            it "converts small hexadecimal string to an int" do
                GetBalance.deserialize_response("0xff").should eq 255
            end

            it "converts big hexadecimal string to an int" do
                GetBalance.deserialize_response("0x2fe84e3113d7b").should eq 842796652117371
            end
        end
    end
end
