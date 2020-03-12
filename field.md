## Drupal Field snippets

### Get all fields of content type

```php
$entity_type = 'node';
$bundle = 'page';

$entityManager = \Drupal::service('entity_field.manager');
$fields = $entityManager->getFieldDefinitions($entity_type, $bundle);

```

### Get field settings

```php
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
