module MysqlS3Backup
  class Mysql
    include Shell
    
    attr_reader :database, :bin_log_dir
    
    def initialize(options)
      options = options.symbolize_keys
      @user = options[:user] || raise(ArgumentError, "user required")
      @password = options[:password]
      @database = options[:database] || raise(ArgumentError, "database required")
      @bin_log_dir = options[:bin_log_dir]
    end
    
    def cli_options
      cmd = "-u'#{@user}'"
      cmd += " -p'#{@password}'" if @password
      cmd += " #{@database}"
      cmd
    end
    
    def execute(sql)
      run %{mysql -e "#{sql}" #{cli_options(false)}}
    end
    
    def dump(file)
      cmd = "mysqldump --quick --single-transaction --create-options -u'#{@user}'"
      cmd = " --flush-logs --master-data=2 --delete-master-logs" if @bin_log_dir
      cmd += " -p'#{@password}'" if @password
      cmd += " #{@database} | gzip > #{file}"
      run cmd
    end
    
    def restore(file)
      run "gunzip -c #{file} | mysql #{cli_options}"
    end
  end
end