require "rubygems"
require "bundler/setup"
require 'sinatra'
require "json"
require "twitter"

require_relative "TwitterReader"
require_relative "webhook"

set :environment, :production

class Main < Sinatra::Base

  include TwitterRead
  include Webhook

    configure do
      set :twitterread, TwitterReader.new
      set :postdialog, Hash.new
    end

      get '/' do
        "Hello"
      end

      #DialogFlowからのpost
      post '/webhook' do
          begin
            obj = JSON.parse(request.body.read)
            intent = obj["result"]["parameters"]["intent"]

            case intent
            when "callme" then
               settings.postdialog =  Callme.new.input("#{obj["result"]["parameters"]["keyword"]}")

              #webhookの動作確認
            when "webhook" then
                settings.postdialog = My_webhook.new.input

            #ツイートの取得
            when "tweetread" then
              tweets = obj["result"]["parameters"]["number"]
              settings.postdialog = Twitter_homeline.new.input(tweets)

            #呟き
            when "twitter_tweet" then
              tweet = obj["result"]["parameters"]["tweet"]
              settings.postdialog = Twitter_tweet.new.input("#{tweet}")

            when "twitter_trend" then
              number = obj["result"]["parameters"]["number"]
              settings.postdialog = Twitter_trend.new.input("#{number}")
            else
                  settings.postdialog = {
                      speech: "全てにヒットしませんでした"
                    }
            end
          rescue => e
            settings.postdialog = {
                speech: "エラーが発生しました #{e.message} #{e.backtrace}"
             }
          end
          return settings.postdialog.to_json
      end
    run!
end
