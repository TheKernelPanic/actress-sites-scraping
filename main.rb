require 'yaml'
require_relative 'src/providers'
require_relative 'src/helpers'

config = File.open('source_providers.yml')


data = YAML.load(config)

data.each do |provider_name, provider_data|
  provider = Object.const_get(provider_data['classname']).new provider_data

  fetched_data = provider.fetch

  Helpers::write_file(provider_name, fetched_data)

end