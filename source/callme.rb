require_relative 'webhook'

module Webhook
  class Callme <  Superwebhook
    def input(says)
      speech_voice(says + "とおっしゃいましたね!")
      return @speechtoken
    end
  end
end
