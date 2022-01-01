# Assignment 2 for Thrillophilia

require "httparty"
require "dotenv"
require "csv"
require 'faker'
Dotenv.load("token.env")

# Function 1
# Function that takes place name as input and make an API call to get weather details of that place
def weather(place)
    api = ENV["TOKEN"]
    url = "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=#{api}&q=#{place}"
    response = HTTParty.get(url)
    place_id = response[0]["Key"]
    url = "http://dataservice.accuweather.com/currentconditions/v1/#{place_id}?apikey=#{api}"
    response = HTTParty.get(url)

    # final response 
    puts "The weather in #{place} is #{response[0]["WeatherText"]} with a temperature of #{response[0]["Temperature"]["Metric"]["Value"]} degrees Celsius."
end

# Function 2
# Function that takes CSV File as input with 2 columns. Segregate this file into different files based on the column values
def csv_segregator
    # open the 5 types of files
    delivered = CSV.open("./files/delivered.csv", "w")
    bounced = CSV.open("./files/bounced.csv", "w")
    sent = CSV.open("./files/sent.csv", "w")
    opened = CSV.open("./files/opened.csv", "w")
    failed = CSV.open("./files/failed.csv", "w")

    # read the main file
    CSV.foreach("./files/mainfile.csv") do |row|
        if row[1] == "delivered"
            delivered << row
        elsif row[1] == "bounced"
            bounced << row
        elsif row[1] == "sent"
            sent << row
        elsif row[1] == "opened"
            opened << row
        else
            failed << row
        end
    end

    # close all the files
    delivered.close
    bounced.close
    sent.close
    opened.close
    failed.close
end

# Main Part

# Function 1

puts "\nFunction 1 :: Weather\nEnter the place name:"
place = gets.chomp()
weather(place)

# Function 2

puts "\nFunction 2 :: CSV Segregator"
# Creating random CSV File
status = Array["delivered", "bounced", "sent", "opened", "failed"]
CSV.open("./files/mainfile.csv", "w") do |csv|
    csv << ["Email", "Status"]
    for i in 1..5000
        csv << [Faker::Internet.email,status[Random.rand(0..4)]]
    end
end
puts "Random Large CSV File Created ...."

# Segregating CSV File
csv_segregator()
puts "CSV Files Segregated!"