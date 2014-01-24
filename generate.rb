#!/usr/bin/env ruby

require 'nokogiri'

jspath = '/usr/share/apps/katepart/syntax/javascript.xml'
xmlpath = '/usr/share/apps/katepart/syntax/xml.xml'

js = Nokogiri::XML(File.read jspath)
xml = Nokogiri::XML(File.read xmlpath)

js.traverse do |elem|
  %w(name attribute context fallthroughContext).each do |a|
    if elem.has_attribute? a
      elem[a] += " (JS)" unless elem[a].start_with? '#'
    end
  end
end

jsx = Nokogiri::XML(File.read 'container.xml')
jsx.root.add_child js.at('highlighting')

File.write 'jsx.xml', jsx.to_xml
