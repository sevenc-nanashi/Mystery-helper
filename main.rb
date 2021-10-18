require "discorb"
require "dotenv"

Dotenv.load  # Loads .env file

client = Discorb::Client.new  # Create client for connecting to Discord

client.once :standby do
  puts "Logged in as #{client.user}"  # Prints username of logged in user
end

client.run ENV["TOKEN"]  # Starts client
