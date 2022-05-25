# MySQL/MariaDB: most used commands with examples

Reference: https://rtfm.co.ua/en/mysql-mariadb-most-used-commands-with-examples/

## General commands

### To check MySQL status run:

```bash
systemctl status mysql
systemctl status mariadb.service

service mysql status
service mariadb status
 
```

### Start Mysql

```bash

# Centos 6 #
# service mysql start
or
# /etc/init.d/mysql start
# Centos 7 #
# systemctl start mariadb.service
or
# systemctl start mysql.service
or
# systemctl start mariadb
or
# systemctl start mysql

```

### Stop Mysql

```bash
# Centos 6 #
# service mysql stop
or
# /etc/init.d/mysql stop

# Centos 7 #
# systemctl stop mariadb.service
or
# systemctl stop mysql.service
or
# systemctl stop mariadb
or
# systemctl stop mysql

```

### Restart Mysql

```bash
# Centos 6 #
# service mysql restart
or
# /etc/init.d/mysql restart

# Centos 7 #
# systemctl restart mariadb.service
or
# systemctl restart mysql.service
or
# systemctl restart mariadb
or
# systemctl restart mysql
```

### To connect to a MySQL server running on the same host:

```bash
mysql -u username -p
```

### To connect to a MySQL server running on the remote host db1.example.com:

```bash
mysql -u username -p -h db1.example.com
```

## Working with databases and tables

### To create a database:

```bash
mysql> CREATE DATABASE [databasename];
```

### List all databases on the current MySQL server:

```bash
mysql> SHOW DATABASES;
```

### Connect to a database to start working with it:

```bash
mysql> USE [db name];
```

### To delete database:

```bash
mysql> DROP DATABASE [database name];
```

### List all tables in a current database:

```bash
mysql> SHOW TABLES;
```

### Display table’s columns types and descriptions:

```bash
mysql> DESCRIBE [table name];
```

