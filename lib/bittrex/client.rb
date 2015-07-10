require 'faraday'
require 'base64'
require 'json'
require_relative '../faraday_params_encoder'

module Bittrex
  class Client
    HOST = 'https://bittrex.com/api/v1.1'

    attr_reader :key, :secret

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
    end

    def get(path, params = {}, headers = {})
      nonce = Time.now.to_i
      response = connection.get do |req|

        if key
          req.params[:apikey]   = key
          req.params[:nonce]    = nonce
        end

        req.params.merge!(params)
        url = "#{HOST}/#{path}#{params_to_url(req.params)}"
        req.url(url)

        req.headers[:apisign] = signature(url, nonce) if key

      end

      if JSON.parse(response.body)['result'].class.is_a? Array
        puts response.body
        (JSON.parse(response.body)['result'])[0]
      else
        puts response.body
        JSON.parse(response.body)['result']
      end
    end

    private

    def params_to_url(item, keyval_delimeter = '=', pair_delimeter = '&')
      '?' + (item.map {|e| e.join(keyval_delimeter) }.join(pair_delimeter))
    end

    def signature(url, nonce)
      OpenSSL::HMAC.hexdigest('sha512', secret, url)
    end

    def connection
      @connection ||= Faraday.new(:url => HOST, request: {params_encoder: Faraday::BittrexFlatParamsEncoder}) do |faraday|
        faraday.request   :url_encoded
        faraday.adapter   Faraday.default_adapter
      end
    end
  end
end
