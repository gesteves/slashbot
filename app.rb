# encoding: utf-8
require 'sinatra'
require 'json'
require 'httparty'
require 'date'

post '/slash' do
  case params[:command]
  when '/freshpots'
    freshpots(params)
  when '/beer'
    beer(params)
  end
  status 200
  body ''
end

def freshpots(params)
  token = params[:token]
  channel_id = params[:channel_id]
  user = params[:user_name]
  text = "FRESH POTS! @#{user} has brewed a fresh pot of coffee #{params[:text]}"
  payload = { :channel => channel_id,
              :text => text,
              :username => 'coffeebot',
              :icon_emoji => ':coffee:',
              :link_names => 1 }
  if token == ENV['FRESH_POTS_TOKEN']
    post_response(payload)
  end
end

def beer(params)
  token = params[:token]
  channel_id = params[:channel_id]
  text = "Beer's here!"
  payload = { :channel => channel_id,
              :text => text,
              :username => 'beerbot',
              :icon_emoji => ':beers:',
              :link_names => 1 }
  if token == ENV['BEERBOT_TOKEN']
    post_response(payload)
  end
end

def post_response(payload)
  uri = ENV['INCOMING_WEBHOOK']
  HTTParty.post(uri, :body => { 'payload' => payload.to_json })
end