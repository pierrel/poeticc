require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'json'
require 'rest_client'
require 'logger'

info = JSON.parse(File.read('config.json'))['couch']


@starting_url = "http://en.wikisource.org/wiki/Category:Poems"
@base_url = "http://en.wikisource.org"
@poem_link_regex = /^\/wiki\/[A-Za-z0-1_():]+$/
@couch = "http://#{info['username']}:#{info['password']}@#{info['host']}:#{info['port']}/#{info['name']}"
@log = Logger.new "/var/poeticc/log/scrape.log", "daily"

def scrape_poem_page(url)
  sleep 0.05 # so we don't overload the source
  doc = Hpricot(open(url))
  
  {
    :title      => (doc/"#header_title_text").inner_html,
    :author     => (doc/"#header_author_text").inner_html,
    :body_html  => (doc/".poem").first.inner_html,
    :source     => url,
    :type       => 'poem'
  }
    
rescue Exception => e
  # the page was not formatted correctly so move on to the next one
  @log.warn "error #{e} in parsing #{url}"
  return nil
end

def scrape_poems_list(url)
  poems = []
  doc = Hpricot(open(url))
  
  (doc/"li a").select { |link| link.attributes['href'].match(@poem_link_regex) }.each do |link|
    poem_url = @base_url + link.attributes['href']
    poem = scrape_poem_page(poem_url)
     
    if poem
      poems << poem
    end
  end
  poems
end


next_url = @starting_url
while next_url
  poems = scrape_poems_list next_url
  
  poems.each do |poem|
    poem_json = JSON.generate poem
    resp = RestClient.post(@couch, poem_json)
    @log.info "saved poem with response #{resp}"
  end
  
  next_links = (Hpricot(open(next_url))/("a")).select { |link| link.inner_html == "next 200" }
  if next_links.length > 0
    next_url = @base_url + next_links.first.attributes['href']
  else
    next_url = false
  end  
end
