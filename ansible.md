## Configure PHP ini with lineinfile

```yml
- name: Enable upload progress via APC.
  lineinfile:
    dest: "/etc/php5/apache2/conf.d/20-apcu.ini"
    regexp: "^apc.rfc1867"
    line: "apc.rfc1867 = 1"
    state: present
  notify: restart apache
```

## Config mysql

```yml
- name: Remove the MySQL test database.
  mysql_db: db=test state=absent
- name: Create a database for Drupal.
  mysql_db: "db={{ domain }} state=present"
  
```

## Install composer

```yml
- name: Install Composer into the current directory.
  shell: >
    curl -sS https://getcomposer.org/installer | php
    creates=/usr/local/bin/composer
- name: Move Composer into globally-accessible location.
  shell: >
    mv composer.phar /usr/local/bin/composer
    creates=/usr/local/bin/composer

```

## Create symlink

```yml
- name: Create drush bin symlink.
  file:
    src: /opt/drush/drush
    dest: /usr/local/bin/drush
    state: link
```
