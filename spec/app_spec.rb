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

  after do
    # @headless.destroy
    @browser.close
  end
end
