require_relative 'spec_helper'
require 'json'
require 'page-object'

describe 'Kandianying' do
  include PageObject::PageFactory
  
  before do
    unless @browser
      @headless = Headless.new
      # @headless.start
      @browser = Watir::Browser.new
    end
  end

  describe 'Visiting the home page' do
    it 'finds the title' do
      visit HomePage do |page|
        page.title.must_equal 'Kandianying'
        page.history_link_element.exists?.must_equal true
      end
    end
  end

  describe 'Checking the main components of history page' do
    it 'finds main components' do
      visit HistoryPage do |page|
        page.id_fortest1.must_equal 'Movie Timeline'
        page.cinema_table?.must_equal true
        page.location_button?.must_equal true
        page.language_button?.must_equal true
      end
    end
  end

  # because we does not have any functionality code for it yet
  # we just make sure each page has all important elements visible when go to it

  after do
    @browser.close
    # @headless.destroy
  end
end
