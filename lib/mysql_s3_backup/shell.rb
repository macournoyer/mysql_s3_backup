module MysqlS3Backup
  class ShellCommandError < RuntimeError ; end
  
  module Shell
    def run(command)
      puts command if $VERBOSE
      result = `#{command}`.chomp
      puts result if $VERBOSE
      raise ShellCommandError, "error, process exited with status #{$?.exitstatus}: #{result}" unless $?.success?
      result
    end
  end
end