require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'json'
require 'couchrest'
require 'logger'

info = JSON.parse(File.read('config.json'))['couch']


@starting_url = "http://en.wikisource.org/wiki/Category:Poems"
@base_url = "http://en.wikisource.org"
@poem_link_regex = /^\/wiki\/[A-Za-z0-1_():]+$/
if info['password'] and info['username']
  @couch = CouchRest.database!("http://#{info['username']}:#{info['password']}@#{info['host']}:#{info['port']}/#{info['name']}")
else
  @couch = CouchRest.database!("http://#{info['host']}:#{info['port']}/#{info['name']}")
end
@log = Logger.new "/var/poeticc/log/scrape.log", "daily"

def scrape_poem_page(url)
  sleep 0.05 # so we don't overload the source
  doc = Hpricot(open(url))
  
  # sometimes the title is a link
  title = (doc/"#header_title_text").inner_html
  title = (Hpricot(title)/"a").inner_html if title =~ /<a href/
  
  {
    :title      => title,
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
    existing_poem = @couch.view('couch/poem_urls', :key => poem_url)
    
    if existing_poem['rows'].empty?
      poem = scrape_poem_page(poem_url)
      poems << poem if poem
    end
  end
  poems
end


next_url = @starting_url
total_poems_saved = 0
while next_url
  poems = scrape_poems_list next_url
  
  poems.each do |poem|
    resp = @couch.save_doc(poem)
    if resp
      @log.info "saved poem with response #{resp}"
      total_poems_saved += 1
    end
  end
  
  next_links = (Hpricot(open(next_url))/("a")).select { |link| link.inner_html == "next 200" }
  if next_links.length > 0
    next_url = @base_url + next_links.first.attributes['href']
  else
    next_url = false
  end  
end

@log.info "saved #{total_poems_saved} poems"