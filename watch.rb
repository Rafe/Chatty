spec = "jasmine-node --coffee "

watch("src/app/(.*)\.coffee") do |md|
  system "coffee -o app -c #{md[0]}"
  system "jasmine-node --coffee specs/#{md[1]}_spec.coffee"
end

watch("specs/(.*)_spec.coffee"){|md| system "#{spec} #{md[0]}" }
