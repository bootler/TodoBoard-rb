require_relative './list.rb'

class TodoBoard
    def initialize
        @lists = {}
    end

    def get_command
        print "Please enter a command: "
        input = gets.chomp.split
        args = []
        
        # input processing - TODO: Optimize.
        i = 0
        while i < input.length
            if input[i].include?("\"")
                next_el = i + 1
                rest = input[next_el..-1]
                match = rest.index(rest.select { |arg| arg.include?("\"") }[0])
                if match
                    args << input[i..next_el + match].join(" ")[1...-1]
                    i += (next_el + match)
                else
                    args << input[i]
                    i += 1
                end
            else
                args << input[i]
                i += 1
            end
        end

        # convert any numeric arguments into integers
        args.map! do |arg|
            if arg.to_i.to_s == arg || arg.to_i.to_s == "0#{arg}"
                arg.to_i
            else
                arg
            end
        end
        begin
            cmd, label, *args = args
            print args
            case cmd
            # Usage: mklist <label> - makes a new list.
            when 'mklist'
                @lists[label] = List.new(label)
            
            # Usage: ls - display a list of lists
            when 'ls'
                puts
                puts "Lists: "
                puts "----------"
                @lists.keys.each.with_index do |label,i|
                    puts "#{i} | #{label}"
                end
                puts

            # Usage: showall - print out all the lists in order.    
            when 'showall'
                @lists.values.each do |list|
                    list.print
                    puts
                end

            # Usage: mktodo <list> <title> <date> <optional description> - adds a new task to the specified list
            # Date must be in format YYYY-MM-DD. See List#date for implementation
            when 'mktodo'
                @lists[label].add_item(args[0], args[1], args[2])
            
            # Usage: up <list> <index> <optional amount>
            # Takes the task wth <index> in <list> and moves it higher <amount> times
            # If no amount is specified, moves it up one time.
            when 'up'
                @lists[label].up(*args)
            
            # Usage: down <list> <index> <optional amount>
            # Takes the task wth <index> in <list> and moves it lower <amount> times
            # If no amount is specified, moves it down one time.
            when 'down'
                @lists[label].down(*args)
            
            # Usage: swap <list> <index 1> <index 2>
            # Takes the task in <list> at <index 1> and swaps it with
            # the task at <index 2>
            when 'swap'
                @lists[label].swap(*args)
            
            # Usage: sort <list> - sorts the list by date in descending order
            when 'sort'
                @lists[label].sort_by_date!
            
            # Usage: priority <list> - Displays full details of the topmost todo in <list>
            when 'priority'
                @lists[label].print_priority
            
            # Usage: print <list> <optional index>
            # If no index is given, print <list>
            # If an index is given, print the full details of task at <index> on <list>
            when 'print'
                if args[0]
                    puts "Todo not found." if !@lists[label].print_full_item(*args)
                else
                    @lists[label].print
                end
            
            # Usage: Toggle <list> <index> - Toggle completed status of task with <index>
            # on <list>
            when 'toggle'
                puts "Todo not found." if !@lists[label].toggle(args[0])
            
            # Usage: rm <list> <index> - Remove task at <index> on <list>
            when 'rm'
                puts "Todo not found." if !@lists[label].remove_item(args[0])
            
            # Usage: purge <list> - remove all completed tasks from <list>
            when 'purge'
                @lists[label].purge
            
            # Usage: quit - exit the program.
            when 'quit'
                return false
            else
                puts "Command not recognized."
            end
        rescue => e
            if !@lists[label]
                puts "Invalid or unspecified list!"
                puts "Create a new list with mklist <label>"
                puts "Specify a list with 'command <list> <command-specific args>'" 
            else
                puts "Invalid arguments for: #{cmd}"
                puts e.message
            end
        end
        true
    end

    def run
        until !self.get_command do
            # Nothing to run here, the main loop executes when the until clause evaluates self.get_command
        end
    end
end

TodoBoard.new.run