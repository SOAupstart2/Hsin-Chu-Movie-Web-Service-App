# Service object to get movie information from API
class GetMovieInfoFromAPI
  def initialize(params, settings)
    @id = params[:id]
    @name = params[:name]
    @time = params[:time]
    @settings = settings
  end

  def name_or_time?
    if @name
      "name=#{@name}"
    elsif @time
      "time=#{@time}"
    end
  end

  def call
    url = "#{@settings.api_server}/#{@settings.api_ver}/users/#{@id}/"\
          "?#{name_or_time?}"
    HTTParty.get(url)
  end
end
