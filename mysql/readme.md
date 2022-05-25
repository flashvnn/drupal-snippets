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

### Display all table’s content:

```bash
mysql> SELECT * FROM [table name];
```

### Display overall table’s lines:

```bash
mysql> SELECT COUNT(*) FROM [table name];
```

### Count columns in a table:

```bash
mysql> SELECT SUM(*) FROM [table name];
```

### Drop column from a table:

```bash
mysql> alter table [table name] DROP INDEX [column name];
```

### Delete the whole table:

```bash
mysql> DROP TABLE [table name];
```

### Display all table’s content:

```bash
mysql> SELECT * FROM [table name];
```

### Display all columns and their content from a table:

```bash
mysql> SHOW COLUMNS FROM [table name];

```

### Display all records from a table with the “whatever“:

```bash
mysql> SELECT * FROM [table name] WHERE [field name] = "whatever";
```

### Find all records withOUT the “Bob” in the name column and “3444444 in thephone_numbercolumn sorting them by the phone_number column:


```bash
mysql> SELECT * FROM [table name] WHERE name != "Bob" AND phone_number = '3444444' order by phone_number;
```

### Display all records starting from the ‘bob‘ and ‘3444444′ phone in a specific table:

```bash
mysql> SELECT * FROM [table name] WHERE name like "Bob%" AND phone_number = '3444444';

```


### Adding a new user: connect to a server as root, connect to a database, adding a user, updating privileges:

```bash
mysql -u root -p
mysql> USE mysql;
mysql> INSERT INTO user (Host,User,Password) VALUES('%','username', PASSWORD('password'));
mysql> flush privileges;
```

### To change a user’s password on a remote host db1.example.org using the mysqladmin tool:

```bash
mysqladmin -u username -h db1.example.org -p password 'new-password'

```

### To change user’s password from the MySQL CLI:

```bash
mysql> SET PASSWORD FOR 'user'@'hostname' = PASSWORD('passwordhere');
mysql> flush privileges;

```

### MySQL root reset

```bash

systemctl stop mysql
mysqld_safe --skip-grant-tables &
mysql -u root
mysql> use mysql;
mysql> update user set password=PASSWORD("newrootpassword") where User='root';
mysql> flush privileges;
mysql> quit
systemctl start mysql

```

### To update root‘s password: using mysqladmin:

```bash
mysqladmin -u root -p oldpassword newpassword
```

### Grant specific permissions for user:

```bash
mysql> use mysql;
mysql> INSERT INTO db (Host,Db,User,Select_priv,Insert_priv,Update_priv,Delete_priv,Create_priv,Drop_priv) VALUES ('%','databasename','username','Y','Y','Y','Y','Y','N');
mysql> flush privileges;
```

### Or just grant everything:

```bash
mysql> grant all privileges on databasename.* to username@localhost;
mysql> flush privileges;
```

### Setting specific permissions for a user per specific table:

```bash
mysql> UPDATE [table name] SET Select_priv = 'Y',Insert_priv = 'Y',Update_priv = 'Y' where [field name] = 'user';
```

### Create a backup (dump) from all databases into the alldatabases.sql file:

```bash
mysqldump -u root -p password --opt >/tmp/alldatabases.sql

```

### Create a backup (dump) from a database with the databasename name into the databasename.sql file:

```bash
mysqldump -u username -p password --databases databasename >/tmp/databasename.sql

```

### Create one table’s backup into the databasename.tablename.sql file:

```bash
mysqldump -c -u username -p password databasename tablename > /tmp/databasename.tablename.sql

```

### To restore database(s) or table(s) from a backup:

```bash
mysql -u username -p password databasename < /tmp/databasename.sql

```
