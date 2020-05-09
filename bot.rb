require_relative "config"

unless defined? BoomerBot::CONFIG
  puts "Cannot find BoomerBot::CONFIG, exiting."
  exit 1
end

unless defined? BoomerBot::DISCORD_TOKEN
  puts "Cannot find BoomerBot::DISCORD_TOKEN, exiting."
  exit 1
end

require_relative "src/client"
