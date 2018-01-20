require "rubygems"
require "bundler/setup"
require 'sinatra'
require "json"

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

get '/webhook' do

  hash = {
             speech: "こんにちは、こちらはサーバプログラムです。"

           }
  return hash.to_json

end
