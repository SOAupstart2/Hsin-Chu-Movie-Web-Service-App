require 'virtus'

##
# Value object for results from searching cinema info
class CrawlResult
  include Virtus.model

  attribute :code
  attribute :id

  def to_json
    to_hash.to_json
  end
end

##
# Service object to check tutorial request from API
class Service
  def initialize(api_url, user_form)
    @api_url = api_url
    params = user_form.attributes.delete_if { |_, value| value.blank? }
    @options =  { body: params.to_json,
                  headers: { 'Content-Type' => 'application/json' }
                }
  end

  def call
    results = HTTParty.post(@api_url, @options)
    crawl_results = CrawlResult.new(results)
    crawl_results.code = results.code
    crawl_results.id = results.request.last_uri.path.split('/').last
    crawl_results
  end
end
