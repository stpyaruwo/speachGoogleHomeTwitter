require_relative 'webhook'

module Webhook
  class Twittertrend < Superwebhook
    def input(tweets)
      tweets = tweets.to_i rescue "error"

      if tweets.kind_of?(Integer) && max_tweet(tweets, 30)
        response = @endpoint.get("https://api.twitter.com/1.1/trends/place.json?id=23424856")
        result = JSON.parse(response.body)
        says = "はい！#{tweets}件分のトレンドを読み込みます。  "
        0.upto(tweets - 1) do |count|
          says += "#{count + 1}件目は、 #{result[0]["trends"][count]["name"]}です。 "
        end
        speech_voice(says)

      elsif tweets.kind_of?(Integer)
        says = "#{tweets}件は読み込めません"
        speech_voice(says)
      else tweets == "error"
        says = "エラーが発生しました。"
        speech_voice(says)
      end

      return @speechtoken
    end
  end
end

