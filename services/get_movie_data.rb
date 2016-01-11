MIDNIGHT = %w(00 01 02 03 04)
HOUR = 0..1
DURATION = 2 / 24.to_f

# Service object to get movie data from API
class GetMovieData
  def initialize(user_form, url)
    @name = user_form.movie_name
    @time = user_form.search_time
    @language = user_form.language
    @location = user_form.location
    @url = url
  end

  def go_to_api
    body = { language: @language, location: @location }
    body = body.merge(name: @name) unless @name.empty?
    body = body.merge(time: @time) unless @time.empty?
    HTTParty.get(@url, body: body)
  end

  def what_to_get?
    return %w(search_name search_time) unless @name.empty? && @time.empty?
    if @time.empty?
      %w(search_name) unless @name.empty?
    else %w(search_time)
    end
  end

  def work_on_movies(movies, cinema, films = [])
    movies.each do |movie, dates|
      dates.each do |date, times|
        date = Date.parse date
        times.each do |time|
          date += 1 if MIDNIGHT.include? time[HOUR]
          start_time = DateTime.parse("#{date} #{time}+8")
          end_time = start_time + DURATION
          films << [movie, cinema, start_time.to_s, end_time.to_s]
        end; end; end
    films
  end

  def call(results = Hash.new { |k, v| k[v] = {} })
    return results if what_to_get?.nil?
    what_to_get?.each do |name_or_time|
      go_to_api[name_or_time].each do |cinema, movies|
        results[name_or_time][cinema] = work_on_movies(movies, cinema)
      end
    end
    results
  end
end
