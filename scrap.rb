require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

LETTERS  = (ARGV[0]..ARGV[1]).to_a

ENDPOINT = 'https://rubygems.org/gems?letter='.freeze



LETTERS.each do |letter|
  i = 1
  RESULT = {}
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

  data = JSON.parse(File.read('data.json')).merge(RESULT).to_json
  File.open('data.json', 'w') do |f|
    f.write(data)
    f.close
  end
end
