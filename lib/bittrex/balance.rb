module Bittrex
  class Balance

    def initialize(attrs = {}, currency = nil)
      @raw    = attrs
    end

    def self.all
      client.get('account/getbalances').map{|data| new(data) }
    end

    def self.one(currency)
      new(client.get('account/getbalance', currency: currency), currency)
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
