require "rubygems"
require "bundler/setup"
require 'sinatra'
require "json"

get '/' do
  "Hello world" #最初のサンプル
  "日本語のテスト"
end
