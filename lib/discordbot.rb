# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'
require './lib/command'

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['TOKEN'],
  client_id: ENV['CLIENT_ID'],
  prefix: '/'
)

bot.command :hello do |event|
  event.send_message('今日も一日がんばるぞい！')
end

bot.command :choice do |event, *args|
  event.send_message(choice(args))
end

bot.run
