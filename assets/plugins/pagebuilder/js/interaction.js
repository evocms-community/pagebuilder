    var initcontentblocks = function(opts) {
        return (function($) {

            var ContentBlock = {

                initialize: function(blocks) {
                    $(blocks).each(function() {
                        var $wrap    = $(this),
                            $block   = $wrap.children('.block-inner'),
                            confName = $wrap.attr('data-config'),
                            conf     = opts.config[ confName ],
                            $list    = $block.children('.fields-list');

                        // set block type
                        $block.children('.change-type').children('select').val(confName);

                        // add button for mass upload
                        $block.find('.sortable-list').each(function() {
                            var $list    = $(this),
                                $fields  = $list.children('.sortable-item').eq(0).children('.fields-list'),
                                $buttons = $list.prev('.group-title').children('.btn-group');

                            if ($fields.children('.type-image').length) {
                                $('<input type="button" class="btn btn-secondary fill-with" data-type="image">').val(opts.lang['Fill with images']).appendTo($buttons);
                            }

                            if ($fields.children('.type-file').length) {
                                $('<input type="button" class="btn btn-secondary fill-with" data-type="file">').val(opts.lang['Fill with files']).appendTo($buttons);
                            }

                            ContentBlock.groupUpdated($(this));
                        });

                        // add controls handlers
                        (function($wrap) {
                            $block.children('.controls')
                                .on('click', '.moveup, .movedown', function(e) {
                                    e.preventDefault();
                                    ContentBlock.move($wrap, $(this).hasClass('moveup') ? 'up' : 'down');
                                })

                                .on('click', '.insert', function(e) {
                                    e.preventDefault();
                                    var config = $(this).closest('.block').attr('data-config');
                                    ContentBlock.append(config, $wrap);
                                })

                                .on('click', '.remove', function(e) {
                                    e.preventDefault();
                                    $wrap.slideUp(200, function() {
                                        $wrap.remove();
                                    });
                                });
                        })($wrap);

                        $block.on('click', '.open-browser', function(e) {
                            e.preventDefault();
                            ContentBlock.openBrowser($(this).next('input'), $(this).parent().hasClass('type-image') ? 'images' : 'files');
                        });

                        $block.on('click', '.preview', function(e) {
                            var $self = $(this);

                            if ($self.closest('.sortable-list').hasClass('gallery-layout')) {
                                $self.next('.btn').click();
                            }
                        });

                        $block.on('click', '.sortable-item > .controls > .insert', function(e) {
                            e.preventDefault();
                            e.stopPropagation();
                            ContentBlock.insertItem($(this).closest('.sortable-item'));
                        });

                        $block.on('click', '.sortable-item > .controls > .remove', function(e) {
                            e.preventDefault();
                            e.stopPropagation();

                            $(this).closest('.sortable-item').slideUp(200, function() {
                                var $self = $(this),
                                    $list = $self.parent();

                                $self.remove();
                                ContentBlock.groupUpdated($list);
                            });
                        });

                        $block.on('change', '> .change-type select', function(e) {
                            ContentBlock.changeType($(this).closest('.block'), $(this).val());
                        });

                        $block.on('click', '.fill-with', function(e) {
                            e.preventDefault();
                            var $list = $(this).closest('.group-title').next('.sortable-list'),
                                type  = $(this).attr('data-type');

                            (function($list, type) {
                                ContentBlock.openBrowser($list, type + 's', function(files) {
                                    var $item = $list.children(':last-child');

                                    for (var i = 0; i < files.length; i++) {
                                        $item = ContentBlock.insertItem($item);

                                        var $input = $item.children('.fields-list').children('.type-' + type).eq(0).children('input[type="text"]');
                                        $input.val(files[i]);

                                        if (type == 'image') {
                                            ContentBlock.setThumb($input.parent());
                                        }
                                    }

                                    ContentBlock.groupUpdated($list);
                                });
                            })($list, type);
                        });

                        ContentBlock.initializeFieldsList(conf.fields, $list);
                    });
                },

                fetch: function($block, oldValues) {
                    if ($block.hasClass('block')) {
                        $block = $block.children('.block-inner');
                    }

                    var values = oldValues || {},
                        $list  = $block.children('.fields-list'),
                        conf   = $list.data('fields');

                    for (var field in conf) {
                        var $field = $list.children('.field[data-field="' + field + '"]'),
                            fieldConfig = conf[field];

                        switch (conf[field].type) {
                            case 'richtext': {
                                var f = $field.children('textarea').get(0);

                                if (typeof tinymce != 'undefined' && f.id && tinymce.editors[f.id]) {
                                    values[field] = tinymce.editors[f.id].getContent();
                                } else {
                                    values[field] = $(f).val();
                                }

                                break;
                            }

                            case 'group': {
                                if (typeof values[field] != 'object') {
                                    values[field] = [];
                                }

                                $field.children('.sortable-list').children('.sortable-item:not(.hidden)').each(function(i) {
                                    values[field][i] = ContentBlock.fetch($(this));
                                });

                                break;
                            }

                            case 'imagecheckbox':
                            case 'checkbox': {
                                if (typeof values[field] != 'object') {
                                    values[field] = {};
                                }

                                $field.children('.check-list').children('.check-row').each(function(i) {
                                    var $input = $(this).children('label').children(':checked');

                                    if ($input.length) {
                                        values[field][i] = $input.val();
                                    }
                                });

                                break;
                            }

                            case 'imageradio':
                            case 'radio': {
                                var $input = $field.children('.check-list').children('.check-row').children('label').children(':checked');

                                if ($input.length) {
                                    values[field] = $input.val();
                                }

                                break;
                            }

                            default: {
                                values[field] = $field.children('input[type="text"], textarea, select').val();
                            }
                        }
                    }

                    return values;
                },

                setValues: function(conf, $list, values) {
                    for (var field in conf) {
                        var $field = $list.children('.field[data-field="' + field + '"]');

                        switch (conf[field].type) {
                            case 'group': {
                                if (typeof values[field] === 'object' && values[field].length) {
                                    var $sortable = $field.children('.sortable-list'),
                                        $element  = $sortable.children('.sortable-item.hidden');

                                    for (var i = 0; i < values[field].length; i++) {
                                        var $clone = ContentBlock.createSortableItem($sortable);

                                        $clone.appendTo($sortable).show();

                                        ContentBlock.groupUpdated($sortable);
                                        ContentBlock.setValues(conf[field].fields, $clone.children('.fields-list'), values[field][i]);
                                    }
                                }

                                break;
                            }

                            case 'imagecheckbox':
                            case 'checkbox': {
                                if (typeof values[field] !== 'undefined') {
                                    if (typeof values[field] != 'object') {
                                        values[field] = { 0: values[field] };
                                    }

                                    var $inputs = $field.children('.check-list').children('.check-row').children('label').children('input').removeAttr('checked');

                                    for (var i in values[field]) {
                                        var $input = $inputs.filter('[value="' + values[field][i] + '"]');

                                        if ($input.length) {
                                            $input.get(0).checked = true;
                                        }
                                    }
                                }

                                break;
                            }

                            case 'imageradio':
                            case 'radio': {
                                if (typeof values[field] !== 'undefined' && typeof values[field] != 'object') {
                                    var $input = $field.children('.check-list').children('.check-row').children('label').children('[value="' + values[field] + '"]');

                                    if ($input.length) {
                                        $input.get(0).checked = true;
                                    }
                                }

                                break;
                            }

                            default: {
                                if (typeof values[field] !== 'undefined' && typeof values[field] != 'object') {
                                    $field.children('input[type="text"], textarea, select').val(values[field]);

                                    if (conf[field].type == 'image') {
                                        ContentBlock.setThumb($field);
                                    }
                                }
                            }
                        }
                    }
                },

                setThumb: function($field) {
                    var source   = $.trim($field.children('input[type="text"]').val()),
                        $preview = $field.children('.preview'),
                        thumb    = source;

                    if (thumb.match(/\.svg$/)) {
                        thumb = '../' + thumb;
                    } else {
                        thumb = thumb.replace('assets', '../assets');
                        thumb = thumb.replace('/images/', '/' + opts.thumbsDir + '/images/');
                    }

                    if (source == '') {
                        $field.removeClass('with-thumb');
                        $field.children('.preview').removeAttr('style');
                    } else {
                        $field.addClass('with-thumb');

                        if (document.images) {
                            var image = new Image();

                            (function(source, thumb, $preview) {
                                image.onload = function() {
                                    if (this.width + this.height == 0) {
                                        return this.onerror();
                                    }

                                    $preview.css('background-image', 'url("' + thumb + '")');
                                }

                                image.onerror = function() {
                                    if (this.thumbChecked == undefined) {
                                        this.thumbChecked = true;
                                        this.src = source.replace('assets', '../assets');
                                    } else {
                                        $preview.css('background-image', 'url("../assets/images/noimage.jpg")');
                                    }
                                }
                            })(source, thumb, $preview);

                            image.src = thumb;
                        } else {
                            $preview.css('background-image', 'url("' + thumb + '")');
                        }
                    }
                },

                changeType: function($block, type) {
                    var values    = this.fetch($block, $block.data('values')),
                        formid    = $block.closest('.content-blocks').attr('data-formid'),
                        $newblock = $('.content-blocks-configs[data-formid="' + formid + '"]').children('[data-config="' + type + '"]').eq(0);

                    if ($newblock.length) {
                        $newblock = $newblock.clone().data('values', values);
                        $newblock.append($block.children('.add-block'));
                        $newblock.children('.block-inner').children('.change-type').replaceWith($block.children('.block-inner').children('.change-type'));
                        $block.replaceWith($newblock);

                        ContentBlock.setValues(opts.config[type].fields, $newblock.children('.block-inner').children('.fields-list'), values);
                        ContentBlock.initialize($newblock);
                    }
                },

                append: function(config, $after) {
                    var formid = $after.closest('.content-blocks').attr('data-formid'),
                        $block = $('.content-blocks-configs[data-formid="' + formid + '"]').children('[data-config="' + config + '"]').eq(0);

                    if ($block.length) {
                        $block = $block.clone();

                        // removing blocks from type-selector that not belongs to this container
                        var $configs = $after.closest('.content-blocks').children('.change-type').children('select').clone().show();
                        $block.children('.block-inner').children('.change-type').children('select').replaceWith($configs);

                        // adding add-block-section to the bottom of block
                        var $add = $after.closest('.content-blocks').children('.add-block').clone();
                        $add.removeClass('show');
                        $add.children('.add-block-icons').removeAttr('style');
                        $block.append($add);

                        $block.find('.type-radio, .type-imageradio').each(function() {
                            $(this).find('[type="radio"]').attr('name', 'contentblocks_radio_' + ContentBlock.randomString());
                        });

                        $block.hide().insertAfter($after).slideDown(200, function() {
                            $(this).removeAttr('style');
                        });

                        ContentBlock.initialize($block);

                        return $block;
                    }
                },

                move: function($block, direction) {
                    var $sibling;

                    if (direction == 'up') {
                        $sibling = $block.prev('.block');

                        if (!$sibling.length) {
                            return;
                        }
                    } else {
                        $sibling = $block.next('.block');

                        if ($sibling.length) {
                            $block.insertAfter($sibling);
                        }
                    }

                    var $rich = $block.find('textarea.richtext');

                    $rich.each(function() {
                        if (typeof tinymce != 'undefined' && this.id && tinymce.editors[this.id]) {
                            tinymce.editors[this.id].destroy();
                        }
                    });

                    if (direction == 'up') {
                        $block.insertBefore($sibling);
                    } else {
                        $block.insertAfter($sibling);
                    }

                    $rich.each(function() {
                        ContentBlock.initializeRichField($(this));
                    });
                },

                createSortableItem: function($list) {
                    var $clone = $list.children('.hidden').eq(0).clone(true);

                    $clone.removeClass('hidden').hide();
                    $clone.children('.fields-list').removeClass('hidden');

                    $clone.children('.fields-list').children('.type-radio, .type-imageradio').each(function() {
                        $(this).find('[type="radio"]').attr('name', 'contentblocks_radio_' + ContentBlock.randomString());
                    });

                    return $clone;
                },

                insertItem: function($after) {
                    var $list  = $after.parent(),
                        $clone = ContentBlock.createSortableItem($list);

                    $clone.insertAfter($after);

                    if ($after.hasClass('hidden')) {
                        ContentBlock.initializeSortableList($list);
                    }

                    ContentBlock.groupUpdated($list);
                    ContentBlock.initializeFieldsList($after.children('.fields-list').data('fields'), $clone.children('.fields-list'));

                    $clone.slideDown(200);

                    return $clone;
                },

                initializeFieldsList: function(conf, $list) {
                    $list.data('fields', conf);

                    for (var field in conf) {
                        var $field = $list.children('.field[data-field="' + field + '"]'),
                            fieldConfig = conf[field];

                        switch (fieldConfig.type) {
                            case 'richtext': {
                                var $textarea = $field.children('textarea');

                                if (fieldConfig.options) {
                                    $textarea.data('options', fieldConfig.options);
                                }

                                if (fieldConfig.theme) {
                                    $textarea.data('theme', fieldConfig.theme);
                                }

                                ContentBlock.initializeRichField($textarea);

                                break;
                            }

                            case 'image':
                            case 'files': 
                            {
                                var $input = $field.children('input[type="text"]');
                                $input.attr('id', 'fm' + ContentBlock.randomString() + ContentBlock.randomString());
                                $input.on('input change', function() {
                                    if (this.value != '') {
                                        ContentBlock.setThumb($(this).parent());
                                    }
                                });

                                ContentBlock.setThumb($field);
                                break;
                            }

                            case 'date': {
                                var $input = $field.children('input');
                                $input.data('picker', new DatePicker($input.get(0), opts.picker));
                                break;
                            }

                            case 'group': {
                                var $sortable = $field.children('.sortable-list');

                                $sortable.children('.sortable-item').each(function() {
                                    ContentBlock.initializeFieldsList(conf[field].fields, $(this).children('.fields-list'));
                                });

                                if (!$list.parent().hasClass('hidden')) {
                                    ContentBlock.initializeSortableList($sortable);
                                }

                                break;
                            }
                        }
                    }
                },

                initializeSortableList: function($sortable) {
                    var axis = $sortable.hasClass('gallery-layout') ? '' : 'y';

                    $sortable.sortable({
                        axis:  axis,
                        items: '> .sortable-item:not(.hidden)',
                        handle: '> .handle',
                        start: function(e, ui) {
                            ui.item.find('textarea.richtext').each(function() {
                                if (typeof tinymce != 'undefined' && this.id && tinymce.editors[this.id]) {
                                    tinymce.editors[this.id].save();
                                }
                            });
                        },
                        stop: function(e, ui) {
                            ui.item.find('textarea.richtext').each(function() {
                                if (typeof tinymce != 'undefined' && this.id && tinymce.editors[this.id]) {
                                    tinymce.editors[this.id].destroy();
                                }
                                ContentBlock.initializeRichField($(this));
                            });
                        }
                    });

                    ContentBlock.groupUpdated($sortable);
                },

                initializeRichField: function($textarea) {
                    if ($textarea.closest('.hidden').length) {
                        return;
                    }

                    var theme   = $textarea.data('theme'),
                        options = $textarea.data('options');

                    $textarea.get(0).id = 'rich' + ContentBlock.randomString();

                    if (typeof tinymce !== 'undefined') {
                        var conf = theme != undefined ? window['config_tinymce4_' + theme] : window[ modxRTEbridge_tinymce4.default ];
                        conf = $.extend({}, conf, options ? options : {});

                        conf.selector = '#' + $textarea.attr('id');
                        tinymce.init(conf);
                    }
                },

                openBrowser: function($element, type, multipleCallback) {
                    var wnd    = window.parent || window,
                        margin = parseInt(wnd.innerHeight * 0.1),
                        width  = wnd.innerWidth - margin * 2,
                        height = wnd.innerHeight - margin * 2,
                        params = 'toolbar=no,status=no,resizable=yes,dependent=yes,width=' + width + ',height=' + height + ',left=' + margin + ',top=' + (margin + (wnd._startY ? wnd._startY * 0.5 : 0));

                    if (window.SetUrl) {
                        window.SetUrl_disabled = window.SetUrl;
                        window.SetUrl = null;
                    }

                    window.KCFinder = {
                        callBack: function(url) {
                            if (window.SetUrl_disabled) {
                                window.SetUrl = window.SetUrl_disabled;
                            }

                            window.KCFinder = null;

                            $element.val(url);

                            if (type == 'images') {
                                ContentBlock.setThumb($element.parent());
                            }
                        }
                    };

                    if (multipleCallback !== undefined) {
                        window.KCFinder.callBackMultiple = window.KCFinder.callBack = function(files) {
                            if (typeof files !== 'object') {
                                files = [ files ];
                            }

                            if (window.SetUrl_disabled) {
                                window.SetUrl = window.SetUrl_disabled;
                            }

                            window.KCFinder = null;
                            multipleCallback(files);
                        };
                    }

                    window.open(opts.browser + '?type=' + type + '&field_id=' + $element[0].id + '&popup=1&relative_url=1', 'FileManager', params);
                },

                groupUpdated: function($list) {
                    var $btn  = $list.prev('.group-title').children('.btn-group').children('.btn.toggle-group'),
                        count = $list.children(':not(.hidden)').length;

                    $btn.toggle(count > 0);

                    if ($list.hasClass('collapsed')) {
                        $btn.text(opts.lang['Show group items'].replace('%s', count));
                    } else {
                        $btn.text(opts.lang['Hide group items'].replace('%s', count));
                    }
                },

                randomString: function() {
                    return (((1 + Math.random()) * 0x100000) | 0).toString(16);
                }

            };

            opts.containers.each(function() {
                var $container = $(this);

                ContentBlock.initialize($container.children('.block'));

                if ($container.hasClass('single')) {
                    $container.on('click', '.dropdown-add-block, .add-block .trigger a', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        e.stopImmediatePropagation();

                        var config;

                        if ($(this).hasClass('dropdown-add-block')) {
                            config = $(this).prev('select').children().last().val();
                        } else {
                            config = $(this).parent().next('.add-block-icons').find('a').attr('data-config');

                        }

                        var $current = $(this).closest('.block');

                        if (!$current.length) {
                            $current = $(this).closest('.add-block');
                        }

                        ContentBlock.append(config, $current);
                    });
                }

                $container.on('click', '.dropdown-add-block', function(e) {
                    e.preventDefault();
                    var config = $(this).prev('select').val();

                    if (config != '') {
                        var $current = $(this).closest('.block');

                        if (!$current.length) {
                            $current = $(this).closest('.add-block');
                        }

                        ContentBlock.append(config, $current);
                    }
                });

                $container.on('click', '.add-block .trigger a', function(e) {
                    e.preventDefault();
                    $(this).closest('.add-block').toggleClass('show').children('.add-block-icons').slideToggle(200);
                });

                $container.on('click', '.add-block-icons a', function(e) {
                    e.preventDefault();

                    $(this).closest('.add-block-icons').prev('.trigger').children('a').click();

                    var config = $(this).attr('data-config');

                    if (config != '') {
                        var $current = $(this).closest('.block');

                        if (!$current.length) {
                            $current = $(this).closest('.add-block');
                        }

                        ContentBlock.append(config, $current);
                    }
                });

                $container.on('click', '.toggle-group', function(e) {
                    e.preventDefault();

                    var $list = $(this).closest('.group-title').next('.sortable-list');

                    $list.toggleClass('collapsed');
                    ContentBlock.groupUpdated($list);
                });

                $container.on('click', '.export', function(e) {
                    e.preventDefault();

                    var $group = $(this).closest('.content-blocks'),
                        name   = $group.attr('data-container'),
                        $items = $group.children('.block'),
                        values = [];

                    $items.each(function(i) {
                        values[i] = {
                            config: $(this).attr('data-config'),
                            values: ContentBlock.fetch($(this))
                        };
                    });

                    var $a = $('<a>')
                        .attr('href', 'data:text/json;charset=utf-8,' + encodeURIComponent(JSON.stringify(values, '', 2)))
                        .attr('download', name + '.json')
                        .hide().appendTo(document.body);

                    $a.get(0).click();

                    $a.remove();
                });

                $container.on('change', '[name="import-file"]', function(e) {
                    if ( e.target.files && e.target.files.length ) {
                        var file   = e.target.files[0],
                            reader = new FileReader();

                        reader.onload = (function(file, $control) {
                            return function(e) {
                                var json;

                                try {
                                    json = JSON.parse(e.target.result);
                                } catch(e) {
                                    alert('Error');
                                    return;
                                }

                                var $group = $control.closest('.content-blocks'),
                                    $last  = $group.children('.block').last();

                                if (!$last.length) {
                                    $last = $group.children('.add-block');
                                }

                                for (var i = json.length - 1; i >= 0; i--) {
                                    var $block = ContentBlock.append(json[i].config, $last);
                                    ContentBlock.setValues(opts.config[json[i].config].fields, $block.find('.fields-list').first(), json[i].values);
                                }
                            };
                        })(file, $(this));

                        reader.onloadend = (function($control) {
                            return function() {
                                $control.replaceWith($control.get(0).outerHTML);
                            };
                        })($(this));

                        reader.readAsText(file);
                    }
                });
            });

            opts.containers.eq(0).closest('form').submit(function() {
                var $form = $(this);

                $form.children('input[name^="contentblocks"]').remove();

                $('.content-blocks').each(function() {
                    var length    = 0,
                        container = $(this).attr('data-container');

                    $(this).children('.block').each(function() {
                        var $block = $(this),
                            $inner = $block.children('.block-inner'),
                            $id    = $inner.children('[name="contentblocks_id"]'),
                            data   = {
                                visible: $inner.children('.change-type').children('.visible').children('input:checked').length,
                                config:  $block.attr('data-config'),
                                values:  JSON.stringify(ContentBlock.fetch($inner))
                            };

                        if ($id.length) {
                            data.id = $id.val();
                        }

                        for (var field in data) {
                            $('<input type="hidden"/>').attr('name', 'contentblocks[' + container + '][' + length + '][' + field + ']').val(data[field]).appendTo($form);
                        }

                        length++;
                    });

                    $(this).find('[name]').attr('disabled', true);

                    if (!length) {
                        $('<input type="hidden"/>').attr('name', 'contentblocks[' + container + ']').val('0').appendTo($form);
                    }
                });

                $('.content-blocks-configs [name]').attr('disabled', true);
            });

        })(jQuery);
    };

