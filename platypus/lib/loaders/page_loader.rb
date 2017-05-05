require 'httparty'
require 'nokogiri'

class Loaders::PageLoader
  include HTTParty

  headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
  base_uri 'https://en.wikipedia.org'

  def load_countries
    url = '/wiki/Lists_of_cities_by_country'

    response = self.class.get(url)

    code = response.code.to_i

    case code
    when 200
      parse_countries(response.body)
    else
      puts "Strange response code during list load - #{code.to_s}"
    end
  end

  def parse_countries(html)
    page = Nokogiri::HTML(html, nil, 'utf-8')

    uls = page.xpath("//div[@id='mw-content-text']/ul")

    uls.each do |ul|
      items = ul.xpath(".//li")

      items.each do |item|

      end
    end
  end
end
