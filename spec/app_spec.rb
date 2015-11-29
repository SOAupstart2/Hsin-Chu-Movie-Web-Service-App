require_relative 'spec_helper'
require 'json'

describe 'Kandianying' do
  before do
    unless @browser
      @headless = Headless.new
      @browser = Watir::Browser.new
    end
    @browser.goto 'localhost:9292'
  end

  describe 'Visiting the home page' do
    it 'finds the title' do
      @browser.title.must_equal 'Kandianying'
    end
  end

  describe 'Searching for a cadet' do
    it 'finds a real user' do
      # given
      @browser.link(text: 'History').click
      # then
      @browser.h3(id: 'fortest1').text.must_equal 'h3. Lorem ipsum dolor sit amet.'
      @browser.th(id: 'fortest2').text.must_equal 'Cinema'
      @browser.th(id: 'fortest3').text.must_equal 'Date'
      @browser.th(id: 'fortest4').text.must_equal 'Time Section'
    end
  end

  # because we does not have any functionality code for it yet
  # we just make sure each page has all important elements visible when go to it 



  # after do
  #   @browser.close
  #   @headless.destroy
  # end
end