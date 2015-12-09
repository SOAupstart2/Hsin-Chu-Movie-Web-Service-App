# Service object to get movie information from API
class GetMovieInfoFromAPI
  def initialize(params, settings)
    @id = params[:id]
    @name = params[:name] unless params[:name].empty?
    @time = params[:time] unless params[:time].empty?
    @settings = settings
  end

  def name_or_time?
    if @name && @time
      "name=#{@name}&time=#{@time}"
    elsif @name
      "name=#{@name}"
    elsif @time
      "time=#{@time}"
    else 'name='
    end
  end

  def call
    url = "#{@settings.api_server}/#{@settings.api_ver}/users/#{@id}/"\
          "?#{name_or_time?}"
    HTTParty.get(url)
  end
end
