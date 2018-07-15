require "twitter"

module TwitterRead
  class TwitterReader
    def initialize()
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key         = File.open('env/consumer_key').read.chomp
        config.consumer_secret      = File.open('env/consumer_secret').read.chomp
        config.access_token         = File.open('env/access_token').read.chomp
        config.access_token_secret  = File.open('env/access_token_secret').read.chomp
      end
      @postdialog = Hash.new
    end

      #ツイートの読み込み(homeline)
    def readtweet(tweets_num)
      tweets_num = tweets_num.to_i

      if tweets_num.kind_of?(Integer)
        tweets = @client.home_timeline( { count: tweets_num} )
        says = "はい！、#{tweets.count}件分のツイートを呼び込みます！"

        tweets.each_with_index do |tweet,count|
          says = says + "#{count + 1} 件目は#{tweet.user.name}が、#{trim_http(tweet.full_text)}と呟いております。"
        end

        @postdialog = {
             speech:says
         }
      else
        @postdialog = {
            speech:"すいません。失敗しました。"
        }
      end
      return @postdialog
    end

    def trim_http(url)
      url = url.gsub(/http([s]|):\/\/[\wW\/:%#\$&\?\(\)~\.=\+\-]+/, "")
      return url
    end
  end
end
