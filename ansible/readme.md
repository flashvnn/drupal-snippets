## vagrant resync updated ansible to vm machine

```shell
vagrant rsync
```

## Check mysql installed

```yml
- name: check mysql version
  shell: mysql --version
  register: mysql_version
  ignore_errors: true
  changed_when: false
  failed_when: false
```

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

## Install Drupal from git

```yml
- name: Check out Drupal Core to the Apache docroot.
  git:
    repo: http://git.drupal.org/project/drupal.git
    version: "{{ drupal_core_version }}"
    dest: "{{ drupal_core_path }}"
- name: Install Drupal.
  command: >
    drush si -y --site-name="{{ drupal_site_name }}" --account-name=admin
    --account-pass=admin --db-url=mysql://root@localhost/{{ domain }}
    chdir={{ drupal_core_path }}
    creates={{ drupal_core_path }}/sites/default/settings.php
  notify: restart apache

- name: Set permissions properly on settings.php.
  file:
    path: "{{ drupal_core_path }}/sites/default/settings.php"
    mode: 0744

- name: Set permissions on files directory.
  file:
    path: "{{ drupal_core_path }}/sites/default/files"
    mode: 0777
    state: directory
    recurse: yes

```

