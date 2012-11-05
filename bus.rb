require 'rubygems'
require 'sinatra'
require 'rest-client'
require 'json'
require 'time'

AGENCY_ID = 132
STOP_ID = 4068514

get '/' do
  minutes = eta
  if minutes.nil?
    @info = "No Bus :("  
  elsif minutes < 2
    @info = "Hurry! E.T.A #{minutes.to_s} minutes"
  elsif minutes > 15
    @info = "E.T.A #{minutes.to_s} minutes ... just walk!"
  else
    @info = "E.T.A #{minutes.to_s} minutes"
  end
  erb :index
end

def eta

  website = RestClient.get("http://api.transloc.com/1.1/arrival-estimates.json",
   {:params=> {:agencies=>AGENCY_ID, :stops=> STOP_ID}})
  data = JSON.load(website)["data"]
 
  if data.empty?
    time = nil
  else  
    arrival = data.first['arrivals'].first["arrival_at"]
    seconds = Time.parse(arrival)-Time.now()
    time = (seconds/60).floor;
  end

  return time
end

