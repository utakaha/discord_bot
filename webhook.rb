require 'discordrb/webhooks'
require 'dotenv/load'

client = Discordrb::Webhooks::Client.new(url: ENV['WEBHOOK_URL'])

client.execute do |builder|
  builder.content = '今日も一日がんばるぞい！'
end
