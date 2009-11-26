require File.dirname(__FILE__) + "/spec_helper"

describe MysqlS3Backup::Backup do
  after do
    CONFIG.bucket.delete_all(CONFIG.mysql_config[:database])
  end
  
  it "should restore from full backup" do
    backup = CONFIG.backup
    
    execute_sql_file "load.sql"
    execute_sql_file "insert.sql"
    
    backup.full
    
    execute_sql_file "drop.sql"
    backup.restore
    
    backup.mysql.execute("select count(*) as n from users;").should == "n\n1"
  end
  
  it "should restore from incremental backup" do
    backup = CONFIG.backup
    
    execute_sql_file "load.sql"
    backup.full
    
    execute_sql_file "insert.sql"
    backup.inc
    
    execute_sql_file "drop.sql"
    backup.restore
    
    backup.mysql.execute("select count(*) as n from users;").should == "n\n1"
  end
  
  it "should restore named backup and ignore binary logs" do
    backup = CONFIG.backup
    
    execute_sql_file "load.sql"
    backup.full("named")
    
    execute_sql_file "insert.sql"
    backup.inc
    
    execute_sql_file "drop.sql"
    backup.restore("named")
    
    backup.mysql.execute("select count(*) as n from users;").should == "n\n0"
  end
end