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

    image_filename = Helpers::get_image_filename(provider_name, data["image_url"])

    unless image_filename == nil
      Helpers::download_and_write_image_file(image_filename, data["image_url"])
      actresses_dict[data[:slug]][:images][provider_name] = image_filename
    end

  end
end

Helpers::write_json_file("actresses", actresses_dict)