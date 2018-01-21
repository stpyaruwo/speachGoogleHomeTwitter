require "rubygems"
require "bundler/setup"
require 'sinatra'
require "json"

set :environment, :production #外部接続のためのコード

#postのテスト①
get '/' do
  erb :input_form
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

post '/webhook' do

  #JSONパラメータを読み込む
  obj = JSON.parse(request.body.read)
  keyword = obj["result"]["parameters"]["keyword"]

  #keywordにオブジェクトが代入されてる場合
  if keyword != nil
      hash = {
            speech: "#{keyword}とおっしゃいましたよね!"
      }
  else
      hash = {
              speech: "こんにちは、こちらはサーバプログラムです。atsushiさん"

          }
  end

  return hash.to_json

end
