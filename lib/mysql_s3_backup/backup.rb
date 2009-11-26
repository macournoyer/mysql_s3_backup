require 'tempfile'

module MysqlS3Backup
  class Backup
    def initialize(mysql, bucket)
      @mysql = mysql
      @bucket = bucket
    end
    
    def full
      name = make_new_name
      
      with_temp_file do |file|
        @mysql.dump(file)
        @bucket.store(dump_file_name(name), file)
        @bucket.copy(dump_file_name(name), dump_file_name("latest"))
      end
    end
    
    def incremental
      raise "Set bin_log_dir and enable binary logging in Mysql to use incremental backups" unless @mysql.bin_log_dir
      # TODO
      # @mysql.execute("flush logs")
      # logs = Dir.glob("#{@mysql_bin_log_dir}/mysql-bin.[0-9]*").sort
      # logs_to_archive = logs[0..-2] # all logs except the last
      # logs_to_archive.each do |log|
      #   # The following executes once for each filename in logs_to_archive
      #   AWS::S3::S3Object.store(File.basename(log), open(log), @s3_bucket)
      # end
      # @mysql.execute "purge master logs to '#{File.basename(logs[-1])}'"
    end
    alias :inc :incremental
    
    def restore(name="latest")
      with_temp_file do |file|
        @bucket.fetch(dump_file_name(name), file)
        @mysql.restore(file)
      end
    end
    
    private
      def dump_file_name(name)
        raise ArgumentError, "Need a backup name" unless name.is_a?(String)
        "dump-#{@mysql.database}-#{name}.sql.gz"
      end
    
      def make_new_name
        Time.now.utc.strftime("%Y%m%d%H%M")
      end
    
      def with_temp_file
        dump_file = Tempfile.new("mysql-dump")
        yield dump_file.path
        nil
      ensure
        dump_file.close!
      end
  end
end