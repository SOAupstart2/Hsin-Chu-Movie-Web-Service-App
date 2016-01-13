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
            start_time = DateTime.parse("#{date} #{time}+8")
            start_time += 1 if MIDNIGHT.include? time[HOUR]
            end_time = start_time + DURATION
            film_info << [movie, cinema, start_time.to_s, end_time.to_s]
    end end end end
    film_info
  end
  
  def what_to_get?
    if @name.empty? && @time.empty? then 'empty'
    elsif @name.empty? then 'time'
    elsif @time.empty? then 'name'
    else 'both' end
  end

  def group_by_date(data)
    data.group_by{|x| x[2].split('T')[0]}.values
  end

  def call()
    data = go_to_api
    case what_to_get?
      when 'empty' then []
      when 'time' then group_by_date(remake_data('search_time', data))
      when 'name' then group_by_date(remake_data('search_name', data))
      when 'both' then group_by_date(remake_data('search_name', data))
    end
  end
end
