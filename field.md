## Drupal Field snippets

### Get all fields of content type

```php
<?php
$entity_type = 'node';
$bundle = 'page';

$entityManager = \Drupal::service('entity_field.manager');
$fields = $entityManager->getFieldDefinitions($entity_type, $bundle);

```

### Get field settings

```php
<?php
$image = $fields['field_image_select'];
$settings = $image->getSettings();

var_dump ($settings)
//=====Output=====
array (
  'file_directory' => '[date:custom:Y]-[date:custom:m]',
  'file_extensions' => 'png gif jpg jpeg',
  'max_filesize' => '',
  'max_resolution' => '',
  'min_resolution' => '',
  'alt_field' => true,
  'alt_field_required' => true,
  'title_field' => false,
  'title_field_required' => false,
  'default_image' => 
  array (
    'uuid' => '',
    'alt' => '',
    'title' => '',
    'width' => NULL,
    'height' => NULL,
  ),
  'handler' => 'default:file',
  'handler_settings' => 
  array (
  ),
  'uri_scheme' => 'public',
  'target_type' => 'file',
  'display_field' => false,
  'display_default' => false,
)
```

### Get field storage

```php
<?php

$storage = $image->getFieldStorageDefinition();

Drupal\field\Entity\FieldStorageConfig::__set_state(array(
   'id' => 'node.field_image_select',
   'field_name' => 'field_image_select',
   'entity_type' => 'node',
   'type' => 'image',
   'module' => 'image',
   'settings' => 
  array (
    'uri_scheme' => 'public',
    'default_image' => 
    array (
      'uuid' => '',
      'alt' => '',
      'title' => '',
      'width' => NULL,
      'height' => NULL,
    ),
    'target_type' => 'file',
    'display_field' => false,
    'display_default' => false,
  ),
   'cardinality' => 1,
   'translatable' => true,
   'locked' => false,
   'persist_with_no_fields' => false,
   'custom_storage' => false,
   'indexes' => 
  array (
  ),
   'deleted' => false,
   'schema' => NULL,
   'propertyDefinitions' => NULL,
   'originalId' => 'node.field_image_select',
   'status' => true,
   'uuid' => 'e2f86f6e-0ba0-40e5-8b93-4088779defa8',
   'isUninstalling' => false,
   'langcode' => 'en',
   'third_party_settings' => 
  array (
  ),
   '_core' => 
  array (
  ),
   'trustedData' => false,
   'entityTypeId' => 'field_storage_config',
   'enforceIsNew' => NULL,
   'typedData' => NULL,
   'cacheContexts' => 
  array (
    0 => 'languages:language_interface',
  ),
   'cacheTags' => 
  array (
  ),
   'cacheMaxAge' => -1,
   '_serviceIds' => 
  array (
  ),
   '_entityStorages' => 
  array (
  ),
   'dependencies' => 
  array (
    'module' => 
    array (
      0 => 'file',
      1 => 'image',
      2 => 'node',
    ),
  ),
   'isSyncing' => false,
))

```
