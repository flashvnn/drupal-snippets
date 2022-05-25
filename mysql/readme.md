# MySQL/MariaDB: most used commands with examples

Reference: https://rtfm.co.ua/en/mysql-mariadb-most-used-commands-with-examples/

## General commands

### To check MySQL status run:

```bash
systemctl status mysql
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

