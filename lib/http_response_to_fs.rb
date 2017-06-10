require "http_response_to_fs/version"
require 'open-uri'

module HttpResponseTofs
  class << self
    attr_accessor :cache_dir, :cache_version

    def init
      FileUtils.mkdir_p(cache_dir_with_version)
    end

    def open(url, force_write: false)
      error_if_cache_dir_nil!
      if force_write
        set(url) && get(url)
        return
      end
      get(url) || set(url)
    end

    def to_local_path(url)
      u = url.gsub('/', ',')
      File.join(cache_dir_with_version, u)
    end

    def cache_dir_with_version
      error_if_cache_dir_nil!
      File.join(cache_dir, (cache_version || ''))
    end

    private

    def get(url)
      File.exists?(to_local_path(url)) && File.open(to_local_path(url))
    end

    def set(url)
      file = URI.parse(url).open
      File.write(to_local_path(url), file.read)
      get(url)
    ensure
      file.close unless file.closed?
    end

    def error_if_cache_dir_nil!
      raise('Set cache_dir') if cache_dir.nil?
    end
  end
end
