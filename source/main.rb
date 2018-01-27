require "rubygems"
require "bundler/setup"
require 'sinatra'
require "json"
require "twitter"

require_relative "TwitterReader"

set :environment, :production #外部接続のためのコード

#sinnatraを継承し、使用する
class Main < Sinatra::Base

  include TwitterRead #TwitterReaderのモジュールをinclude

    #settings.変数名　で呼び出すことができる
    configure do
      set :twitterread, TwitterReader.new
      set :postdialog, Hash.new
    end

    #postのテスト②
      get '/' do
        "Hello"
      end

      #postのテスト②
      post '/login' do
        login_name = params[:login]
        password = params[:pass]

        hash = {
                   login_info: "こんにちは、#{login_name}さん パスワードは#{password}"

                 }
        return hash.to_json
      end

      #DialogFlowからのpost
      post '/webhook' do

        #①DialogFlowからjsonリクエストを受け取る
        obj = JSON.parse(request.body.read)

        #②リクエストの内容によって処理を変える
        intent = obj["result"]["parameters"]["intent"]

        case intent
        #会話内容の確認
        when "callme" then
            settings.postdialog = {
                  speech: "#{obj["result"]["parameters"]["keyword"]}とおっしゃいましたね!"
            }
        #webhookの動作確認
        when "webhook" then
            t = Time.new
            settings.postdialog = {
                  speech: "#{t.month}月#{t.day}日の#{t.hour}時#{t.min}分現在は正常に稼働しております。あつしさん!"
            }

        when "tweetread" then
          #ツイートの取得件数
              tweets_num = obj["result"]["parameters"]["number"]
          #ホームラインラインから、指定された数字まで、取得する
              settings.postdialog  = settings.twitterread.readtweet(tweets_num)
        else
            settings.postdialog = {
                  speech: "全てにヒットしませんでした"
            }
        end

        #③DialogFlowに返す
        return settings.postdialog.to_json
      end

      run!
end
