require 'tempfile'

module MysqlS3Backup
  class Backup
    def initialize(mysql, bucket)
      @mysql = mysql
      @bucket = bucket
    end
    
    def full
      name = make_new_name
      
      # When the full backup runs it delete any binary log files that might already exist
      # in the bucket. Otherwise the restore will try to restore them even though they’re
      # older than the full backup.
      @bucket.delete_all "bin_log"
      
      with_temp_file do |file|
        @mysql.dump(file)
        @bucket.store(dump_file_name(name), file)
        @bucket.copy(dump_file_name(name), dump_file_name("latest"))
      end
    end
    
    def incremental
      @mysql.each_bin_log do |log|
        @bucket.store "bin_log/#{File.basename(log)}", log
      end
    end
    alias :inc :incremental
    
    def restore(name="latest")
      # restore from the dump file
      with_temp_file do |file|
        @bucket.fetch(dump_file_name(name), file)
        @mysql.restore(file)
      end
      
      if name == "latest"
        # Restoring binary log files
        @bucket.find("bin_log/").sort.each do |log|
          with_temp_file do |file|
            @bucket.fetch log, file
            @mysql.apply_bin_log file
          end
        end
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