require_relative "config.rb"

unless defined? BoomerBot::CONFIG
  puts "Did you copied the config.example.rb file to config.rb?"
  puts "Cannot find BoomerBot::CONFIG, exiting."
  exit 1
end

unless defined? BoomerBot::DISCORD_TOKEN
  puts "Cannot find BoomerBot::DISCORD_TOKEN, exiting."
  exit 1
end

require_relative "src/client"
