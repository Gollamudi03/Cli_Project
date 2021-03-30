class CLI

    attr_accessor :places

    def call
        puts "Loading Parks..."
        parks =Scraper.new
        parks.scrape_names
        parks.scrape_data
        opening_greeting
        parks_selector
        good_bye
    end

    def opening_greeting
        puts "Welcome To National Parks !!!"
        sleep 1
        puts ""
        puts "There are some beautiful National Parks to visit around Michigan."
        sleep 1
        puts ""
        puts"******************************************************************"
        puts ""
        puts "The 6 beautiful Parks of Michigan you need to visit: "
        sleep 3
    end

    def list_parks
        puts "Select a number for more info or exit.\n\n Where would you like to go?"
        @places = Place.all
        @places.each do |place|
            puts "#{place.index}. #{place.name}"
        end

    end

    def parks_selector
        input = nil
        while input != 'exit'
            list_parks
            input = gets.strip
            int = input.to_i
            if int.between?(1,@places.size)
               more_info(@places[int - 1])
           elsif !int.between?(1,@places.size) && input != "exit"
               puts "Please select a number between 1 and #{@places.size} or exit."
            end
       end
    end

    def more_info(place)
        puts "#{place.name}"
        puts ""
        puts "Would you like to know more details about #{place.name}?"
        sleep(1)
        puts ""
        puts "enter the number or write exit."

        puts "1. Address"
        puts ""
        puts "2. Opening hours"
        puts ""
        puts "3. Current Conditions "
        input = nil

        while input != 'exit'
            input = gets.strip
            int = input.to_i
            if int.between?(1,3)
                if int == 1
                    puts "#{place.address}"
                elsif int == 2
                    puts "#{place.opening_hrs}"
                elsif int == 3
                    puts "#{place.directions}"
                end
            else
                puts "Enter the appropriate number or write exit."
            end
        end
    end

    def good_bye
        puts "Thank You. Stay Safe"
    end
end
