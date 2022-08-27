require 'faraday'
require 'json'
require 'digest'
require_relative 'src/helpers'

if ARGV.length == 0
  raise ArgumentError.new 'Mandatory page argument'
end

unless ARGV[0] =~ /^[0-9]{1,3}$/
  raise ArgumentError.new 'Argument page must be a numeric'
end

pages = ARGV[0].to_i

def get_url_per_page(number_page)
  return 'https://badoinkvr.com/vr-pornstars/'+String(number_page)
end

actress_name_regex = /\<span\sitemprop\=\"name\"\>([^<>]*)\<\/span\>/
actress_image_regex = /\<img\sclass\=\"girl\-card\-image\slazyLoadContainer(?>\sloaded)?\"\sdata\-src\=\"([^"]*)/

fetched_data = []

i = 1
while i <= pages

  puts 'Fetch from page '+String(i)

  response = Faraday.get get_url_per_page i

  body = response.body

  list_of_names_matched = body.scan(actress_name_regex)
  list_of_images_matched = body.scan(actress_image_regex)

  unless list_of_images_matched.length == list_of_names_matched.length
    raise RuntimeError.new 'List of names not assert with the list of images'
  end

  list_of_names_matched.each_with_index do |value, index|
    image_url = list_of_images_matched[index][0]
    fetched_data.push({'name' => value[0], 'image_url' => image_url, 'slug': Helpers::slug_actress_generate(value[0]) })
  end

  i += 1
end

file = File.new('./data/badoinkvr/actress.json', "w")
file.write JSON.pretty_generate(fetched_data)
file.close

