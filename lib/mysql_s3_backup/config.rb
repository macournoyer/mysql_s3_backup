require "yaml"

module MysqlS3Backup
  class Config
    attr_reader :mysql_config, :s3_config, :bucket
    
    def initialize(config)
      config = config.symbolize_keys
      @mysql_config = config[:mysql].symbolize_keys
      @s3_config = config[:s3].symbolize_keys
      @bucket = @s3_config.delete(:bucket)
    end
    
    def mysql
      MysqlS3Backup::Mysql.new(@mysql_config)
    end
    
    def bucket
      MysqlS3Backup::Bucket.new(@bucket, @s3_config)
    end
    
    def backup
      MysqlS3Backup::Backup.new(mysql, bucket)
    end
    
    def self.from_yaml_file(file)
      new YAML.load_file(file)
    end
  end
end