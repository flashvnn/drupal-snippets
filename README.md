## Query for entities using dates in Drupal 8
https://www.webomelette.com/query-entities-using-dates-drupal-8


## Drupal send file/image response 

https://ourcodeworld.com/articles/read/329/how-to-send-a-file-as-response-from-a-controller-in-symfony-3


## Remove file from Git after add to gitignore

https://eric.blog/2014/05/11/remove-files-from-git-addingupdating-gitignore/

```
git rm --cached <file>

```

## Add node, paragraph template in module
```php
/**
 * Implements hook_theme().
 */
function MODULENAME_theme() {
    $theme['paragraph__MODULE_NAME__TYPE'] = [
        'base hook' => 'paragraph'
    ];
    return $theme;
}

/**
 * Implements HOOK_theme_suggestions_HOOK_alter().
 */
function MODULENAME_theme_suggestions_paragraph_alter(&$suggestions, $variables){
    $entity              = $variables['elements']['#paragraph'];
    $sanitized_view_mode = strtr($variables['elements']['#view_mode'], '.', '_');
    $type                = $entity->getType();

    if($type == TYPE) {
        $suggestions[] = 'paragraph__MODULENAME__' . $type;
        $suggestions[] = 'paragraph__MODULENAME__' . $type . '__' . $sanitized_view_mode;
    }
}
```


## Working with database

https://drupaloutsourcing.com/blog/work-database-drupal-8
```php
#  1.The simplest sample with condition
$query = \ Drupal :: database ()->select('node_field_data', 'nfd');
$query->fields('nfd', ['uid', 'title']);
$query->condition('nfd.nid', 1);
$result = $query->execute()->fetchAll ();
```
```php
# 2. Selection of one value
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->addField('nfd', 'title');
$query->condition('nfd.nid', 1); 
$result = $query->execute ()->fetchField ();
```
```php
# 3. Sampling of the first record
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->fields('nfd', ['nid', 'title']);
$query->condition('nfd.type', 'article');
$result = $query->execute()->fetchAssoc ();
```
```php
#  4. Selection of the first column as a simple array
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->addField('nfd', 'title');
$query->condition('nfd.type', 'article');
$result = $query->execute()->fetchCol ();
```
```php
#  5. Combining the tables in the sample
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->addField('nfd', 'title');
$query->addField('ufd', 'name');
$query->join ('users_field_data', 'ufd', 'ufd.uid = nfd.uid');
$query->condition('nfd.type', 'article');
$result = $query->execute()->fetchAll ();
```
```php
#  6.Selecting a certain range of records
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->fields('nfd', ['nid', 'title']);
$query->condition('nfd.type', 'article');
$query->range (0, 10);
$result = $query->execute()->fetchAll ();
```
```php
# 7. Using the OR conditions in the sample
$condition_or = new \ Drupal \ Core \ Database \ Query \ Condition('OR');
$condition_or->condition('nfd.nid', 5);
$condition_or->condition('nfd.nid', 7);
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->fields('nfd', ['nid', 'title']);
$query->condition($ condition_or);
$result = $query->execute()->fetchAll ();
```
```php
#  8. Counting the number of records in the sample
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->fields('nfd', ['nid', 'title']);
$query->condition('nfd.type', 'article');
$result = $query->countQuery ()->execute()->fetchField ();
```
```php
# 9. Checking values for NULL
$query = \ Drupal :: database ()->select ('example', 'e');
$query->fields('e');
$query->isNull ('e.field_null');
$query->isNotNull ('e.field_not_null');
$result = $query->execute()->fetchAll ();
```
```php
# 10. Application of complex expressions in the sample
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->fields('nfd', ['nid', 'title']);
$query->addExpression ("DATE_FORMAT (FROM_UNIXTIME (nfd.created), '% e% b%
Y')", 'node_created');
$result = $query->execute()->fetchAll ();
```
```php
#  11. Grouping of sampling records
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->addField('nfd', 'type');
$query->addExpression ('COUNT (*)', 'count');
$query->groupBy ('nfd.type');
$result = $query->execute()->fetchAll ();
```
```php
#  12. Applying complex conditions in a query
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->fields('nfd', ['nid', 'title', 'type']);
$query->where ('DAY (FROM_UNIXTIME (nfd.created)) =: day', [': day' => 7]);
$result = $query->execute()->fetchAll ();
```
```php
# 13. Sort selected records
$query = \ Drupal :: database ()->select ('node_field_data', 'nfd');
$query->fields('nfd', ['nid', 'title', 'type']);
$query->orderBy ('nfd.title');
$result = $query->execute()->fetchAll ();
```
```php

• Update records

$query = \ Drupal :: database ()->update ('example');
$query->fields([
'field_1' => $ value_1,
'field_2' => $ value_2,
'field_3' => $ value_3,
]);
$query->condition('field_4', $ value_4);
$query->execute `();
```
```php
• Using complex expressions when updating

$query = \ Drupal :: database ()->update ('example');
$query->expression ('field_1', 'field_1 +: amount', [': amount' => 100]);
$query->expression ('field_3', 'field_2');
$query->execute();
```
```php
• Adding one record
$query = \ Drupal :: database ()->insert ('example');
$query->fields([
'field_1' => $ value_1,
'field_2' => $ value_2,
'field_3' => $ value_3,
]);
$query->execute();
```
```php
• Adding multiple entries
$values = [
[$value_1, $value_2, $value_3],
[$value_4, $value_5, $value_6],
[$value_7, $value_8, $value_9],
];
$query = \ Drupal :: database ()->insert ('example');
$query->fields(['field_1', 'field_2', 'field_3']);
foreach ($values as $record) {
$query->values($record);
}
$query->execute();
```
```php
• Add or update depending on the availability of the record
$query = \ Drupal :: database ()->upsert ('example');
$query->fields(['field_id', 'field_1']);
$query->values ([$ id, $value_1]);
$query->key ('field_id');
$query->execute();
```
```php
• Delete
$query = \ Drupal :: database ()->delete ('example');
$query->condition('field', $value);
$query->execute();


```


## Setting allow Drupal upload javascript file and other extension
```
// settings.php

$config['system.file']['allow_insecure_uploads'] = TRUE;

```

## cURL error 60: SSL certificate problem
```
Download: http://curl.haxx.se/ca/cacert.pem 
Save it in a: "cacert.pem"
Edit php.ini
curl.cainfo = "[pathtothisfile]\cacert.pem"

```


## Route nolink
```
route:<nolink>
```

## Get view route name
https://www.computerminds.co.uk/drupal-code/drupal-8-views-how-formulate-route-name

```
view.$view_id.$display_id
```


## Library working with CSV
```
https://csv.thephpleague.com/

// Read CSV to array
https://csv.thephpleague.com/8.0/reading/

// Insert data to CSV
https://csv.thephpleague.com/8.0/inserting/

```

## Drupal textarea no wrap text
```php
    $form['textarea_name'] = [
      '#title' => $this->t('Textarea Title'),
      '#type' => 'textarea',
      '#attributes' => ['style' => ['white-space:nowrap']],
    ];

```

## Config entity and translate config
```php
https://www.drupal.org/node/1905070
```

## Drupal Entity API cheat sheet
```php
// https://www.metaltoad.com/blog/drupal-8-entity-api-cheat-sheet
// Load a node by NID:
$nid = 123;     // example value
$node_storage = \Drupal::entityTypeManager()->getStorage('node');
$node = $node_storage->load($nid);

// Get a built-in field value:
echo $node->get('title')->value;           // "Lorem Ipsum..."
echo $node->get('created')->value;         // 1510948801
echo $node->get('body')->value;            // "The full node body, <strong>with HTML</strong>"
echo $node->get('body')->summary;          // "This is the summary"
// a custom text field
echo $node->get('field_foo')->value;       // "whatever is in your custom field"
// a file field
echo $node->get('field_image')->target_id; // 432 (a managed file FID)

echo $node->title->value;            // "Lorem Ipsum..."
echo $node->created->value;          // 1510948801
echo $node->body->value;             // "This is the full node body, <strong>with HTML</strong>"
echo $node->body->summary;           // "This is the summary"
echo $node->field_foo->value;        // "whatever is in your custom field"
echo $node->field_image->target_id;  // 432

// Paragraphs
$my_paragraph = null;
 
foreach ($node->get('field_paragraph_reference') as $para) {
  if ($para->entity->getType() == 'your_paragraph_type') {   // e.g., "main_content" or "social_media"
    $my_paragraph = $para->entity;
  }
}
 
if (!empty($my_paragraph)) {
  // $my_paragraph is a regular entity and can be interacted with like any other entity
  echo $my_paragraph->field_somefield->value;
 
  // (however, they don't have a "title" like a node)
  echo $my_paragraph->title->value;  // <-- this won't work
} else {
  echo "The node doesn't have this paragraph type.";
}

// Working with File entities
$fid = 42;      // example value
$file_storage = \Drupal::entityTypeManager()->getStorage('file');
$file = $file_storage->load($fid);

echo $file->getFileUri();   // "public://file123.jpg"
// if you want the URL without Drupal's custom scheme, you can translate it to a plain URL:
echo file_url_transform_relative(file_create_url($file->getFileUri()));   // "/sites/default/files/public/file123.jpg"
echo $file->filename->value;   // "file123.jpg"
echo $file->filemime->value;   // "image/jpeg"
echo $file->filesize->value;   // 63518  (size in bytes)
echo $file->created->value;    // 1511206249  (Unix timestamp)
echo $file->changed->value;    // 1511234256  (Unix timestamp)
echo $file->id();              // 432

// The file's user data
echo $file->uid->target_id;               // 1
echo $file->uid->value;                   // <-- doesn't work. Use target_id instead.
echo $file->uid->entity->name->value;     // "alice"
echo $file->uid->entity->timezone->value; // "America/Los_Angeles"

// Working with Entity References
foreach ($node->field_my_entity_reference as $reference) {
 
  // if you chose "Entity ID" as the display mode for the entity reference field,
  // the target_id is the ONLY value you will have access to
  echo $reference->target_id;    // 1 (a node's nid)
 
  // if you chose "Rendered Entity" as the display mode, you'll be able to 
  // access the rest of the node's data.
  echo $reference->entity->title->value;    // "Moby Dick"
 
}
// Populate the value of an entity reference field which allows multiple values (this replaces any existing value in the DB)
$nids = [3,4,5,6];   // example value
$node->set('field_my_entity_reference', $nids);
$node->save();

// Append new referenced items to an entity reference field (this preserves existing values)
$nids = [3,4,5,6];   // example value
foreach ($nids as $nid) {
  $node->field_my_entity_reference[] = [
    'target_id' => $nid
  ];
}
$node->save();

```


## Drupal queue 
```php
https://www.sitepoint.com/drupal-8-queue-api-powerful-manual-and-cron-queueing/
```

## Javascript get url query params
```php
$.urlParam = function (name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)')
                      .exec(window.location.search);

    return (results !== null) ? results[1] || 0 : false;
}

console.log($.urlParam('ref')); //registration
console.log($.urlParam('email')); //bobo@example.com

```


## List all block and id
```php
drush ev "print_r(array_keys(\Drupal::service('plugin.manager.block')->getDefinitions()));"
```


## Validator for checking the field depending on the value of another field
```php
https://makedrupaleasy.com/articles/drupal-8-custom-validator-checking-field-depending-value-another-field
```

## Drupal theme Views Exposed Filters form

```php
https://makedrupaleasy.com/articles/drupal-8-make-beautiful-views-exposed-filters-form-custom-twig-template-and-bootstrap
```

## Drupal theme form

Example for create theme for form id **'my_awesome_form'** with module/theme **example**

```php
function example_theme() {
  return [
    'my_awesome_form' => [
      'render element' => 'form',
    ],
  ];
}
```

Create template templates/**my-awesome-form**.html.twig in example module

```php
{{ form.form_build_id }} # alway require
{{ form.form_token }} # alway require
{{ form.form_id }} # alway require

<div class="row">
  <div class="col-md-6">
    {{ form.name }}
  </div>
  <div class="col-md-6">
    {{ form.address }}
  </div>
</div>
```

### Tips
Render form element without div wrapper

```php
{{ form.name|without('#theme') }}
{{ form.name|without('#theme_wrappers') }}
```

Replace string or class of element
```php
{% set form_name = form.name|render %}
{{ form_name|replace({'old_class':'new_class'})|raw }}
```



## Drupal common entity route 

### Node Route

| Links Key | Route Name | Route Example URI | Code Example |
| --- | --- | --- | --- |
| canonical | entity.node.canonical | /node/1 | Url::fromRoute('entity.node.canonical') |
| add-page | entity.node.add_page | /node/add | Url::fromRoute('entity.node.add_page') |
| add-form | entity.node.add | /node/add/article | Url::fromRoute('entity.node.add', ['node_type' => 'article']) |
| delete-form | entity.node.delete_form | /node/1/delete | Url::fromRoute('entity.node.delete_form', ['node' => $nid]) |
| collection | entity.node.collection | /admin/content | Url::fromRoute('entity.node.collection') |
| latest_version | entity.node.latest_version | /node/1/latest | Url::fromRoute('entity.node.latest_version', ['node' => $nid]) |
| revision | entity.node.revision | /node/1/revisions/2/view | Url::fromRoute('entity.node.revision', ['node' => $nid, 'node_revision' => 2]) |
| list revisions | entity.node.version_history | /node/1/revisions | Url::fromRoute('entity.node.version_history', ['node' => $nid]) |
| node preview | entity.node.preview | /node/preview/uuid/full | Url::fromRoute('entity.node.preview', ['node_preview' => $uuid, 'view_mode_id' => 'full']) |



## Drupal create link with target blank
```php
// Use route
$options = ['absolute' => TRUE, 'attributes' => ['target' => '_blank']];
$link_object = Drupal\Core\Link::createFromRoute(t('the general terms and conditions of business'),
    'entity.node.canonical', ['node' => "123"],
    $options);
$link = $link_object->toString();

// Use url
$options = ['absolute' => TRUE, 'attributes' => ['target' => '_blank']];
$link_object = Link::fromTextAndUrl('Detail', Url::fromUserInput('/node', $options));
$link = $link_object->toString();

```

## Drupal logger object as array
```php
   \Drupal::logger('module_name')->notice('<pre><code>' . print_r($array_to_print, TRUE) . '</code></pre>'    );
```

## Drupal form ajax command
```
https://www.drupal.org/docs/8/api/javascript-api/ajax-forms
https://www.drupal.org/docs/8/api/ajax-api/core-ajax-callback-commands
https://www.drupalexp.com/blog/creating-ajax-callback-commands-drupal-8
```

## Override service class
```
https://kevinquillen.com/overriding-services-drupal-8-serviceprovidebase
https://www.bounteous.com/insights/2017/04/19/drupal-how-override-core-drupal-8-service/
```

## Theme suggestions
```
https://sqndr.github.io/d8-theming-guide/theme-hooks-and-theme-hook-suggestions/theme-hook-suggestions.html
```

## Theme preprocess
```
https://developpeur-drupal.com/en/article/theme-preprocess-and-suggestions-drupal-8-bootstrap-sub-theme
```

## Twig function for Drupal 8
https://danielmg.org/php/twig-cheatsheet.html
https://www.drupal.org/docs/8/theming/twig/functions-in-twig-templates
https://www.drupal.org/docs/8/modules/twig-tweak/cheat-sheet

```php
# Base Syntax
Output: {{ … }}
Base tag: {% … %}
Comments: {# … #}
Array: ['hello', 'world', 3]
Hash: {'name': 'Tyrion', 'age': 5}

# Setting Variables

Sets a variable value: {% set name = 'Tyrion' %}

Append or merge Strings or arrays:
{% set foo = 'Hello ' ~ name %}
{% set foo = foo|merge(bar) %}

Setting a default vale if foo is not previously defined
{% set foo = foo|default('var is not defined') %}

# Including other Templates

Simple include:

{% include '@architect/includes/header.html.twig' %}
# architect is theme name

Inlcude with custom vars:
{% set headerVars = {'title': 'Homepage'} %}
{% include '@architect/includes/header.html.twig' with headerVars %}


# Macros

{# _macros.twig #}
{% macro foo(var) %}
    Foo and {{ var }}
{% endmacro %}

If you've defined the macros in the same file, you need to import them, using _self: {% import _self as macro %}

{# mytemplate.twig #}
{% import '_macros.twig' as m %}
{{ m.foo('bar') }}

# Simple "If/Else" control
{% if kenny.sick %}
    Kenny is sick.
{% elseif kenny.dead %}
    You killed Kenny! You bastard!!!
{% else %}
    Kenny looks okay --- so far
{% endif %}

# Simple "For" control

{% for u in users %}
    
    {{ u.name }}
{% else %}
    No active users.
{% endfor %}

With a conditional:
{% for u in users if u.active %}

With a filter:
{% for u in users|sort('name') %}

Get current url
{{ url('<current>') }}

Get url as array
{% set url_arr = url('<current>')|render|split('/') %}

Get current theme path
{% set theme_path = active_theme_path() %}

Get current theme name
{% set theme_name = active_theme() %}

```

### Twig batch for array chunk
```php
{% set items = ['a', 'b', 'c', 'd', 'e', 'f', 'g'] %}

<table>
{% for row in items|batch(3, 'No item') %}
    <tr>
        {% for column in row %}
            <td>{{ column }}</td>
        {% endfor %}
    </tr>
{% endfor %}
</table>
```
The above example will be rendered as:
```php
<table>
    <tr>
        <td>a</td>
        <td>b</td>
        <td>c</td>
    </tr>
    <tr>
        <td>d</td>
        <td>e</td>
        <td>f</td>
    </tr>
    <tr>
        <td>g</td>
        <td>No item</td>
        <td>No item</td>
    </tr>
</table>
```

### Twig column
```php
{% set items = [{ 'fruit' : 'apple'}, {'fruit' : 'orange' }] %}

{% set fruits = items|column('fruit') %}

{# fruits now contains ['apple', 'orange'] #}
```



## Check request is admin route
```php
if (\Drupal::service('router.admin_context')->isAdminRoute()) {
 // do stuff
}

```
Reference: https://drupal.stackexchange.com/a/219371/1542


## List Drupal 8 form api elements
```php
https://api.drupal.org/api/drupal/elements/8.7.x
https://drupalize.me/tutorial/form-element-reference?p=2766
```

## Add ajax for reset button in exposed filter views
```php
/**
 * Implements hook_form_BASE_FORM_ID_alter().
 */
function MODULE_form_views_exposed_form_alter(&$form, FormStateInterface $form_state, $form_id) {
  $storge = $form_state->getStorage();
  if (!empty($storge['view']) && $storge['view']->id() === 'my_view') {
    if (isset($form['actions']['reset']) && isset($form['actions']['submit'])) {
      $submit_id = $form['actions']['submit']['#id'];
      $form['actions']['reset']['#attributes']['onclick'] = 'javascript:jQuery(this.form).clearForm();jQuery("#' . $submit_id . '").trigger("click");return false;';
    }
  }
}

```
## Use Drupal Ajax Command with javascript 
```js
var ajax = new Drupal.Ajax(false, false, {
  url: Drupal.url('path/to/controller')
});
ajax.execute().done(function () {
  alert('Done');
});
```

## Letencrypt
```php
https://gist.github.com/flashvnn/82f8707b141b6adfee998d9588fac927
```

## Drupal 8 install offline with other language
```php
https://drupal.stackexchange.com/questions/164172/problem-installing-in-local-the-translation-server-is-offline
Copy translate file to folder sites/default/files/translations
```

## File with Drupal 8

```php
// Move file entity.
$file = \Drupal\file\Entity\File::load($fid);
file_move(FileInterface $source, 'public://newlocation/demo.jpg');

```

## Edit Drupal config
```php
  $config_factory = \Drupal::configFactory();
  $langcode = $config_factory->get('system.site')->get('langcode');
  $config_factory->getEditable('system.site')->set('default_langcode', $langcode)->save();
```

## Check entity bundle has translated
```php
  if(!\Drupal::has('content_translation.manager')){
    return false;
  }
  $content_translation_manager = \Drupal::service('content_translation.manager');
  $compatible = $content_translation_manager->isEnabled('node', 'general');
```


## Get list field of bundle
```php
$entityManager = \Drupal::service('entity_field.manager');
$fields= $entityManager->getFieldDefinitions($entity_type, $bundle);
```

## Get entity bundle of entity type
```php
  /**
   * Get entity bundle options.
   *
   * @param $entity_type_id
   *   The entity type identifier.
   *
   * @return array
   *   An array of entity bundle options.
   */
  protected function getEntityBundleOptions($entity_type_id) {
    $options = [];

    foreach ($this->entityTypeBundleInfo->getBundleInfo($entity_type_id) as $name => $definition) {
      if (!isset($definition['label'])) {
        continue;
      }
      $options[$name] = $definition['label'];
    }

    return $options;
  }
```


## Set default value for view filter
```php
/**
 * Implements hook_form_BASE_FORM_ID_alter().
 */
function MODULE_form_views_exposed_form_alter(&$form, FormStateInterface $form_state, $form_id) {
  $storge = $form_state->getStorage();
  if ($storge['view']->id() === 'view_news') {
    if (isset($form['changed_date_select']['#options']) && count($form['changed_date_select']['#options']) > 1) {
      if (isset($form['changed_date_select']['#options']['All'])) {
        $user_input = $form_state->getUserInput();
        if (isset($user_input['changed_date_select']) && $user_input['changed_date_select'] === 'All') {
          next($form['changed_date_select']['#options']);
          $key = key($form['changed_date_select']['#options']);
          $form['changed_date_select']['#default_value'] = $key;
          $user_input['changed_date_select'] = $key;
          $form_state->setUserInput($user_input);
        }
      }
    }
  }

}
```

## Check request is AJAX Form Request
```php
$request->query->has(static::AJAX_FORM_REQUEST))
```

### Add basic authetication for /user url
```
# Add in virtualhost config
<Location /user>
  AuthUserFile /home/path/.htpasswd
  AuthName "Password Protected Area"
  AuthType Basic
  Require valid-user
</Location>

```

## Install Acquia Dev Desktop
Install Microsoft Visual C++ 2010 Redistributable Package before run Acquia Dev Desktop
```
https://www.microsoft.com/en-us/download/details.aspx?id=14632
https://www.microsoft.com/en-us/download/details.aspx?id=5555
```

## Issue: Drupal Console PHP Fatal error:  require(): Failed opening required 'drupal.php'
Check PHP installed with ionCube, need remove it 

## Issue: Drupal console: The “--shellexec_output” option does not exist
Remove the line with shellexec_output: true from ~/.console/config.yml (probably the last line in the file).

## Install composer 

```bash
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
```

## Install drupal console global
```bash
curl https://drupalconsole.com/installer -L -o drupal.phar
mv drupal.phar /usr/local/bin/drupal
chmod +x /usr/local/bin/drupal
```

## Render array Properties
**#type, #theme, and #markup**
Almost every Render API element at any level of the render array's hierarchy will have one of these properties defined.

**#plain_text**

Specifies that the array provides text that needs to be escaped.
Example:
```
'#plain_text' => t('Hello world!')
```
