require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

LETTERS  = ('A'..'Z').to_a

ENDPOINT = 'https://rubygems.org/gems?letter='.freeze

RESULT = {}

LETTERS.each do |letter|
  FILE = File.open('data.json','w')
  i = 1
  RESULT[letter] = []
  loop do
    puts "PAGE #{i}"
    puts ENDPOINT + letter + "&page=#{i}"
    page = Nokogiri::HTML(open(ENDPOINT + letter + "&page=#{i}"))
    break puts "END #{letter}" if page.css('.gems__gem').empty?
    page.css('.gems__gem').map(&:attributes).each do |link|
      RESULT[letter] << link['href'].value.delete!("/gems/")
    end
    i = i + 1
  end
  FILE.write(JSON.parse(File.read('data.json')).merge(RESULT[letter]).to_json).close
end
