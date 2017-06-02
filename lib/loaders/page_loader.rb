require 'httparty'
require 'nokogiri'

class PageLoader
  include HTTParty

  headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
  base_uri 'https://en.wikipedia.org'

  def load_countries
    url = '/wiki/Lists_of_cities_by_country'

    response = self.class.get(url)

    code = response.code.to_i

    page = response.body.gsub(/\n/, '')

    case code
    when 200
      parse_countries(page)
    else
      puts "Strange response code during list load - #{code.to_s}"
    end
  end

  def parse_countries(html)
    page = Nokogiri::HTML(html, nil, 'utf-8')
#    page = File.open("wiki.html") { |f| Nokogiri::HTML(f) }

    uls = page.xpath("//div[@id='mw-content-text']/div/ul")

    uls.each do |ul|
      begin
        break if ul.previous_sibling.xpath(".//span")[0].attribute("id").value == 'See_also'
      rescue NoMethodError
      end

      items = ul.xpath(".//li")

      items.each do |item|
        country = Country.new

        country.cities_link = item.xpath(".//b/a/@href")
        country.cities_link ||= item.xpath(".//a/@href")

        country.name = item.xpath(".//a[last()]/@title")[0].value

        country.cities_link ||= item.xpath(".//i/a/@href")

        if item.at_xpath(".//i/a[@class='mw-redirect']")
          next
        end

        country.country_link = item.xpath(".//a[last()]/@href")[0].value

        country.filled = false
        country.cities_link = self.class.base_uri + country.cities_link
        country.country_link = self.class.base_uri + country.country_link

        country.save!
        sleep(Random.rand(15))
      end
    end
  end

  def load_cities(url)
    response = self.class.get(url)

    code = response.code.to_i

    page = response.body.gsub(/\n/, '')

    case code
    when 200
      parse_countries(page)
    else
      puts "Strange response code during list load - #{code.to_s}"
    end
  end
end
