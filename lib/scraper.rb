class Scraper
    attr_accessor :parks_site_url, :park_names_info_urls

    def initialize
        @parks_site_url = "https://www.nps.gov/state/mi/list.htm?program=parks"
        @park_names_info_urls = []
    end

    def scrape_names
        html = open(@parks_site_url)
        doc = Nokogiri::HTML(html)
        park_names = doc.search("li.clearfix")
        park_names.each_with_index do |name, index|
            park_name = name.css("h3 a").text
            info_url = name.at_css('li a:contains(" Basic Information")')

            if park_name != "" && info_url
                @park_names_info_urls << "#{index + 1 },#{park_name},#{info_url["href"]}"
            end
        end
    end

    def scrape_data
        @park_names_info_urls.each do |p|
            park_array = p.split(",")
            park_info_url = Nokogiri::HTML(open(park_array[2]))
            address = park_info_url.at("//div[@itemprop = 'address']").children.text.squeeze
            directions = park_info_url.search("div.directions span").text
            opening_hrs = park_info_url.search("div.Todays_hours_Container").text

            if directions.empty?
             directions = "Visitor Centers are Closed
    The visitor centers are closed for the winter.Winter Road Conditions
    All park roads (except Sand Point Road) and eastern portion of H-58 are unplowed & are closed to vehicles except snowmobiles. Roads reopen when snow melts (April/May). See road map handout: https://www.nps.gov/piro/planyourvisit/winter-road-closures.htm"
            end
            if opening_hrs == ""
                opening_hrs = "COVID-19 Response

    Face masks are required on NPS-administered lands where physical distancing cannot be maintained and in all NPS buildings and facilities. Park operations vary based on local public health conditions. Before visiting, please check the park website to determine its operating status."
            end
            directions = directions.gsub("Directions Details", "")
            Place.new(park_array[0], park_array[1], address, directions, opening_hrs)
        end
    end

end
