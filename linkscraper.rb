
require 'rubygems'
require 'mechanize'
require 'bossman' 

include BOSSMan

class LinkScraper

  attr_accessor :url,  :keyword, :numperpage, :resultlinks   #These vars are needed to construct search url
  
  def initialize(key="", total = 100)
    @keyword = key
    @numperpage = 50
    @agent = Mechanize.new
    @url = 'http://rubyonrails.com/'
    @pattern = 'a/@href'
    @resultlinks = []
    @total = total
  end


  def getLinks
    @resultlinks = []
    Range.new(0, @total, true).step(10) do |no|
      no = no.to_s
      @url = @url.gsub(/(&first=|&start=)[0-9]+/, '\1') + no    # The url, it will end with &start or &first
      @page = @agent.get(@url)
      @links = @page.search(@pattern)
      @resultlinks.push @links
    end
    return @resultlinks
  end
      
end


class Bing < LinkScraper
  
  def initialize(key, totale=100)
    super(key , totale)
    @url = "http://www.bing.com/search?q=#{keyword}&go=&form=QBLH&filt=all&qs=n&sk=&sc=8-4&first="
    @pattern = 'div[@class=sb_tlst]/h3/a/@href'
  end

end


class Google < LinkScraper
  
  def initialize(key, totale=100)
    super(key, totale)
    @url = "http://www.google.co.in/search?hl=en&q=#{keyword}&num=#{numperpage}&start="
    @pattern = 'h3[@class=r]/a/@href'
  end

end


class Yahoo < LinkScraper

  def initialize(key, totale=100)
    super(key, totale)
  end

  def getLinks()
    BOSSMan.application_id = 'appid=%20RFn8O53V34FfngzZkPWYGuSn0JN8fFDN25_.cKT86Kh3eFZYX_gPc693ao_3yRL4xNE-'
    Range.new(0, @total, true).step(10) do |no|
      no = no.to_s
      news = BOSSMan::Search.web(@keyword ,:count => @numperpage, :start => no)
      news.results.each do |result|
        @resultlinks.push result.url 
      end 
    end
    return @resultlinks
  end

end

#l = LinkScraper.new
l = Google.new "hello", 20
puts l.getLinks





