# Send you Mysql backups to S3
And simple backup script for Mysql and S3 with incremental backups.

## Configuration

Based on Paul Dowman's http://github.com/pauldowman/blog_code_examples so read this first.

To use incremental backups you need to enable binary logging by making sure that the MySQL config file (my.cnf) has the following line in it:

    log_bin = /var/db/mysql/binlog/mysql-bin

The MySQL user needs to have the RELOAD and the SUPER privileges, these can be granted with the following SQL commands (which need to be executed as the MySQL root user):

    GRANT RELOAD ON *.* TO 'user_name'@'%' IDENTIFIED BY 'password';
    GRANT SUPER ON *.* TO 'user_name'@'%' IDENTIFIED BY 'password';

## Usage

Backing up:

  mysql_s3_backup -c=your_config.yml full

Incremental backups:

  mysql_s3_backup -c=your_config.yml inc

Restore the latest backup:

  mysql_s3_backup -c=your_config.yml restore

Restore a specific backup:

  mysql_s3_backup -c=your_config.yml restore 20091126112233

## Running the specs

Create a config file in config/test.yml
