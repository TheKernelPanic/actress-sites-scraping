require 'yaml'
require_relative 'src/providers'
require_relative 'src/helpers'

config = File.open('source_providers.yml')

data = YAML.load(config)

actresses_dict = {}

data.each do |provider_name, provider_data|
  provider = Object.const_get(provider_data['classname']).new provider_data

  fetched_data = provider.fetch

  fetched_data.each do |data|

    unless actresses_dict.key?(data[:slug])
      actresses_dict[data[:slug]] = {
        "name": data["name"],
        "images": {}
      }
    end
    actresses_dict[data[:slug]][:images][provider_name] = data["image_url"]
  end

  Helpers::write_file("actresses", actresses_dict)

end