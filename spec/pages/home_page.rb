require 'page-object'

# TODO: What's this?
#
class HomePage
  include PageObject

  page_url 'http://localhost:9393/'
  link(:history_link, text: 'History')
end
