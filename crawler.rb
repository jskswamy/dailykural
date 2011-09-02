require 'nokogiri'
require 'open-uri'

BASE_URL = "http://kural.muthu.org/"

def get_document(query_string)
  Nokogiri::HTML(open("#{BASE_URL}#{query_string}"))
end

def get_query_strings(doc, xpath="//table[3]//a[@href]")
  doc.xpath(xpath).map { |link| link.attr('href') }
end

def get_chapter_query_strings(doc)
  chapter_links = get_query_strings(doc)
end

def get_verses_query_strings(query_string)
  doc = get_document(query_string)
  get_query_strings(doc)
end

def get_verse_and_english_translation(query_string)
  doc = get_document(query_string)
  verse=doc.xpath("//table[3]//tr[5]//td[2]").first.text
  translation_and_explanation = doc.xpath("//table[4]//tr[2]//td[1]|//table[4]//tr[3]//td[1]")
  translation = translation_and_explanation.first.text
  explanation = translation_and_explanation.last.text
  {:verse => verse, :translation => translation, :explanation => explanation}
end

(1...2).each do |pid|
  doc = get_document("?pid=#{pid}")
  chapter_links = get_chapter_query_strings(doc)
  verses_query_strings = chapter_links.take(1).collect {|query_string|get_verses_query_strings(query_string)}.flatten
  verses_query_strings.take(1).collect do |query_string|
    p get_verse_and_english_translation(query_string)
  end
end
