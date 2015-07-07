module Bittrex
  class Balance

    def initialize(attrs = {})
      @raw    = attrs
    end

    def self.all
      client.get('account/getbalances').map{|data| new(data) }
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
