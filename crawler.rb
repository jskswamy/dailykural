require 'nokogiri'
require 'open-uri'

def get_chapters_links(doc)
  chapter_links = doc.xpath('//table[3]//a[@href]')
  chapter_links.map { |link| link.attr('href') }
end

(1...2).each do |pid|
  url = "http://kural.muthu.org/?pid=#{pid}"
  doc = Nokogiri::HTML(open(url))
  chapter_links = get_chapters_links(doc)
  raise chapter_links.inspect
end
