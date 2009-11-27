require "spec/rake/spectask"

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-fs -c)
  t.spec_files = FileList["spec/**_spec.rb"]
end

task :gem do
  sh "gem build mysql_s3_backup.gemspec"
end

task :push => :gem do
  file = Dir["*.gem"].sort.last
  puts "gem push #{file}"
end