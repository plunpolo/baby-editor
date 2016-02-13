#!/usr/bin/env ruby
=begin

Beginner project for learning to program in Ruby. 
Even though the code is ugly, -at this point it's mostly functional.

TODO:
[ ] Add line editing
[ ] Write edits to file
[ ] Add support for paths
[ ] Catch errors
[ ] Move editor method into main loop instead
[ ] Look into how syntax highlighting can be done
[ ] Rewrite the whole thing with classes
[ ] Split into program into different files
[ ] Fix scope on variables. Global scope is probably bad.
[ ] Find put how to run wipe for each instance of the cases

=end

require 'colorize'

# Variables
run = true
buffer = nil

# Constants
THE_STAFF_SAYS = "Awaiting your command, my Lordship:"
POSSIBLE_COMMANDS = ["q", "n", "p", "o", "a", "d", "c"]
COMMANDS_NOT_YET_IMPLEMENTED = ["e", "w", "s" ]
HELP = "== HELP ==\n\n\
Word that starts with these letters \
will result in the following commands:\n\n \
\tn: create new file\n\
\to: open file\n\
\tp: print to screen\n\
\ta: append line to file\n\
\tc: close buffer\n\
\td: delete file\n\
\tq: exit\n\
\th: this help text\n\n"

HELP_FOR_NOT_YET_IMPLEMENTED = "\te: edit line\n\
\tw: write buffer to file\n\
\ts: set language for syntax highlighting\n\n"

# Methods
def user_prompt
  # Setting up command prompt and excepting user commands
  print THE_STAFF_SAYS.colorize(:color => :black, :background => :light_green) + " "
  $command = gets.chomp.downcase
end

def wipe
  # Wipes screen
  print "\e[H\e[2J"
end

def get_command_argument( command, command_alias, input )
  if input.include? command
    s = input.sub( command, "" )
    return s
  elsif input.include? command_alias
    s = input.sub( command_alias, "" )
    return s
  else
    # Throw error and handle exception
  end
end

def open_file
  f = File.open($file_name, 'r')
  @buffer = []
  f.each_line do |line|
    @buffer.push line
  end
end

def print_buffer
  i = 1
  @buffer.each do |line|
    print i.to_s + "\t|  "
    print line
    i += 1
  end
  print "\n"
end

def editor
  # The actual editor
    case $command[0]
    when "q"
      wipe
      # Exit program
      exit
    when "h"
      # Show help text
      wipe
      puts HELP.yellow
    when "n"
      # Create new file
      wipe
      $file_name = get_command_argument( "new ", "n ", $command )
      File.new($file_name, "w").close
      puts "Created \'#{$file_name}\' in current directory.".colorize(:color => :black, :background => :light_green) + " "
    when "o"
      # Open file
      wipe
      $file_name = get_command_argument( "open ", "o ", $command )
      open_file
      print_buffer
      puts "\'#{$file_name}\' is now in buffer.".colorize(:color => :black, :background => :light_green) + " "
    when "p"
      # Print to screen
      wipe
      print_buffer
    when "a"
      # Append to file
      f = File.open($file_name, 'a')
      print "\n: "
      f << gets
      f.close
      open_file
      wipe
      print_buffer
      puts "Appended line to \'#{$file_name}\'".colorize(:color => :black, :background => :light_green) + " "
=begin
    when "e"
      # Update line
      wipe
      puts "Edit..."
    when "w"
      # Save buffer to file
      wipe
      puts "Write..."
=end
    when "d"
      # Delete file
      wipe
      print "Which file do you wish to delete?\n: "
      $file_name = gets.chomp
      File.delete($file_name)
      puts "\'#{$file_name}\' deleted.".colorize(:color => :black, :background => :light_green) + " "
    when "c"
      # Close file/buffer
      wipe
      @buffer = []
      puts "Buffer closed.".colorize(:color => :black, :background => :light_green) + " "
    end
end

# The program loop
while run == true
  user_prompt
  editor
end
