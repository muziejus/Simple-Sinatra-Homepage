require './app'
require 'autoprefixer-rails'

map '/assets' do
  assets = Sprockets::Environment.new
  assets.append_path 'assets/javascripts'
  assets.append_path 'assets/stylesheets'
  assets.append_path 'assets/templates'
  AutoprefixerRails.install(assets)
  run assets
end

map '/' do
  run App.new
end
# use Rack::Deflater

