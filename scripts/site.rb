#!/usr/bin/env ruby
require 'redcarpet'
require 'rouge'
class RedRouge < Redcarpet::Render::HTML
   def block_code(code, language) "<pre>" + Rouge.highlight(code, language || "bash", 'html') + "</pre>" end
 end
rc = Redcarpet::Markdown.new(RedRouge.new(with_toc_data: true), { fenced_code_blocks: true, tables: true, footnotes: true })
sitemap = File.open("sitemap.txt", "w")
File.write("index.html", File.read('template.html').gsub("{{ pages }}", "<style type='text/css'>" + Rouge::Themes::Base16.mode(:dark).render(scope: 'pre') + "</style>" +
  Dir.glob("en/**/*").select { |x| File.file?(x) }.map { |x| 
    sitemap.write("https://lite-xl.com" + (x =~ /index\.md/ ? "" : "?/" + x.downcase.gsub(/^en\//, "").gsub(/\.\w+$/, "")) + "\n")
    "<page id='page-#{x.downcase.gsub(/(^en\/[^a-z0-9_\-\/\\]|\.\w+$)/,"").gsub(/[\s\\\/]+/, "-")}'>#{rc.render(File.read(x))}</page>" 
  }.join("\n"))
)
