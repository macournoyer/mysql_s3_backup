Gem::Specification.new do |s|
  s.name            = "mysql_s3_backup"
  s.version         = "0.0.1"
 
  s.authors         = ["Marc-Andre Cournoyer"]
  s.email           = "macournoyer@gmail.com"
  s.files           = Dir["**/*"]
  s.homepage        = "http://github.com/macournoyer/mysql_s3_backup"
  s.require_paths   = ["lib"]
  s.bindir          = "bin"
  s.executables     = Dir["bin/*"].map { |f| File.basename(f) }
  s.summary         = "A simple backup script for Mysql and S3 with incremental backups."
  s.test_files      = Dir["spec/**"]
  
  s.add_dependency  "aws-s3"
end