require 'json'
require 'digest'
require 'open-uri'

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

  def self.write_json_file(filename, data)
    file = File.new('./data/' + '/' + filename + '.json', 'w')
    file.write JSON.pretty_generate(data)
    file.close
  end

  def self.download_and_write_image_file(filename, url)

    if File.exist?('./images/actress/' + filename)
      return
    end

    File.open('./images/actress/' + filename, 'wb') do|file|
      file.write open(url).read
    end

  end

  def self.get_image_filename(provider_name, url)

    puts "#{url}\n"

    extensions = url.scan(/(jpeg|png|git|webp|jpg)/)

    if extensions[0] == nil
      return nil
    end

    md5 = Digest::MD5.new
    md5 << url
    return "#{provider_name.downcase}-#{md5.hexdigest}.#{extensions[0][0]}"

  end

end