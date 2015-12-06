require 'page-object'

class HistoryPage
  include PageObject

  page_url "http://localhost:9393/history"
  
  h3(:id_fortest1, id: 'fortest1')
  div(:cinema_table, id: 'movie_timeline')
  button(:location_button, id: 'location_button')
  button(:language_button, id: 'language_button')
end