require "http_cache_to_fs/version"
require 'open-uri'

module HttpCacheToFs
  class << self
    attr_accessor :cache_dir, :cache_version

    def init
      FileUtils.mkdir_p(cache_dir_with_version)
    end

    def open(url, force_write: false)
      self.cache_version = '' if cache_version.nil?
      raise('Set cache_dir') if cache_dir.nil?

      if force_write
        set(url) && get(url)
        return
      end
      result = get(url)
      if result
        get(url)
      else
        set(url)
        get(url)
      end
    end

    def to_local_path(url)
      u = url.gsub('/', ',')
      File.join(cache_dir_with_version, u)
    end

    def cache_dir_with_version
      File.join(cache_dir, cache_version)
    end

    private

    def get(url)
      File.exists?(to_local_path(url)) && File.open(to_local_path(url))
    end

    def set(url)
      file = URI.parse(url).open
      File.write(to_local_path(url), file.read)
    end
  end
end

HttpCacheToFs.cache_dir = './lib/http_cache'
