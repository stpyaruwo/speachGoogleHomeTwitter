require_relative 'webhook'

module Webhook
  class Twittertweet < Superwebhook
    def input(say)
      @client.update("#{say}")
      speech_voice("#{say}と呟きました。")
      return @speechtoken
    end
  end
end
