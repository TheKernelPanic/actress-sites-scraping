require 'faraday'
require_relative 'src/helpers'

pages = Helpers::get_page_number_from_argument(ARGV)

def get_url_per_page(number_page)
  return 'https://virtualtaboo.com/pornstars?page='+String(number_page)
end

name_and_image_regex = /href\=\"[^\"]+\"\sstyle\=\"background-image\:\s?url\(\'([^\']+)\'\)\;\"\stitle\=\"([^"]+)\"/

fetched_data = []

i = 1
while i <= pages

  puts 'Fetch from page '+String(i)

  response = Faraday.get get_url_per_page 1

  body = response.body

  list_elements_matched = body.scan(name_and_image_regex)

  if list_elements_matched.length === 0
    raise RuntimeError.new 'Empty lists matched elements'
  end

  list_elements_matched.each_with_index do |value|
    fetched_data.push({'name' => value[1], 'image_url' => value[0], 'slug': Helpers::slug_actress_generate(value[1]) })
  end

  i += 1
end

file = File.new('./data/virtualtaboo/actress.json', "w")
file.write JSON.pretty_generate(fetched_data)
file.close
