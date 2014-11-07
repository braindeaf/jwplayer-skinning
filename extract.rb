#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'fileutils'
require 'base64'

skin = 'pledgemusic'
dir = %(source/#{skin})
file = %(#{dir}/#{skin}.xml)
puts "opening #{file}"

doc = Nokogiri::XML(File.open(file))

doc.xpath('//components/component').each do |component|
  name = component['name']
  dirname = %(#{dir}/#{name})
  FileUtils.mkdir_p(dirname)
  puts "creating source directory #{dirname}"
  component.xpath('elements/element').each do |element|
    image = element['name']
    image_path = %(#{dirname}/#{image}.png)
    puts "extracting #{image} to #{image_path}"
    File.open(image_path, 'wb') do |f|
      f.write(Base64.strict_decode64(element['src']['data:image/png;base64,'.length .. -1]))
    end
  end
end
