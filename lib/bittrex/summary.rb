require 'time'

module Bittrex
  class Summary
    attr_reader :market, :name, :high, :low, :volume, :last, :base_volume, :raw, :created_at

    alias_method :vol, :volume
    alias_method :base_vol, :base_volume

    def initialize(market, attrs = {})
      @market       = market
      @name         = attrs[0]['MarketName']
      @high         = attrs[0]['High']
      @low          = attrs[0]['Low']
      @volume       = attrs[0]['Volume']
      @last         = attrs[0]['Last']
      @base_volume  = attrs[0]['BaseVolume']
      @raw          = attrs[0]
      @created_at   = Time.parse(attrs[0]['TimeStamp'])
    end

    def self.one(market)
      new(market, client.get('public/getmarketsummary', market: market))
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
