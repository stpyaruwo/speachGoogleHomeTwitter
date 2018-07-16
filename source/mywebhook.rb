require_relative 'webhook'

module Webhook
  class Mywebhook < Superwebhook
    def input
      t = Time.new
      speech_voice("#{t.month}月#{t.day}日の#{t.hour}時#{t.min}分現在は正常に稼働しております")
      return @speechtoken
    end
  end
end

