require "rake/extensiontask"
require "rake/testtask"

Rake::ExtensionTask.new("point_in_polygon")

Rake::TestTask.new do |t|
  t.libs.push ["lib", "ext/point_in_polygon"]
  t.test_files = FileList["test/test_*.rb"]
  t.verbose = true
end
