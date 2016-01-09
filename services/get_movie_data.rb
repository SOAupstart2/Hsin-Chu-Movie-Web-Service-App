# Service object to post user information and
class GetMovieData
  def initialize(user_form, url)
    @name = user_form.movie_name
    @time = user_form.search_time
    @language = user_form.language
    @location = user_form.location
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