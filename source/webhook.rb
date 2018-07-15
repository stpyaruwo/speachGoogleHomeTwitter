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

      def max_tweet(is_tweets,max)
            if is_tweets <= max &&  1 <= is_tweets
              return true
            else
              return false
            end
      end
   end

   #言葉を読み上げる
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
         speech_voice("#{t.month}月#{t.day}日の#{t.hour}時#{t.min}分現在は正常に稼働しております")
         return @speechtoken
      end
   end

  #ホームラインから、ツイートの情報を読み込む
   class Twitter_homeline < Superwebhook
     #読み込むツイート数を決める
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

  #呟く
   class Twitter_tweet < Superwebhook
      def input(says)
          #呟く
          @client.update("#{says}")
          speech_voice("#{says}と呟きました。")
          return @speechtoken
      end
    end

    #日本のトレンドをあげる
    class Twitter_trend < Superwebhook

      def input(tweets)
        tweets = tweets.to_i rescue "error"

        if tweets.kind_of?(Integer) && max_tweet(tweets, 30)
          response = @endpoint.get("https://api.twitter.com/1.1/trends/place.json?id=23424856")
          result = JSON.parse(response.body)
          says = "はい！#{tweets}件分のトレンドを読み込みます。  "
              0.upto(tweets - 1) do |count|
                  says =  says + "#{count + 1}件目は、 #{result[0]["trends"][count]["name"]}です。 "
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

    #世界のトレンドの10位をあげる
    class Twitter_world_trend < Superwebhook

    end
end
