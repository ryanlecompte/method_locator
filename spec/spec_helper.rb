$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'method_locator'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
RSpec.configure do |config|
end
