# Helpers for main sinatra web application
module AppHelpers
  def remake_data(data, search_time, film_info = [])
    data['search_name'].each do |cinema, movies|
      movies.each do |movie, dates|
        dates.each do |date, times|
          times.each do |time|
            start_time = Time.parse(date + ' ' + time)
            end_time = start_time + 5400
            if (start_time - Time.parse(search_time)).between?(0, 86_400)
              film_info << [movie, cinema, start_time.to_s, end_time.to_s]
            end
          end
        end
      end
    end
    film_info
  end
end
