# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "currency-rate"
  gem.homepage = "http://github.com/snitko/currency-rate"
  gem.license = "MIT"
  gem.summary = %Q{Converter for fiat and crypto currencies}
  gem.description = %Q{Fetches exchange rates from various sources and does the conversion}
  gem.email = "roman.snitko@gmail.com"
  gem.authors = ["Roman Snitko"]
end
