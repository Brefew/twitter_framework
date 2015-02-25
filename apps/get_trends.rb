require_relative '../requests/TrendsPlace'

require 'trollop'

USAGE = %Q{
get_trends: Retrieve trending terms for a given Where On Earth ID.

Usage:
  ruby get_trends.rb <options> <WOEID>

  <WOEID>: A Where On Earth ID (http://developer.yahoo.com/geo/geoplanet/)

  Example: 23424977 is the WOEID for the United States

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_trends 0.1 (c) 2015 Kenneth M. Anderson; Updated by Brett M. Shouse"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid file"
  end

  opts[:id] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { id: input[:id] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = TrendsPlace.new(args)

  puts "Getting the current trends for WOEID: #{input[:id]}"

  File.open('trends.json', 'w') do |f|
    twitter.collect do |trends|
      trends.each do |trend|
        f.puts "#{trend.to_json}\n"
      end
    end
  end

  puts "DONE."

end
