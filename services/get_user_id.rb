# Service object to post user information and
class GetUserID
  def initialize(params, url)
    @language = params[:language]
    @location = params[:location]
    @url = url
  end

  def call
    response = HTTParty.post(
      @url,
      body:{
        language: @language, location: @location
      }.to_json
    )

    response['user_info']['id']
  end
end