require_relative 'webhook'

module Webhook
  class Twitterhomeline < Superwebhook
    def input(tweets)
      tweets = tweets.to_i rescue "error"
      if tweets.kind_of?(Integer) && max_tweet(tweets, 30)
        tweets = @client.home_timeline( { count: tweets} )
        says = "はい！、#{tweets.count}件分のツイートを呼び込みます！"

        tweets.each_with_index do |tweet,count|
          says = says + "#{count + 1} 件目は#{tweet.user.name}が、#{trim_http(tweet.full_text)}と呟いております。"
        end
        speech_voice(says)
      elsif  max_tweet(tweets, 30)
        says = "#{tweets}件は読み込めません"
        speech_voice(says)
      else
        speech_voice("すいません。失敗しました。")
      end
      return @speechtoken
    end
  end
end

