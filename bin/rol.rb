#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-

require_relative '../lib/rol'
require 'English'
require 'json'
require 'optparse'
require 'tmpdir'

def parse_arguments
  options = {}

  parser = OptionParser.new do |opts|
    opts.banner = 'Usage: rol.rb -u USERNAME -p PASSWORD'

    opts.on('-u', '--username USERNAME', 'Your gmail username') do |user|
      options[:username] = user
    end

    opts.on('-p', '--password PASSWORD', 'Your gmail password') do |password|
      options[:password] = password
    end

    opts.on_tail('-h', '--help', 'Show this message') do
      puts opts
      exit
    end
  end

  begin
    parser.parse!
    mandatory = [:username, :password]
    missing = mandatory.select { |p| options[p].nil? }

    unless missing.empty?
      puts "Missing options: #{missing.join(', ')}"
      puts
      puts parser
      exit
    end
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument
    puts $ERROR_INFO.to_s
    puts
    puts parser
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
