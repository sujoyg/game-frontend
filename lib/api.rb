require 'restclient'

class API
  def self.method_missing(method, endpoint, options={})
    url = File.join "#{$globals.api.scheme}://#{$globals.api.host}", endpoint
    RestClient.send method, url, options
  end

  def self.put(path, *args)
    url = File.join "#{$globals.api.scheme}://#{$globals.api.host}", path
    RestClient.put url, *args
  end
end
