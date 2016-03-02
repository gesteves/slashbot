# encoding: utf-8
require 'sinatra'
require 'json'
require 'httparty'
require 'date'

post '/slash' do
  case params[:command]
  when '/freshpots'
    freshpots(params)
  when '/happyhour'
    happy(params)
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

def happy(params)
  token = params[:token]
  channel_id = params[:channel_id]
  text = "It’s happy hour! Come to the kitchen for drinks and to mingle and catch up with your coworkers."
  payload = { :channel => channel_id,
              :text => text,
              :username => 'happybot',
              :icon_emoji => ':party:',
              :link_names => 1 }
  if token == ENV['BEERBOT_TOKEN']
    post_response(payload)
  end
end

def post_response(payload)
  uri = ENV['INCOMING_WEBHOOK']
  HTTParty.post(uri, :body => { 'payload' => payload.to_json })
end
