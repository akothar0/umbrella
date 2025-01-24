# Write your soltuion here!
require "dotenv/load"
require "active_support/all"
require "awesome_print"
require "pry-byebug"
require "http"
require "json"

# Ask the user for their location
# Get and store the user’s location.
puts "Where you at?" 
user_location = gets.chomp

# Get the user’s latitude and longitude from the Google Maps API.
gmaps_api_key = ENV.fetch("GMAPS")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + gmaps_api_key
raw_response = HTTP.get(gmaps_url)
parsed_response = JSON.parse(raw_response)
lat = parsed_response["results"][0]["geometry"]["location"]["lat"]
lng = parsed_response["results"][0]["geometry"]["location"]["lng"]

# Get the weather at the user’s coordinates from the Pirate Weather API.
raw_weather = HTTP
pirate_api_key = ENV.fetch("PIRATE")
pirate_url = "https://api.pirateweather.net/forecast/" + pirate_api_key + "/" + lat.to_s + "," + lng.to_s
raw_response = HTTP.get(pirate_url)
parsed_response = JSON.parse(raw_response)

# Display the current temperature and summary of the weather for the next hour.
current_temperature = parsed_response["currently"]["temperature"]
summary = parsed_response["currently"]["summary"]

# If you get that far, then stretch further:For each of the next twelve hours, check if the precipitation probability is greater than 10%.
flag = false
12.times do |counter|
  if parsed_response["hourly"]["data"][counter]["precipProbability"] > 0.10
    flag = true
  end
end

if flag
  pp "It's probably going to rain"
else
  pp "It probably won't rain"
end
  

# pp parsed_response["hourly"]["data"][0]["precipProbability"]

# If so, print a message saying how many hours from now and what the precipitation probability is.

# If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”If not, print “You probably won’t need an umbrella today.”
