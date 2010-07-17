
require 'rubygems'
require 'mechanize'
require 'bossman' 

include BOSSMan

class LinkScraper

  attr_accessor :keyword, :numperpage, :start ,:resultlinks   #These vars are needed to construct search url
  
  def initialize(key="", total = "100")
    @keyword = key
    @numperpage = 10
    @start = 100      #This denotes the starting result, needed to turn pages
    @agent = Mechanize.new
    @url = 'http://rubyonrails.com/'
    @pattern = 'a/@href'
    @resultlinks = []
    @total = total
  end

  def getLinks
#    @keyword = keyword
    @page = @agent.get(@url)
    @links = @page.search(@pattern)
    @resultlink.push @links
    return @resultlinks
  end

end


class Bing < LinkScraper
  
  def initialize(key)
    super(key)
    @url = "http://www.bing.com/search?q=#{keyword}&go=&form=QBLH&filt=all&qs=n&sk=&sc=8-4&first=#{start}"
    @pattern = 'div[@class=sb_tlst]/h3/a/@href'
  end

end


class Google < LinkScraper
  
  def initialize
    super(key)
    @url = "http://www.google.co.in/search?hl=en&q=#{keyword}&num=#{numperpage}&start=#{start}"
    @pattern = 'h3[@class=r]/a/@href'
  end

end


class Yahoo < LinkScraper

  def getLinks()
    BOSSMan.application_id = 'appid=%20RFn8O53V34FfngzZkPWYGuSn0JN8fFDN25_.cKT86Kh3eFZYX_gPc693ao_3yRL4xNE-'
    news = BOSSMan::Search.web(@keyword ,:count => @numperpage, :start => @start)
    news.results.each do |result|
      @resultlinks.push result.url 
    end 
    return @resultlinks
  end

end

#l = LinkScraper.new
l = Yahoo.new "hello"
pp l.getLinks





