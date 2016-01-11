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

  def remake_data(key, data, search_time='', film_info = [])
    data[key].each do |cinema, movies|
      movies.each do |movie, dates|
        dates.each do |date, times|
          times.each do |time|
            start_time = Time.parse(date + ' ' + time)
            end_time = start_time + 5400
            if search_time.empty?
              film_info << [movie, cinema, start_time.to_s, end_time.to_s]
            elsif (start_time - Time.parse(search_time)).between?(0, 86_400)
              film_info << [movie, cinema, start_time.to_s, end_time.to_s]
    end end end end end
    film_info
  end
  
  def what_to_get?
    if @name.empty? && @time.empty? then 'empty'
    elsif @name.empty? then 'time'
    elsif @time.empty? then 'name'
    else 'both' end
  end

  def call(result = [])
    data = go_to_api
    case what_to_get?
      when 'empty' then result
      when 'time' then result << remake_data('search_time', data)
      when 'name' then remake_data('search_name', data).group_by{|x| x[2].split(' ')[0]}.values
      when 'both' then result << remake_data('search_name', data, @time)
    end
  end
end
