# Send your Mysql backups to S3
A simple backup script for Mysql and S3 with incremental backups.

It's all based on Paul Dowman's blog post: http://pauldowman.com/2009/02/08/mysql-s3-backup/, so read this first.

## Configuration

To use incremental backups you need to enable binary logging by making sure that the MySQL config file (my.cnf) has the following line in it:

    log_bin = /var/db/mysql/binlog/mysql-bin

The MySQL user needs to have the RELOAD and the SUPER privileges, these can be granted with the following SQL commands (which need to be executed as the MySQL root user):

    GRANT RELOAD ON *.* TO 'user_name'@'%' IDENTIFIED BY 'password';
    GRANT SUPER ON *.* TO 'user_name'@'%' IDENTIFIED BY 'password';

## Usage

Create a YAML config file:

    mysql:
      # Database name to backup
      database: muffins_development
      # Mysql user and password to execute commands
      user: root
      password: secret
      # Path to mysql binaries, like mysql, mysqldump (optional)
      bin_path: /usr/bin/
      # Path to the binary logs, should match the bin_log option in your my.cnf
      bin_log: /var/lib/mysql/binlog/mysql-bin

    s3:
      # S3 bucket name to backup to
      bucket: db_backups
      # S3 credentials
      access_key_id: XXXXXXXXXXXXXXX
      secret_access_key: XXXXXXXXXXXXXXXXXXXXXX

Create a full backup:

    mysql_s3_backup -c=your_config.yml full

Create an incremental backup:

    mysql_s3_backup -c=your_config.yml inc

Restore the latest backup (applying incremental backups):

    mysql_s3_backup -c=your_config.yml restore

Restore a specific backup (NOT applying incremental backups):

    mysql_s3_backup -c=your_config.yml restore 20091126112233

## Running the specs

Create a config file in config/test.yml
