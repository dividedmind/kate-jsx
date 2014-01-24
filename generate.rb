#!/usr/bin/env ruby

require 'nokogiri'
#require 'nokogiri/pp'
require 'pp'

jspath = '/usr/share/apps/katepart/syntax/javascript.xml'
xmlpath = '/usr/share/apps/katepart/syntax/xml.xml'

js = Nokogiri::XML(File.read jspath)
xml = Nokogiri::XML(File.read xmlpath)

xml.root.traverse do |elem|
  %w(name attribute context fallthroughContext).each do |a|
    if elem.has_attribute? a
      elem[a] += " (XML)" unless elem[a].start_with? '#'
    end
  end
end

jsx = xml.dup # copy the document to get the entities
jsx.root.remove
jsx.add_child Nokogiri::XML(File.read 'container.xml').root

patches = jsx.at('highlighting').swap js.at('highlighting')
jsx.at('contexts') << xml.at('contexts').children
jsx.at('itemDatas') << xml.at('itemDatas').children

patches.search('context').each do |context|
  p "context[name=\"#{context['name']}\"]"
  jsx.at("context[name=\"#{context['name']}\"]").child.before context.children
end

File.write 'jsx.xml', jsx.to_xml
