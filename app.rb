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
  # show a view that asks for the location

  get "/" do
  view "ask"
end

#WEATHER & NEWS:
  # do everything else


#WEATHER:
get "/news" do
    @location = params["location"].capitalize
    @geocoder_results = Geocoder.search(@location)
    lat_long = @geocoder_results.first.coordinates
    lat = "#{lat_long[0]}"
    long = "#{lat_long[1]}"
       
    @forecast = ForecastIO.forecast("#{lat_long[0]}","#{lat_long[1]}").to_hash
    @current_temp = @forecast["currently"]["temperature"]
    @current_summary = @forecast["currently"]["summary"].downcase
    @daytemphigh= []
    @daytemplow=[]
    @daysum= []


    for @day_forecast in @forecast["daily"]["data"] do
         @daytemphigh << @day_forecast["temperatureHigh"]
         @daytemplow << @day_forecast["temperatureLow"]
         @daysum << @day_forecast["summary"]
    end

    
    @url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=eb952467a01944eea150c6847b3bd204"
      @news = HTTParty.get(@url).parsed_response.to_hash
      @news_title=[]
      @story_link=[]

    for daily_news in @news["articles"] do
        @news_title << daily_news["title"]
        @story_link << daily_news["url"]
    end
    
    view "news"
end