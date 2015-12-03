require 'page-object'

class HistoryPage
  include PageObject

  page_url "http://localhost:9393/history"
  
  h3(:id_fortest1, id: 'fortest1')
  table(:cinema_table, class: 'table')
  button(:location_button, id: 'location_button')
  button(:language_button, id: 'language_button')
end