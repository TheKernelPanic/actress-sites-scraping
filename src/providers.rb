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
      puts "\e[33mFetching data from " + url + "\e[0m"
    end

    def iterate_pages(initial_page=1, &handler)
      i = initial_page
      while i <= @pages
        handler.call i
        i += 1
      end
    end

    protected :put_console_info
    protected :get_url_per_page
    protected :get_http_result
  end

  class BadoInkVRProvider < Provider

    def fetch
      self.iterate_pages do |page|
        html_response = self.get_http_result self.get_url_per_page page

        list_of_names_matched = html_response.scan(/\<span\sitemprop\=\"name\"\>([^<>]*)\<\/span\>/)
        list_of_images_matched = html_response.scan(/\<img\sclass\=\"girl\-card\-image\slazyLoadContainer(?>\sloaded)?\"\sdata\-src\=\"([^"]*)/)

        unless list_of_images_matched.length == list_of_names_matched.length
          raise RuntimeError.new 'List of names not assert with the list of images'
        end

        list_of_names_matched.each_with_index do |value, index|
          image_url = list_of_images_matched[index][0]
          @fetched_data.push({'name' => value[0], 'image_url' => image_url, 'slug': Helpers::slug_actress_generate(value[0]) })
        end
      end
      @fetched_data
    end
  end

  class VirtualTaboo < Provider

    def fetch

      self.iterate_pages do |page|
        html_response = self.get_http_result self.get_url_per_page page

        list_elements_matched = html_response.scan(/href\=\"[^\"]+\"\sstyle\=\"background-image\:\s?url\(\'([^\']+)\'\)\;\"\stitle\=\"([^"]+)\"/)

        if list_elements_matched.length === 0
          raise RuntimeError.new 'Empty lists matched elements'
        end

        list_elements_matched.each_with_index do |value|
          @fetched_data.push({'name' => value[1], 'image_url' => value[0], 'slug': Helpers::slug_actress_generate(value[1]) })
        end
      end
      @fetched_data
    end
  end

  class NaughtyAmerica < Provider

    def fetch
      self.iterate_pages do |page|
        html_response = self.get_http_result self.get_url_per_page page

        list_of_names_matched = html_response.scan(/class\=\"performer\-name\sellipsis\"\shref\=\"[^"]+\"\>([^\>\<]+)\<\/a>/)
        list_of_images_matched = html_response.scan(/href\=\"([^"]+)\"\sclass\=\"performer\-image\"/)

        unless list_of_images_matched.length == list_of_names_matched.length
          raise RuntimeError.new 'List of names not assert with the list of images'
        end

        list_of_names_matched.each_with_index do |value, index|
          image_url = list_of_images_matched[index][0]
          @fetched_data.push({'name' => value[0], 'image_url' => image_url, 'slug': Helpers::slug_actress_generate(value[0]) })
        end
      end
      @fetched_data
    end
  end

  class VrBangers < Provider

    def fetch
      self.iterate_pages do |page|
        html_response = self.get_http_result self.get_url_per_page page

        list_of_names_matched = html_response.scan(/model\-item\-name\"[^\>]+\>\s+([^\<]+)\s/)
        list_of_images_matched = html_response.scan(/data\-src\=\"([^\"]+)\"\s[^>]+\sdata\-testid\=\"model\-item\-img\"/)

        unless list_of_images_matched.length == list_of_names_matched.length
          raise RuntimeError.new 'List of names not assert with the list of images'
        end

        list_of_names_matched.each_with_index do |value, index|
          image_url = list_of_images_matched[index][0]
          @fetched_data.push({'name' => value[0], 'image_url' => image_url, 'slug': Helpers::slug_actress_generate(value[0]) })
        end
      end
      @fetched_data
    end
  end

  class PoVr < Provider

    def fetch
      self.iterate_pages 2 do |page|
        html_response = self.get_http_result self.get_url_per_page page

        list_elements_matched = html_response.scan(/class\=\"thumbnail__img\"\ssrc\=\"([^\"]+)\"\salt\=\"([^\"]+)\"/)

        if list_elements_matched.length === 0
          raise RuntimeError.new 'Empty lists matched elements'
        end

        list_elements_matched.each_with_index do |value|
          @fetched_data.push({'name' => value[1], 'image_url' => value[0], 'slug': Helpers::slug_actress_generate(value[1]) })
        end
      end
      @fetched_data
    end
  end

  class WankzVR < Provider

    def fetch
      self.iterate_pages do |page|
        html_response = self.get_http_result self.get_url_per_page page

        list_of_names_matched = html_response.scan(/\"teaser\_\_title\"\>([^\>]+)/)
        list_of_images_matched = html_response.scan(/src\=\"([^\"]+)\"\stype\=\"image\/jpeg\"/)

        unless list_of_images_matched.length == list_of_names_matched.length
          raise RuntimeError.new 'List of names not assert with the list of images'
        end

        list_of_names_matched.each_with_index do |value, index|
          image_url = list_of_images_matched[index][0]
          @fetched_data.push({'name' => value[0], 'image_url' => image_url, 'slug': Helpers::slug_actress_generate(value[0]) })
        end
      end
      @fetched_data
    end
  end
end