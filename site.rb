#!/usr/bin/env ruby
require 'redcarpet'
require 'rouge'
require 'fileutils'

class RedRouge < Redcarpet::Render::HTML
  def block_code(code, language) "<pre>" + Rouge.highlight(code, language || "bash", 'html') + "</pre>" end
  def link(link, title, link_content) "<a title='#{title}' #{link =~ /^(http|\/?assets)/ && "target='_blank'"} href='#{link}'>#{link_content}</a>" end
end
rc = Redcarpet::Markdown.new(RedRouge.new(with_toc_data: true), { fenced_code_blocks: true, tables: true, footnotes: true })
sitemap = File.open("sitemap.txt", "w")
sitemap.puts("https://lite-xl.com");
Dir.glob("locales/*").map { |x| x.gsub("locales/", "") }.map { |locale| 
  template = File.read("locales/#{locale}/template.html")
  FileUtils.rm_rf("#{locale}")
  Dir.glob("locales/#{locale}/**/*.md").select { |x| File.file?(x) }.map { |path|
    target = path.gsub(/\.md/,".html").gsub(/^locales\//, "")
    FileUtils.mkdir_p(File.dirname(target)) if !Dir.exist?(File.dirname(target))
    contents = rc.render(File.read(path))
    title = (contents.scan(/<\s*h1.*?>(.*?)<\s*\/h1\s*>/).first || ["Lite XL"]).first
    title = "Lite XL - #{title}" if title != "Lite XL"
    id = path.gsub("locales/#{locale}", "").gsub(/\.(\w+)$/, "").downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\-+/, "-").gsub(/^\-|\-$/, "")
    File.write(target, template.gsub("{{ page }}", contents).gsub("{{ title }}", title).gsub("{{ id }}", id))
    sitemap.write("https://lite-xl.com/#{target == 'index.html' ? '' : target}\n")
  }
}
