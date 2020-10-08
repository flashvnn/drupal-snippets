# Config PHPStorm for Drupal development

## Drupal project enabled :

![](https://github.com/flashvnn/drupal-snippets/blob/master/drupal-enable.jpg)

## Turn off parameter hint
![](https://github.com/flashvnn/drupal-snippets/blob/master/2019-10-21_10h02_50.jpg)

## Install Drupal Symfony Bridge plugin
![](https://github.com/flashvnn/drupal-snippets/blob/master/2019-10-21_10h03_47.jpg)

## Set Drupal code style
![](https://github.com/flashvnn/drupal-snippets/blob/master/drupal-code-style.jpg)


## PHPStorm meta data

https://www.drupal.org/project/phpstorm_metadata

![](https://www.drupal.org/files/project-images/phpstorm_metadata.png)


## Fix Git newline issue when export Drupal config
```
Run git command:
git config --global core.autocrlf false
git config --global core.safecrlf false
```
Setting for PHPSTORM
![](https://github.com/flashvnn/drupal-snippets/blob/master/2019-10-23_13h23_19.jpg)

## PHPCS with PHPSTORM

![](https://github.com/flashvnn/drupal-snippets/blob/master/phpcs-1.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/phpcs-2.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/phpcs-3.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/phpcs4.jpg)

## Use XDebug with PHPStorm

Config XDebug in php.ini

```ini
; config for xdebug
[xdebug]
zend_extension="D:\DevDesktop\php7_1\php_xdebug-2.5.5-7.1-vc14.dll" ; Path to php_xdebug*.dll
xdebug.profiler_enable = 0
xdebug.profiler_output_dir = "D:\DevDesktop\temp"
xdebug.remote_enable=1
xdebug.remote_host=localhost
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.max_nesting_level=500
xdebug.idekey=PHPSTORM
```

Verify XDebug enabled
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebug-verify.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebug-config-0.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebugconfig-1.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebug-config-2.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebug-config-3.jpg)


## XDebug with Ubuntu WSL
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebug_wsl_1.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebug_wsl_2.jpg)
![](https://github.com/flashvnn/drupal-snippets/blob/master/xdebug_wsl_3.jpg)

