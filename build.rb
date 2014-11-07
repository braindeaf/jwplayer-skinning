#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'fileutils'
require 'base64'

skin = 'pledgemusic'
dir = %(source/#{skin})
file = %(#{dir}/#{skin}.xml)
puts "opening #{file}"

doc = Nokogiri::XML(File.open(file),'utf-8')

doc.xpath('//components/component').each do |component|
  name = component['name']
  dirname = %(#{dir}/#{name})
  component.xpath('elements/element').each do |element|
    puts element
    image = element['name']
    image_path = %(#{dirname}/#{image}.png)
    raw = File.binread(image_path)
    encoded = ('data:image/png;base64,' + Base64.strict_encode64(raw))
    element.set_attribute('src', encoded)
  end
end
File.open(file.gsub('.xml','.new.xml'), 'w') do |f|
  f.puts doc.to_xml
end
