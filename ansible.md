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
