require 'uri'

class WebRegression::Application
  def initialize(options)
    @options = options
  end

  def start
    reference_file = @options.reference_file
    uri = URI(@options.url)
    return WebRegression::Comparator.new(reference_file,"#{uri.scheme}://#{uri.host}:#{uri.port}",uri.path,@options).compare
  end
end
