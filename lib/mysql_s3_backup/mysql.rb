module MysqlS3Backup
  class Mysql
    include Shell
    
    attr_reader :database, :bin_log_path
    
    def initialize(options)
      options = options.symbolize_keys
      @user = options[:user] || raise(ArgumentError, "user required")
      @password = options[:password]
      @database = options[:database] || raise(ArgumentError, "database required")
      @bin_log_path = options[:bin_log]
    end
    
    def cli_options
      cmd = "-u'#{@user}'"
      cmd += " -p'#{@password}'" if @password
      cmd += " #{@database}"
      cmd
    end
    
    def execute(sql)
      run %{mysql -e "#{sql}" #{cli_options}}
    end
    
    def dump(file)
      cmd = "mysqldump --quick --single-transaction --create-options -u'#{@user}'"
      cmd += " --flush-logs --master-data=2 --delete-master-logs" if @bin_log_path
      cmd += " -p'#{@password}'" if @password
      cmd += " #{@database} | gzip > #{file}"
      run cmd
    end
    
    def restore(file)
      run "gunzip -c #{file} | mysql #{cli_options}"
    end
    
    def each_bin_log
      execute "flush logs"
      logs = Dir.glob("#{@bin_log_path}.[0-9]*").sort
      logs_to_archive = logs[0..-2] # all logs except the last
      logs_to_archive.each do |log|
        yield log
      end
      execute "purge master logs to '#{File.basename(logs[-1])}'"
    end
    
    def apply_bin_log(file)
      cmd = "mysqlbinlog --database=#{@database} #{file} | mysql -u#{@user} "
      cmd += " -p'#{@password}' " if @password
      run cmd
    end
  end
end