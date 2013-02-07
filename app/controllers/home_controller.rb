class HomeController < ApplicationController
  def index
    require 'rubygems'
    require 'mechanize'
    require 'open-uri'
    @search = Search.new

    @tags = []
    doc = Nokogiri::HTML(open("http://bandcamp.com/tags/"))
    doc.css('div#tags_cloud a').each do |tag|
      @tags << tag.text.strip.gsub(/\s+/, '-')
    end
    @tags = @tags.sort
  end

  def get_track
    require 'domainatrix'
    tag=params[:tag]
    @album_links = []
    doc = Nokogiri::HTML(open("http://bandcamp.com/tag/#{tag}"))
      doc.css('ul.item_list li a').each do |a|
        @album_links << a['href']
      end
    @album_link = @album_links.sample
    
    @track_links = []
    album = Nokogiri::HTML(open(@album_link))
    album_url = Domainatrix.parse(@album_link)
    album_subdomain = album_url.subdomain 
    album.css('div.title a').each do |a|
      @track_links << "http://#{album_subdomain}.bandcamp.com#{a['href']}"
    end
    @track_link = @track_links.sample    
    track = Nokogiri::HTML(open(@track_link))
    track_url = track.at('//meta[@property="og:video"]')['content']
    track_id = track_url.match(/.*\=(\d+)/)[1]
    render json: track_id
  end
end
