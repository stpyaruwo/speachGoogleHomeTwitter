require "rubygems"
require "bundler/setup"
require 'sinatra'
require "json"
require "twitter"

require_relative "webhook"
require_relative "callme"
require_relative "mywebhook"
require_relative "twitterhomeline"
require_relative "twittertweet"
require_relative "twittertrend"

set :environment, :production

class Main < Sinatra::Base

  include Webhook

  configure do
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
        settings.postdialog = Mywebhook.new.input

        #homelineの確認
      when "tweetread" then
        tweets = obj["result"]["parameters"]["number"]
        settings.postdialog = Twitterhomeline.new.input(tweets)

        #呟き
      when "twitter_tweet" then
        tweet = obj["result"]["parameters"]["tweet"]
        settings.postdialog = Twittertweet.new.input("#{tweet}")

        #トレンドの表示
      when "twitter_trend" then
        number = obj["result"]["parameters"]["number"]
        settings.postdialog = Twittertrend.new.input("#{number}")

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
