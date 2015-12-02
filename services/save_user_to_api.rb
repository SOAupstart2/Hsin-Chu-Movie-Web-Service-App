require 'virtus'

##
# Value object for results from searching cinema info
class UserSaveToAPIResult
  include Virtus.model

  attribute :status
  attribute :id
end

##
# Service object to check tutorial request from API
class SaveUserToAPI
  def initialize(settings, user_form)
    @settings = settings
    params = user_form.attributes.delete_if { |_, value| value.blank? }
    @options = { body: params.to_json,
                 headers: { 'Content-Type' => 'application/json' } }
  end

  def call
    url = "#{@settings.api_server}/#{@settings.api_ver}/users"
    results = HTTParty.post(url, @options)
    user_save_results = UserSaveToAPIResult.new(results)
    user_save_results.status = results.code
    user_save_results.id = results.request.last_uri.path.split('/').last
    user_save_results
  end
end
