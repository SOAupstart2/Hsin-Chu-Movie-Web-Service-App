require 'page-object'

# Page object of home page, which is used for tests.
class HomePage
  include PageObject

  page_url 'http://localhost:9393/'

  link(:link_to_home, id: 'link_to_home')
  h1(:app_name, id: 'app_name')
  h3(:app_desc, id: 'app_desc')
  form(:user_form, id: 'user_form')
  select_list(:language_input, id: 'language_input')
  select_list(:location_input, id: 'location_input')
  text_field(:movie_name, id: 'movie_name')
  button(:search_button, id: 'search_button')

  def get_results(language, location, movie_name)
    self.language_input = language
    self.location_input = location
    self.movie_name = movie_name
    search_button
  end
end
