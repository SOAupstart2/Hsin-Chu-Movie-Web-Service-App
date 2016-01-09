# Service object to post user information and
class GetMovieData
  def initialize(params, url)
    @name = params[:movie_name]
    @time = params[:search_time]
    @language = params[:language]
    @location = params[:location]
    @url = url
  end

  def call
    response = HTTParty.get(
      @url,
      body: { name: @name, 
              time: @time,
              language: @language,
              location: @location
            }.to_json
    )

  end
end