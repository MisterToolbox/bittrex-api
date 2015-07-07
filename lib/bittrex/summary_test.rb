require 'time'

module Bittrex
  class SummaryTest
    attr_reader :market, :name, :high, :low, :volume, :last, :base_volume, :raw, :created_at

    alias_method :vol, :volume
    alias_method :base_vol, :base_volume

    def initialize(attrs = {}, market = nil)
      if market
        @market       = market
        @name         = attrs[0]['MarketName']
        @high         = attrs[0]['High']
        @low          = attrs[0]['Low']
        @volume       = attrs[0]['Volume']
        @last         = attrs[0]['Last']
        @base_volume  = attrs[0]['BaseVolume']
        @raw          = attrs[0]
        @created_at   = Time.parse(attrs[0]['TimeStamp'])
      else
        @name         = attrs['MarketName']
        @high         = attrs['High']
        @low          = attrs['Low']
        @volume       = attrs['Volume']
        @last         = attrs['Last']
        @base_volume  = attrs['BaseVolume']
        @raw          = attrs
        @created_at   = Time.parse(attrs['TimeStamp'])
    end

    def self.all
      client.get('public/getmarketsummaries').map{|data| new(data) }
    end

    def self.one(market)
      new(client.get('public/getmarketsummary', market: market), market)
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
