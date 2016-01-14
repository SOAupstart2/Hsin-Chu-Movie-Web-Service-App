require_relative 'spec_helper'

describe 'Kandianying' do
  include PageObject::PageFactory

  before do
    unless @browser
      # @headless = Headless.new
      @browser = Watir::Browser.new
    end
  end

  describe 'Visiting the home page' do
    it 'finds the title' do
      visit HomePage do |page|
        page.title.must_equal 'Kandianying'
      end
    end

    it 'finds the link to HOME' do
      visit HomePage do |page|
        page.link_to_home_element.exists?.must_equal true
      end
    end
  end

  describe 'Main components of home page' do
    it 'checks the existence of main components' do
      visit HomePage do |page|
        page.app_name.must_equal 'Kandianying'
        page.app_desc.must_equal 'Search Movies in Taiwan'
        page.user_form_element.exists?.must_equal true
        page.language_input_element.exists?.must_equal true
        page.location_input_element.exists?.must_equal true
        page.movie_name_element.exists?.must_equal true
        page.search_button_element.exists?.must_equal true
      end
    end

    it 'checks default setting of language and location' do
      visit HomePage do |page|
        page.language_input.must_equal 'English'
        page.location_input.must_equal 'Taipei'
      end
    end
  end

  describe 'Main components of result page' do
    it 'checks the existence of main components' do
      visit ResultPage do |page|
        page.result_desc.must_equal 'Movie Timeline'
        page.user_form_element.exists?.must_equal true
        page.language_input_element.exists?.must_equal true
        page.location_input_element.exists?.must_equal true
        page.movie_name_element.exists?.must_equal true
        page.search_button_element.exists?.must_equal true
      end
    end
  end

  describe 'Checks if search works' do
    url = 'http://localhost:9393/'

    it 'Default search' do
      visit HomePage do |page|
        now = DateTime.now.to_s.split('+')[0][0, 16].strip.gsub(/:/, "%3A")
        # now = Time.now.getlocal("+08:00").to_s[0, 16].strip.gsub(' ', 'T').gsub(/:/, "%3A")
        page.search_button
        expected_url = "#{url}result?"\
        "language=english&location=taipei&search_time=#{now}&movie_name="
        page.current_url.must_equal expected_url
      end
    end

    it 'Set different language and location' do
      visit HomePage do |page|
        now = Time.now.getlocal("+08:00").to_s[0, 16].strip.gsub(' ', 'T').gsub(/:/, "%3A")

        page.language_input = 'Chinese'
        page.location_input = 'Hsinchu'
        page.search_button
        page.movie_name = SecureRandom.hex(10)
        page.get_results(
          'Chinese',
          'Hsinchu',
          SecureRandom.hex(10)
        )
        expected_url = "#{url}result?"\
        "language=#{page.language_input.downcase}"\
        "&location=#{page.location_input.downcase}&search_time=#{now}"\
        "&movie_name=#{page.movie_name}"
        page.current_url.must_equal expected_url
      end
    end
  end

  after do
    # @headless.destroy
    @browser.close
  end
end
