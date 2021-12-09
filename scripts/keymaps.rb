#!/usr/bin/env ruby

raise "Requires a path to lite-xl." unless ARGV[0] && File.exist?(ARGV[0])
["", "-macos"].each { |os| 
  file = "en/documentation/keymap#{os}.md"
  File.write(file, File.read(file).gsub(/(^\s*##.*?$).*/ms, "\\1\n\n|Key Combination|Actions|\n|---------------|-------|\n" + File.read("#{ARGV[0]}/data/core/keymap#{os}.lua").gsub(/.*keymap.add_direct {/msi, "")
    .gsub(/^\s*}\s*$.*/msi, "").gsub(/^\s*\[/, "").split("\n").flat_map { |x| 
      parts = x.gsub(/["{}]"?/, "").gsub(/,\s*$/, "").split(/\]\s*=\s*/msi)
      parts[1].split(",").map { |y| "|" + parts[0].split("+").map { |x| "`#{x}`" }.join("+") + "|`#{y}`|" }
    }.sort.select { |x| x =~ /(cmd|option|alt|ctrl|f\d)/ }.join("\n")))
}
