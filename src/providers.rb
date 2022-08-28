require 'faraday'

module Providers

  class Provider

    def initialize(config)
      @host = config['host']
      @uri = config['actresses_uri']
      @pages = config['pages']
      @fetched_data = []
    end

    def fetch
      raise 'this method should be override'
    end

    def get_url_per_page(page)
      @host + '/' + @uri.sub('{PAGE}', String(page))
    end

    def get_http_result(url)
      self.put_console_info url
      response = Faraday.get url

      response.body
    end

    def put_console_info(url)
      puts "\e[32mFetching data from " + url + "\e[0m"
    end

    private :put_console_info
    protected :get_url_per_page
    protected :get_http_result
  end

  class BadoInkVRProvider < Provider

    def fetch

      actress_name_regex = /\<span\sitemprop\=\"name\"\>([^<>]*)\<\/span\>/
      actress_image_regex = /\<img\sclass\=\"girl\-card\-image\slazyLoadContainer(?>\sloaded)?\"\sdata\-src\=\"([^"]*)/

      i = 1
      while i <= @pages

        html_response = self.get_http_result self.get_url_per_page i

        list_of_names_matched = html_response.scan(actress_name_regex)
        list_of_images_matched = html_response.scan(actress_image_regex)

        unless list_of_images_matched.length == list_of_names_matched.length
          raise RuntimeError.new 'List of names not assert with the list of images'
        end

        list_of_names_matched.each_with_index do |value, index|
          image_url = list_of_images_matched[index][0]
          @fetched_data.push({'name' => value[0], 'image_url' => image_url, 'slug': Helpers::slug_actress_generate(value[0]) })
        end

        i += 1
      end
      @fetched_data
    end
  end

  class VirtualTaboo < Provider

    def fetch

      name_and_image_regex = /href\=\"[^\"]+\"\sstyle\=\"background-image\:\s?url\(\'([^\']+)\'\)\;\"\stitle\=\"([^"]+)\"/

      i = 1
      while i <= @pages

        html_response = self.get_http_result self.get_url_per_page i

        list_elements_matched = html_response.scan(name_and_image_regex)

        if list_elements_matched.length === 0
          raise RuntimeError.new 'Empty lists matched elements'
        end

        list_elements_matched.each_with_index do |value|
          @fetched_data.push({'name' => value[1], 'image_url' => value[0], 'slug': Helpers::slug_actress_generate(value[1]) })
        end

        i += 1
      end
      @fetched_data
    end
  end
end