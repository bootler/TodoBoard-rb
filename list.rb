require_relative './item.rb'

class List
    attr_accessor :label

    def initialize(label)
        @label = label
        @items = []
    end

    def add_item(title, deadline, description="")
        begin
            @items << Item.new(title, deadline, description)
            true
        rescue => e
            puts e.message
            puts "Failed to add item!"
            false
        end
    end

    def size
        @items.length
    end

    def valid_index?(index)
        index >= 0 && index < @items.length
    end

    def swap(index_1, index_2)
        return false if !self.valid_index?(index_1) || !valid_index?(index_2)
        items = [@items[index_1], @items[index_2]]
        @items[index_1] = items[1]
        @items[index_2] = items[0]
        true
    end

    def [](index)
        return nil if !self.valid_index?(index)
        @items[index]
    end

    def priority
        self[0]
    end

    def print
        55.times { Kernel.print "-"}
        puts
        puts @label.upcase.center(55)
        55.times { Kernel.print "-"}
        puts
        puts "Index | #{"Item".ljust(18)} | #{"Deadline".ljust(10)} | Completed".ljust(55)
        55.times { Kernel.print "-"}
        puts
        @items.each.with_index do |item, idx|
            puts "#{idx.to_s.ljust(5)} | #{item.title.ljust(18)} | #{item.deadline.ljust(10)} | #{item.done}".ljust(55)
        end
        55.times { Kernel.print "-"}
        puts
        true
    end

    def print_full_item(index)
        return false if !self.valid_index?(index)
        55.times { Kernel.print "-"}
        puts
        puts "#{self[index].title.ljust(45)}#{self[index].deadline.rjust(10)}"
        puts "#{self[index].description.ljust(50)}#{self[index].done}"
        55.times { Kernel.print "-"}
        puts
        true
    end

    def print_priority
        print_full_item(0)
    end

    def up(index, amount=1)
        return false if !self.valid_index?(index)
        until amount <= 0 do
            self.swap(index, index - 1)
            index -= 1
            amount -= 1
        end
        true
    end

    def down(index, amount=1)
        return false if !self.valid_index?(index)
        until amount <= 0 do
            self.swap(index, index + 1)
            index += 1
            amount -= 1
        end
        true
    end

    def sort_by_date!
        @items.sort_by! { |item| item.deadline }
    end

    def toggle(index)
        return false if !self.valid_index?(index)
        self[index].toggle
        true
    end

    def remove_item(index)
        return false if !self.valid_index?(index)
        @items = @items[0...index] + @items[index + 1..-1]
        true
    end

    def purge
        @items.reject! { |item| item.done }
    end
end
            