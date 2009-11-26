# Send you Mysql backups to S3

Based on Paul Dowman's http://github.com/pauldowman/blog_code_examples

To use incremental backups you need to enable binary logging by making sure that the MySQL config file (my.cnf) has the following line in it:

    log_bin = /var/db/mysql/binlog/mysql-bin

The MySQL user needs to have the RELOAD and the SUPER privileges, these can be granted with the following SQL commands (which need to be executed as the MySQL root user):

    GRANT RELOAD ON *.* TO 'user_name'@'%' IDENTIFIED BY 'password';
    GRANT SUPER ON *.* TO 'user_name'@'%' IDENTIFIED BY 'password';

