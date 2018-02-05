require "twitter"
#post dialogを受け取る親クラス
#処理をintentの処置を起票する

module Webhook
   class Superwebhook
     #グーグルが話す内容について記述する
      def initialize()
          @speechtoken = { speech: "" }
          @client = Twitter::REST::Client.new do |config|
              config.consumer_key        = 'p0oXKXPpcYLKUvTiKJ0gOznfi'
              config.consumer_secret     = '80PePGdetsgofHQOO2bdyGk7TSvIvxoWNItDhg1Fe5ZXf1VcFU'
              config.access_token        = '2504606953-T5yUJQnUcqsEYtvxWyUt2vZFZIrHSsob0JwEUyl'
              config.access_token_secret = 'zxUKm4W5DiJHkLA5CdOdXS83789hOVUWxJtnqG9hCoaU3'
          end
      end
     #mainに返すHashデータを定義する
      def speech_voice(says)
        @speechtoken[:speech] = says
      end

      #httpのデータを削除する
      def trim_http(url)
          #url = url.gsub(/http([s]|):\/\/[\wW\/:%#\$&\?\(\)~\.=\+\-]+/, "")
          url = url.gsub(%r{https?://[\w_.!*\/')(-]+}, "")

          return url
      end
      #override
      #mainからのデータを入れる
      def input
      end
   end

   #言った言葉を読み上げる
   class Callme < Superwebhook
      def input(says)
         speech_voice(says + "とおっしゃいましたね!")
         return @speechtoken
      end
   end

   #webhookの動作検証
   class  My_webhook  < Superwebhook
      def input
         t = Time.new
         speech_voice("#{t.month}月#{t.day}日の#{t.hour}時#{t.min}分現在は正常に稼働しております。あつしさん")
         return @speechtoken
      end
   end

  #ホームラインから、ツイートの情報を読み込む
   class Twitter_homeline < Superwebhook
     #読み込むツイート数を決める
      def input(tweets_num)
         tweets_num = tweets_num.to_i

        if tweets_num.kind_of?(Integer)
             tweets = @client.home_timeline( { count: tweets_num} )
             says = "はい！、#{tweets.count}件分のツイートを呼び込みます！"

             tweets.each_with_index do |tweet,count|
               says = says + "#{count + 1} 件目は#{tweet.user.name}が、#{trim_http(tweet.full_text)}と呟いております。"
             end

            speech_voice(says)
        else
            speech_voice("すいません。失敗しました。")
        end
        return @speechtoken
      end
   end
   
  #呟く
   class Twitter_tweet < Superwebhook
      def input(says)
          #呟く
          @client.update("#{says}")
          speech_voice("#{says}と呟きました。")
          return @speechtoken
      end
    end

end
