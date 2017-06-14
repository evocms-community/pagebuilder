## Content Blocks for Evolution CMS

Конфигурация для блоков берется из папки config. Для создания нового блока нужно создать в этой папке файл .php, который должен вернуть ассоциативный массив. Структура массива следующая:

<table>
<tr><th>Ключ</th><th>Значение</th></tr>
<tr><td>title</td><td>Название блока, видимое менеджеру при заполнении</td></tr>
<tr>
<td>fields</td>
<td>
Ассоциативный массив используемых полей, в котором ключами являются идентификаторы полей, а значениями - массивы опций этих полей.

Возможные типы полей и опции приведены ниже.
</td>
</tr>
<tr>
<td>templates</td>
<td>
Ассоциативный массив, содержащий шаблон для ключа "owner", а также шаблоны для каждой группы полей.

Также может содержать шаблоны для полей, для которых определено свойство "elements", это поля типа "dropdown", "checkbox", "radio". В таких шаблонах доступны выбранные значения свойства "elements".

Например, если в массиве полей используется группа "images", то в шаблонах должен быть определен элемент с ключом "images", который будет содержать либо строку шаблона:

```
'images' => '<img src="[+image+]" alt="[+title+]" class="slide">'
```

либо ассоциативный массив шаблонов:

```
'images' => [
  'item'  => '<img src="[+image+]" alt="[+title+]" class="slide">',
  'thumb' => '<div class="thumb" style="background-image: url([+image+])"></div>',
],
```

Во втором случае вывод этих элементов в родительском шаблоне можно использовать как "[+images.item+]" и "[+images.thumb+]".
</td>
</tr>
</table>

#### Структура массива для описания поля

<table>
<tr><th>Ключ</th><th>Значение</th></tr>
<tr><td>caption</td><td>Название поля, которое видит менеджер. Необязательно</td></tr>
<tr><td>type</td><td>Тип поля, см. ниже</td></tr>
<tr><td>theme</td><td>Тема редактора для поля "richtext", доступные значения можно посмотреть в конфигурации Evolution CMS, на вкладке "Интерфейс"</td></tr>
<tr><td>options</td><td>Дополнительные опции для поля "richtext", значения можно посмотреть <a href="https://www.tinymce.com/docs/configure/" target="_blank">здесь</a></td></tr>
<tr><td>fields</td><td>Вложенные поля, для типа "group"</td></tr>
<tr><td>height</td><td>Высота поля, с указанием единиц измерения, например "150px". Доступно для типов поля "richtext" и "textarea"</td></tr>
<tr><td>elements</td><td>Возможные значения для поля выбора. Доступны для полей "dropdown", "radio", "checkbox". Могут быть представлены в виде массива "ключ" => "значение", или в виде строки в доступном формате Evolution CMS (@SELECT и пр. работают).</td></tr>
<tr><td>layout</td><td>Вид расположения вариантов для полей "radio" и "checkbox". Возможные значения - "vertical" (по умолчанию) и "horizontal"</td></tr>
<tr><td>default</td><td>Значение по умолчанию. Для типа поля "checkbox" может быть массивом значений</td></tr>
</table>

#### Типы полей

<table>
<tr><th>Значение</th><th>Описание</th></tr>
<tr><td>text</td><td>Однострочное текстовое поле</td></tr>
<tr><td>image</td><td>Текстовое поле с миниатюрой и кнопкой для выбора изображения</td></tr>
<tr><td>richtext</td><td>Текстовый редактор TinyMCE 4</td></tr>
<tr><td>textarea</td><td>Многострочное текстовое поле</td></tr>
<tr><td>date</td><td>Текстовое поле с выпадающим календарем для выбора даты</td></tr>
<tr><td>dropdown</td><td>Выпадающий список</td></tr>
<tr><td>checkbox</td><td>Флажки, позволяет выбрать несколько вариантов из представленных</td></tr>
<tr><td>radio</td><td>Переключатели, позволяют выбрать только один вариант</td></tr>
<tr><td>group</td><td>Группа полей, обязательно должны быть определены вложенные поля в ключе "fields"</td></tr>
</table>

#### Примеры конфигурации

Примеры конфигурации можно найти <a href="https://github.com/sunhaim/contentblocks/tree/master/assets/plugins/contentblocks/config" target="_blank">здесь</a>


***
# ENGLISH
***


## Content Blocks for Evolution CMS

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

Examples of configuration can be found <a href="https://github.com/sunhaim/contentblocks/tree/master/assets/plugins/contentblocks/config" target="_blank">here</a>
