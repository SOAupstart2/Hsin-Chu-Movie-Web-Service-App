# Helpers for main sinatra web application
module AppHelpers
  LOCATION = { 'hsinchu' => %w(05 12) }

  def cinema(theater_id)
    CinemaInfo.new(theater_id)
  end

  def cinema_names(theater_id)
    cinema(theater_id).movie_names.to_json
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end

  def cinema_table(theater_id)
    cinema(theater_id).movie_table.to_s
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end

  def film_times(location, film_name)
    LOCATION[location].map do |theater_id|
      name = cinema(theater_id).movie_table.keys[0]
      times = cinema(theater_id).film_times(film_name)
      [name, times]
    end.to_h
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end

  def films_after_time(location, date_time)
    LOCATION[location].map do |theater_id|
      name = cinema(theater_id).movie_table.keys[0]
      times = cinema(theater_id).films_after_time(date_time)
      [name, times]
    end.to_h
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end
  # def check_movie_info(movie_names, times)
  #   @check_info = {}
  #   movie_names.map do |movie_name|
  #     found = MovieInfo.new(movie_name).times
  #     [movie_name, times.select {|time| !found.include? time}]
  #   end.to_h
  # rescue
  #   halt 404
  # end
end
