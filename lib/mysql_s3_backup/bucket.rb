require "aws/s3"

module MysqlS3Backup
  class Bucket
    def initialize(name, options)
      @name = name
      @s3_options = options.symbolize_keys.merge(:use_ssl => true)
      connect
      create
    end
    
    def connect
      AWS::S3::Base.establish_connection!(@s3_options)
    end
    
    def create
      # It doesn't hurt to try to create a bucket that already exists
      AWS::S3::Bucket.create(@name)
    end
    
    def store(file_name, file)
      AWS::S3::S3Object.store(file_name, open(file), @name)
    end
    
    def copy(file_name, new_file_name)
      AWS::S3::S3Object.copy(file_name, new_file_name, @name)
    end
    
    def fetch(file_name, file)
      open(file, 'w') do |f|
        AWS::S3::S3Object.stream(file_name, @name) do |chunk|
          f.write chunk
        end
      end
    end
  end
end