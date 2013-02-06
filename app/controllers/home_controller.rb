class HomeController < ApplicationController
  def index
    require 'rubygems'
    require 'mechanize'
    require 'open-uri'

    a = Mechanize.new
    @tags = []
    a.get("http://bandcamp.com/tags") do |page|
      search_result = page.links.each do |link|
        @tags << link.text.strip
      end
    end 
    @tags.shift(2)

    #binding.pry
  end
end
