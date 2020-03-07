# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['TOKEN'],
  client_id: ENV['CLIENT_ID'],
  prefix: '/'
)

bot.command :hello do |event|
  event.send_message('今日も一日がんばるぞい！')
end

bot.run
