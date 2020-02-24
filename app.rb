require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "4041b75045628c01885c0965c88a8e70"


#LOCATION ASK:
get "/" do
  # show a view that asks for the location
  view "ask"
end

#WEATHER & NEWS:

get "/news" do
  # do everything else
    @location = params["location"]
    @geocoder_results = Geocoder.search(@location)
    lat_long = @geocoder_results.first.coordinates
    lat = "#{lat_long[0]}"
    long = "#{lat_long[1]}"
       
    @forecast = ForecastIO.forecast("#{lat_long[0]}","#{lat_long[1]}").to_hash
    @current_temp = @forecast["currently"]["temperature"]
    @current_summary = @forecast["currently"]["summary"]

    for @day in @forecast["daily"]["data"] do
        @daytemp = @day["temperaturehigh"]
        @daysum = @day["summary"]
    end

    # @news_stories=HTTParty.get(url).parsed_response.to_hash 
    # url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=eb952467a01944eea150c6847b3bd204"
 
    view "news"
end