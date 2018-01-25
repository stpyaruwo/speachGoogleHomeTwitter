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
        #intentに処理の分岐条件
        intent = obj["result"]["parameters"]["intent"]

        case intent
        when "callme" then
            settings.postdialog = {
                 speech: "#{obj["result"]["parameters"]["keyword"]}とおっしゃいましたね!"
            }
        else
            settings.postdialog = {
                  speech: "全てにヒットしませんでした"
            }
        end

        #③DialogFlowに返す
        return settings.postdialog.to_json
      end

      #Twitterのテスト
      get '/twitterTest' do
        @read = settings.twitterread.readtweet
        erb :readtwitter
      end

      run!
end
