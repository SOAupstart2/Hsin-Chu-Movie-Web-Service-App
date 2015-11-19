require 'kandianying'
require 'json'

# Cinema information Class
class CinemaInfo
  attr_reader :movie_table, :movie_names

  def initialize(theater_id)
    @cinema = HsinChuMovie::Vieshow.new(theater_id)
    @movie_table = @cinema.movie_table
    @movie_names = @cinema.movie_names
  end

  def film_times(film_name)
    @cinema.film_times(film_name)
  end

  def films_after_time(date_time)
    @cinema.films_after_time(date_time)
  end
end
