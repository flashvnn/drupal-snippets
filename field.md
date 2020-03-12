## Drupal Field snippets

### Get all fields of content type

```php
$entity_type = 'node';
$bundle = 'page';

$entityManager = \Drupal::service('entity_field.manager');
$fields = $entityManager->getFieldDefinitions($entity_type, $bundle);

```
