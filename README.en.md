
## Page Builder for Evolution CMS

Other languages: <a href="https://github.com/mnoskov/pagebuilder/blob/master/README.md">Russian</a>

The configuration for the blocks is taken from the config folder. To create a new block, you need to create a .php file in this folder, which should return an associative array. The structure of the array is as follows:

<table>
<tr><th>Key</th><th>Value</th></tr>
<tr><td>title</td><td>Block name visible to the manager when filling in Value</td></tr>
<tr>
<td>fields</td>
<td>
Associative array of used fields, in which the keys are field identifiers, and the values are the arrays of options for these fields.

The possible field types and options are listed below.
</td>
</tr>
<tr>
<td>templates</td>
<td>
An associative array containing the template for the "owner" key, as well as templates for each field group.

If for example the "images" group is used in the field array, then an element with the "images" key must be defined in the templates which will contain either the template string:

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

In the second case, the output of these elements in the parent template can be used as "[+images.item+]" and "[+images.thumb+]".
</td>
</tr>
</table>

#### The structure of the array for describing the field

<table>
<tr><th>Key</th><th>Value</th></tr>
<tr><td>caption</td><td>The name of the field that the manager sees</td></tr>
<tr><td>type</td><td>Type of field, see below</td></tr>
<tr><td>theme</td><td>The editor's topic for the "richtext" field, the available values can be viewed in the Evolution CMS configuration, on the "Interface" tab</td></tr>
<tr><td>options</td><td>Additional options for the "richtext" field, values can be viewed <a href="https://www.tinymce.com/docs/configure/" target="_blank">here</a></td></tr>
<tr><td>fields</td><td>Nested fields, for type "group"</td></tr>
</table>

#### Field types

<table>
<tr><th>Value</th><th>Description</th></tr>
<tr><td>text</td><td>Text single line field</td></tr>
<tr><td>image</td><td>Text field with thumbnail and button for image selection</td></tr>
<tr><td>richtext</td><td>Text editor TinyMCE 4</td></tr>
<tr><td>group</td><td>Field group, it is necessary to specify nested fields in the key "fields" Text editor</td></tr>
</table>

#### Configuration examples

Examples of configuration can be found <a href="https://github.com/mnoskov/pagebuilder/tree/master/assets/plugins/pagebuilder/config" target="_blank">here</a>
