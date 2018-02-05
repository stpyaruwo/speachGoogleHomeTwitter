require "rubygems"
require "bundler/setup"
require 'sinatra'
require "json"
require "twitter"

require_relative "TwitterReader"
require_relative "webhook"

set :environment, :production #外部接続のためのコード

class Main < Sinatra::Base

  include TwitterRead #TwitterReaderのモジュールをinclude
  include Webhook

    #settings.変数名　で呼び出すことができる
    configure do
      set :twitterread, TwitterReader.new
      set :postdialog, Hash.new
    end

    #音声の使い方(how to use)
      get '/' do
        "Hello"
      end

      #DialogFlowからのpost
      post '/webhook' do
        #①DialogFlowからjsonリクエストを受け取る
               obj = JSON.parse(request.body.read)
               #②リクエストの内容によって処理を変える
               intent = obj["result"]["parameters"]["intent"]

               case intent
               when "callme" then
                  settings.postdialog =  Callme.new().input("#{obj["result"]["parameters"]["keyword"]}")

               #webhookの動作確認
               when "webhook" then
                   settings.postdialog = My_webhook.new().input

               when "tweetread" then
                 #ツイートの取得件数s
                     tweets_num = obj["result"]["parameters"]["number"]
                 #ホームラインラインから、指定された数字まで、取得する
                     settings.postdialog = Twitter_homeline.new().input(tweets_num)
               when "twitter_tweet" then
                 #呟く
                     tweet = obj["result"]["parameters"]["tweet"]
                     settings.postdialog = Twitter_tweet.new().input("#{tweet}")
               else
                   settings.postdialog = {
                         speech: "全てにヒットしませんでした"
                   }
               end
               #③DialogFlowに返す
               return settings.postdialog.to_json
      end

      #speech用のmethod String => Hash
      def speechhome(says)
          speechhash = {
              speech:says
          }
          return speechhash
       end
    run!
end
