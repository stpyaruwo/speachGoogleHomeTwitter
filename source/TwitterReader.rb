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
      end

      #ツイートの読み込み(homeline上の3件分)
      def readtweet
          #タイムラインを返却する <= Array
          return @client.home_timeline( { count: 3} )
      end
  end
end
