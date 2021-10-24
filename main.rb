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

  # @type [Discorb::Message]
  message = reaction.fetch_message.wait
  next if message.pinned?
  unless [:default, :reply].include? message.type
    sent_message = message.channel.post("→ #{reaction.from.mention}\n\nこのメッセージはピン留めできません。").wait
    sleep 5
    sent_message.delete!
    next
  end
  message.pin.wait
end

client.on :reaction_remove do |reaction|
  next if reaction.emoji != Discorb::UnicodeEmoji["pushpin"]

  message = reaction.fetch_message(force: true).wait
  next unless message.pinned?

  message.unpin
end

client.load_extension(Dispander::Core)

client.change_presence(Discorb::Activity.new(":pushpin:でピン留め"))

client.run ENV["TOKEN"]
