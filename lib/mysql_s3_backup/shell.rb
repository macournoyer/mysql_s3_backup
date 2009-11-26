module MysqlS3Backup
  class ShellCommandError < RuntimeError ; end
  
  module Shell
    def run(command)
      puts command if $VERBOSE
      result = system(command)
      raise ShellCommandError, "error, process exited with status #{$?.exitstatus}" unless result
    end
  end
end