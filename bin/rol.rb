#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'English'
require 'json'
require 'optparse'
require 'tmpdir'

BANNER = 'Usage: rol.rb -u USERNAME -p PASSWORD'

ARGUMENTS = [
  {
    short: '-u',
    long:  '--username USERNAME',
    text:  'Your gmail username',
    key:   :username
  },
  {
    short: '-p',
    long:  '--password PASSWORD',
    text:  'Your gmail password',
    key:   :password
  }
]

REQUIRED_ARGUMENTS  = [:username, :password]

def setup_arguments(parser, options)
  ARGUMENTS.each do |option|
    parser.on(option[:short], option[:long], option[:text]) do |value|
      options[option[:key]] = value
    end
  end
end

def setup_option_parser(options)
  OptionParser.new do |parser|
    parser.banner = BANNER

    setup_arguments(parser, options)

    parser.on_tail('-h', '--help', 'Show this message') do
      puts parser
      exit
    end
  end
end

def check_all_required_arguments_present(options)
  missing = REQUIRED_ARGUMENTS.select { |p| options[p].nil? }
  missing = missing.join(', ')

  fail OptionParser::MissingArgument, missing unless missing.empty?
end

def parse_arguments
  options = {}
  parser = setup_option_parser(options)

  begin
    parser.parse!
    check_all_required_arguments_present(options)
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument
    puts "#{$ERROR_INFO}\n#{parser}"
    exit
  end

  [options[:username], options[:password]]
end

def main
  username, password = parse_arguments

  conn = Rol::GmailConnection.new(username, password)
  expense = Rol::ChaseExpense.new(conn)

  temp_file = File.new(File.join(Dir.tmpdir, 'pipakes'), 'w')
  expense.find_by_days_ago(3) do |e|
    temp_file.puts e.to_json unless e[:amount] == 0
  end
  temp_file.close
  puts "Saved to #{temp_file.path}"
end

main
