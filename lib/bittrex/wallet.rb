module Bittrex
  class Wallet
    attr_reader :id, :currency, :balance, :available, :pending, :address, :requested, :raw

    def initialize(attrs = {})
      @address = attrs['CryptoAddress']
      @available = attrs['Available']
      @balance = attrs['Balance']
      @currency = attrs['Currency']
      @pending = attrs['Pending']
      @raw = attrs
      @requested = attrs['Requested']
    end

    def self.all
      client.get('account/getbalances').map{|data| new(data) }
    end

    def self.one(currency)
      new(client.get('account/getbalance', currency: currency))
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
