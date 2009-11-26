require "rubygems"
require "spec"
$:.unshift File.dirname(__FILE__) + "/../lib"
require "mysql_s3_backup"

CONFIG = MysqlS3Backup::Config.from_yaml_file(File.dirname(__FILE__) + "/../config/test.yml")

module Helpers
  def execute_sql_file(file)
    CONFIG.mysql.execute_file File.dirname(__FILE__) + "/#{file}"
  end
end

Spec::Runner.configure do |config|
  config.include Helpers
end