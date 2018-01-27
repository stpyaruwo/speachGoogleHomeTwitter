require "twitter"

module TwitterRead
  class TwitterReader
     #認証情報の登録

      def initialize()
            @client = Twitter::REST::Client.new do |config|
              config.consumer_key        = 'p0oXKXPpcYLKUvTiKJ0gOznfi'
              config.consumer_secret     = '80PePGdetsgofHQOO2bdyGk7TSvIvxoWNItDhg1Fe5ZXf1VcFU'
              config.access_token        = '2504606953-T5yUJQnUcqsEYtvxWyUt2vZFZIrHSsob0JwEUyl'
              config.access_token_secret = 'zxUKm4W5DiJHkLA5CdOdXS83789hOVUWxJtnqG9hCoaU3'
            end
            @postdialog = Hash.new
      end

      #ツイートの読み込み(homeline)
      def readtweet(tweets_num)
          #tweetsに数字が入っているかチェックする

          if tweets_num != nil
              #ツイートを配列で受け取る
              tweets = @client.home_timeline( { count: tweets_num} )
              says = "はい！、#{tweets.count}件分のツイートを呼び込みます！"

              tweets.each_with_index do |tweet,count|
                says = says + "#{count + 1} 件目は#{tweet.user.name}が、#{tweet.full_text}と呟いております。"
              end

              @postdialog = {
                    speech:says
               }

          else
              @postdialog = {
                    speech:"すいません。失敗しました。"
              }
          end
          #@postdialog = {
          #    speech: "認証OKです!"
          #}

          return @postdialog
      end
  end
end
