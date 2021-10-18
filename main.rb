require "discorb"
require "dotenv"
require "dispander"

Dotenv.load

client = Discorb::Client.new

client.once :standby do
  puts "Logged in as #{client.user}"
end

client.on :reaction_add do |reaction|
  next if reaction.emoji != Discorb::UnicodeEmoji["pushpin"]

  message = reaction.fetch_message.wait
  next if message.pinned?

  message.pin
end

client.on :reaction_remove do |reaction|
  next if reaction.emoji != Discorb::UnicodeEmoji["pushpin"]

  message = reaction.fetch_message(force: true).wait

  message.unpin
end

client.load_extension(Dispander::Core)

client.change_presence(Discorb::Activity.new(":pushpin:でピン留め"))

client.run ENV["TOKEN"]
