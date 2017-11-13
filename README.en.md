## Page Builder for Evolution CMS

<img src="https://img.shields.io/badge/PHP-%3E=5.6-green.svg?php=5.6">

Other languages: <a href="https://github.com/mnoskov/pagebuilder/blob/master/README.md">Russian</a>

The plug-in allows the developer to define a set of blocks with a certain markup and a list of fields, so that the content manager uses those blocks that it considers necessary, with its content.

[![Youtube review](https://i.ytimg.com/vi/yov7y-OXubo/hqdefault.jpg)](https://youtu.be/yov7y-OXubo)

The configuration for the blocks is taken from the config folder. To create a new block, you need to create a `.php` file in this folder, which should return an associative array. To create a container, you need to create a `.php` file whose name will start with the `container.`. The structure of the array is as follows:

<table>
<tr><th>Key</th><th>Value</th></tr>
<tr><td>title</td><td>Block name visible to the manager when filling in Value</td></tr>
<tr><td>container</td><td>Name of the container (or the array of names) in which the block will be displayed.</td></tr>
<tr>
<td>fields</td>
<td>
Associative array of used fields, in which the keys are field identifiers, and the values are the arrays of options for these fields.

The possible field types and options are listed below.
</td>
</tr>
<tr><td>show_in_templates</td><td>Array of template identifiers for which editing and output of blocks are available</td></tr>
<tr><td>hide_in_docs</td><td>Array of document identifiers for which editing and output are not available</td></tr>
<tr><td>show_in_docs</td><td>An array of document identifiers for which editing and output of blocks are available.

If this parameter is specified, then "hide_in_docs" is not taken into account.

If none of the parameters restricting access is specified, the blocks will be available in all documents.</td></tr>
<tr><td>order</td><td>The sort order in the "add-block" section. This parameter does NOT affect the sorting of the blocks themselves!</td></tr>
<tr>
<td>templates</td>
<td>
An associative array containing the template for the "owner" key, as well as templates for each field group.

For a description of template creation methods, see below.
</td>
</tr>
<tr><td>icon</td><td>The icon class that will be displayed in the "add-block" section, if the plugin setting &addType is set to "icons"
  
For example, if you set the class `fa fa-cogs`, the output will be as following:
```html
<i class="fa fa-cogs"></i>
```
</td></tr>
<tr><td>image</td><td>The image that will be displayed in the "add-block" section, if the plugin setting &addType is set to "images".
  
The image will be processed with the `phpthumb` snippet with the parameter `w=80`</td></tr>
</table>

### Templating

The main template of the block must be defined for the "owner" key. In addition to this, the array must contain templates for each group of fields, and can contain templates for fields that have the "elements" property defined ("dropdown", "checkbox", "radio" fields). In these templates, the selected values for the "elements" property are available.

For example, if the "images" group is used in the field array, then an element with the "images" key must be defined in the templates which will contain either the template string:

```
'images' => '<img src="[+image+]" alt="[+title+]" class="slide">'
```

Or an associative pattern array:

```
'images' => [
  'item'  => '<img src="[+image+]" alt="[+title+]" class="slide">',
  'thumb' => '<div class="thumb" style="background-image: url([+image+])"></div>',
],
```

In the second case, the output of these elements in the parent template can be used as `[+images.item+]` and `[+images.thumb+]`.

#### Placeholders

You can use field names (eg `[+title+]`) and group field names (eg `[+images+]`, `[+images.thumb+]`) as a placeholders.

Also in templates for fields "dropdown", "checkbox" and "radio", the placeholders `[+value+]` and `[+title+]` are available.

Also the placeholders `[+index+]` and `[+iteration+]` are available in the "owner" template, and `[+{field_name}_index+]` and `[+{field_name_iteration+]` are available in the group fields and selection fields.

#### Templates sources

Markup can be specified in the configuration directly, as shown in examples above.

Also can be specified name of the chunk with th template markup. To do this, use the `@CHUNK` binding, for example:

```php
'checkbox' => '@CHUNK all_fields_checkboxes',
```

It is also possible to load a template from a file:

```php
'owner' => '@FILE pagebuilder/all_fields.tpl',
```

In this example, the template file will be loaded from `MODX_BASE_PATH . "assets/templates/pagebuilder/all_fields.tpl"`. In general, the file is searched in the following directories:

```
assets/tvs/
assets/chunks/
assets/templates/
```

Alternatively, you can specify the full path from the site root. The first slash is not specified.

#### Templates groups

Templates can be grouped to use different groups of templates with the parameter `&templates` when outputting. For example, if you specify the following configuration for a block:

```php
'templates' => [
  'owner'  => '@CHUNK full_owner',
  'images' => '@CHUNK full_images'

  'anchors' => [
    'owner' => '@CHUNK link_owner',
  ],
],
```

then next snippet call will use the templates that are defined in the `anchors` group to output:

```
[[PageBuilder? &templates=`anchors`]]
```

### Fields

#### The structure of the array for describing the field

<table>
<tr><th>Key</th><th>Value</th></tr>
<tr><td>caption</td><td>The name of the field that the manager sees</td></tr>
<tr><td>type</td><td>Type of field, see below</td></tr>
<tr><td>theme</td><td>The editor's topic for the "richtext" field, the available values can be viewed in the Evolution CMS configuration, on the "Interface" tab</td></tr>
<tr><td>options</td><td>Additional options for the "richtext" field, values can be viewed <a href="https://www.tinymce.com/docs/configure/" target="_blank">here</a></td></tr>
<tr><td>fields</td><td>Nested fields, for type "group"</td></tr>
<tr><td>height</td><td>The height of the field, with units (for example "150px"). Available for field type "textarea".

For "richtext" field type this option must be specified in the key "options"</td></tr>
<tr><td>elements</td><td>Possible values for the selection field. Available for the fields "dropdown", "radio" and "checkbox". Can be represented as an array of pairs "key" => "value", or as a string in an cms format (@SELECT and others).</td></tr>
<tr><td>layout</td><td>Layout for the fields "radio" and "checkbox". Possible values are "vertical" (default) and "horizontal"</td></tr>
<tr><td>default</td><td>Default value. For the field type "checkbox" can be an array of values. Can be in a cms format.</td></tr>
</table>

#### Field types

<table>
<tr><th>Value</th><th>Description</th></tr>
<tr><td>text</td><td>Text single line field</td></tr>
<tr><td>image</td><td>Text field with thumbnail and button for image selection</td></tr>
<tr><td>richtext</td><td>Text editor TinyMCE 4</td></tr>
<tr><td>textarea</td><td>Multiline text field</td></tr>
<tr><td>date</td><td>Text field with dropdown calendar</td></tr>
<tr><td>dropdown</td><td>Dropdown list</td></tr>
<tr><td>checkbox</td><td>Checkboxes, allows to multiselect</td></tr>
<tr><td>radio</td><td>Radio buttons</td></tr>
<tr><td>group</td><td>Field group, it is necessary to specify nested fields in the key "fields" Text editor</td></tr>
</table>

#### Configuration examples

Examples of configuration can be found <a href="https://github.com/mnoskov/pagebuilder/tree/master/assets/plugins/pagebuilder/config" target="_blank">here</a>. (For example blocks to become available for selection, you need to rename files `*.php.sample` to `*.php`)

### Snippet PageBuilder

To display the blocks, use the PageBuilder snippet with the following parameters:
<table>
<tr><th>Parameter</th><th>Default value</th><th>Possible values</th></tr>
<tr><td>docid</td><td>Current document</td><td>Identifier of any existing document, an integer</td></tr>
<tr><td>container</td><td>default</td><td>Name of the container</td></tr>
<tr><td>blocks</td><td>*</td><td>The list of blocks is separated by commas, without spaces. The name of the configuration file is taken without the extension (For example, 'all_fields, groups'). If you specify '*', the filter by name will not be applied</td></tr>
<tr><td>wrapTpl</td><td>[+wrap+]</td><td>The name of the chunk containing the wrapper template for the list of blocks of the output container</td></tr>
<tr><td>templates</td><td></td><td>The identifier of the template group to be used for output. It must be defined in the configuration of each output block</td></tr>
<tr><td>offset</td><td>0</td><td>Number of skipped blocks from the beginning of the output</td></tr>
<tr><td>limit</td><td>0</td><td>The number of blocks for output, or 0 for all</td></tr>
</table>

### Plugin PageBuilder

The plugin is displaying the form for editing blocks and has the following parameters:
<table>
<tr><th>Parameter</th><th>Default value</th><th>Possible values</th></tr>
<tr><td>tabName</td><td>Page Builder</td><td>The tab name on the resource editing page in which the form will be displayed</td></tr>
<tr><td>addType</td><td>dropdown</td><td>The "add-block" section view, can have the values "dropdown", "icons" or "images".
  
For the value of "icons" in the configuration of each block, the "icon" key containing the icon class must be defined.

For the "images" value, the "image" key must be defined, with the image address (max 80x60)</td></tr>
<tr><td>placement</td><td>tab</td><td>Placing the form: tab - in a separate tab, content - under the contents of the resource</td></tr>
</table>
