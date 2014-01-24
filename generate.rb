#!/usr/bin/env ruby

require 'nokogiri'

jspath = '/usr/share/apps/katepart/syntax/javascript.xml'
xmlpath = '/usr/share/apps/katepart/syntax/xml.xml'

js = Nokogiri::XML(File.read jspath)
xml = Nokogiri::XML(File.read xmlpath)

jsx = Nokogiri::XML(File.read 'container.xml')
jsx.root.add_child js.at('highlighting')

File.write 'jsx.xml', jsx.to_xml
