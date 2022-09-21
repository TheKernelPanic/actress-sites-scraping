require 'json'

module Helpers

  def self.slug_actress_generate(canonicalName)
    return canonicalName.downcase
               .gsub('á', 'a')
               .gsub('é', 'e')
               .gsub('í', 'i')
               .gsub('ó', 'o')
               .gsub('ú', 'u')
               .gsub(' ', '-')
               .gsub(/[^a-z0-9\-]/, '')
  end

  def self.get_page_number_from_argument(arguments)
    if arguments.length == 0
      raise ArgumentError.new 'Mandatory page argument'
    end

    unless arguments[0] =~ /^[0-9]{1,3}$/
      raise ArgumentError.new 'Argument page must be a numeric'
    end

    return arguments[0].to_i
  end

  def self.write_file(filename, data)
    file = File.new('./data/' + '/' + filename + '.json', 'w')
    file.write JSON.pretty_generate(data)
    file.close
  end

end