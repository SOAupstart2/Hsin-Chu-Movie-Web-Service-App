require 'page-object'
require 'date'

# Page object of result page, which is used for tests.
class ResultPage
  include PageObject

  today = Date::today.to_s

  page_url "http://localhost:9393/result" \
           "?language=english&location=hsinchu" \
           "&search_time=#{today}&movie_name="

  h3(:result_desc, :id => 'result_desc')
  form(:user_form, :id => 'user_form')
  select_list(:language_input, :id => 'language_input')
  select_list(:location_input, :id => 'location_input')
  text_field(:movie_name, :id => 'movie_name')
  button(:search_button, :id => 'search_button')
end
