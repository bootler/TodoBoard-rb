class Item
    attr_reader :deadline, :done
    attr_accessor :title, :description

    def valid_date?(date_string)
        date = date_string.split('-')
        if date.length != 3
            puts "Invalid format: " + date_string
            return false
        end
        if date.any? { |num| num.to_i.to_s != num && "0" + num.to_i.to_s != num }
            puts "Invalid format: " + date_string
            return false
        end
        month = date[1].to_i
        day = date[2].to_i
        if month < 1 || month > 12 || day < 1 || day > 31
            puts "Invalid calendar date: " + date_string
            return false
        end
        if [4,6,9,11].include?(month) && day > 30 || month == 2 && day > 29
            puts "Day: " + date[2] + " out of range for month: " + date[1]
            return false
        end
        true
    end

    def initialize(title, deadline, description)
        if !valid_date?(deadline)
            raise "Invalid deadline, please review."
        end
        @title = title
        @deadline = deadline
        @description = description
        @done = false
    end

    def deadline=(new_deadline)
        if !valid_date?(new_deadline)
            raise "Invalid deadline, please review"
        end
        @deadline = new_deadline
    end

    def toggle
        @done = !@done
    end
end
            

         