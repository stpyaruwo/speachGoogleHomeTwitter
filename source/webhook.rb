require "twitter"
require "oauth"
require "json"

module Webhook
  class Superwebhook
    def initialize()
      @speechtoken = { speech: "" }
      #注意箇所　絶対keyを乗せてはいけない　
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key         = File.open('env/consumer_key').read.chomp
        config.consumer_secret      = File.open('env/consumer_secret').read.chomp
        config.access_token         = File.open('env/access_token').read.chomp
        config.access_token_secret  = File.open('env/access_token_secret').read.chomp
      end

      consumer = OAuth::Consumer.new(
          @client.consumer_key,
          @client.consumer_secret,
          site:'https://api.twitter.com/'
      )
      @endpoint = OAuth::AccessToken.new(consumer, @client.access_token, @client.access_token_secret)
    end

    def input

    end

    #mainに返すHashデータを定義する
    def speech_voice(says)
      @speechtoken[:speech] = says
    end

    #httpのデータを削除する
    def trim_http(url)
      url = url.gsub(%r{https?://[\w_.!*\/')(-]+}, "")
      return url
    end

    def max_tweet(num_tweets,max)
      if num_tweets <= max &&  1 <= num_tweets
        return true
      else
        return false
      end
    end
  end
end
