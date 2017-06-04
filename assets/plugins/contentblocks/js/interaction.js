
	if ( typeof lastImageCtrl === 'undefined' ) {
		var lastImageCtrl;
	}

	if ( typeof lastFileCtrl === 'undefined' ) {
		var lastFileCtrl;
	}

	if ( !window['SetUrlChange'] ) {
		function SetUrlChange(el) {
			if ('createEvent' in document) {
				var evt = document.createEvent('HTMLEvents');
				evt.initEvent('change', false, true);
				el.dispatchEvent(evt);
			} else {
				el.fireEvent('onchange');
			}
		}
	}

	if ( !window['SetUrl'] ) {
		function SetUrl( url, width, height, alt ) {
			if ( lastFileCtrl ) {
				var c = document.getElementById(lastFileCtrl);
				if(c && c.value != url) {
				    c.value = url;
					SetUrlChange(c);
				}
				lastFileCtrl = '';
			} else if(lastImageCtrl) {
				var c = document.getElementById(lastImageCtrl);
				if(c && c.value != url) {
				    c.value = url;
					SetUrlChange(c);
				}
				lastImageCtrl = '';
			} else {
				return;
			}
		}
	}

	var initcontentblocks = function( opts ) {
		return ( function( $ ) {

			var $container = $(opts.container);

			var ContentBlock = {

				initialize: function( blocks ) {
					$(blocks).each( function() {
						var $block   = $(this),
							confName = $block.attr( 'data-config' ),
							conf     = opts.config[ confName ],
							$list    = $block.children('.fields-list');

						// set block type
						$block.children('.change-type').children('select').val( confName );

						// add controls handlers
						( function( $block ) {
							$block.children('.controls')
								.on( 'click', '.moveup, .movedown', function( e ) {
									e.preventDefault();
									ContentBlock.move( $block, $(this).hasClass( 'moveup' ) ? 'up' : 'down' );
								} )

								.on( 'click', '.insert', function( e ) {
									e.preventDefault();
									ContentBlock.append( $block );
								} )

								.on( 'click', '.remove', function( e ) {
									e.preventDefault();
									$block.slideUp( 200, function() {
										$block.remove();
									} );
								} );
						} )( $block );

						$block.on( 'click', '.open-browser', function( e ) {
							e.preventDefault();
							var input = $(this).next('input').get(0);
							input.id = 'input' + ( ( ( 1 + Math.random() ) * 0x100000 ) | 0 ).toString( 16 );
							ContentBlock.openBrowser( input.id, 'images' );
						} );

						$block.on( 'click', '.sortable-item > .controls > .insert', function( e ) {
							e.preventDefault();
							e.stopPropagation();
							ContentBlock.insertItem( $(this).closest('.sortable-item') );
						} );

						$block.on( 'click', '.sortable-item > .controls > .remove', function( e ) {
							e.preventDefault();
							e.stopPropagation();
							$(this).closest('.sortable-item').slideUp( 200, function() {
								$(this).remove();
							} );
						} );

						$block.on( 'change', '> .change-type select', function( e ) {
							ContentBlock.changeType( $(this).closest('.block'), $(this).val() );
						} );

						ContentBlock.initializeFieldsList( conf.fields, $list );
					} );
				},

				fetch: function( $block ) {
					var values = {},
						$list  = $block.children('.fields-list'),
						conf   = $list.data( 'fields' );

					for ( var field in conf ) {
						var $field = $list.children('.field[data-field="' + field + '"]'),
							fieldConfig = conf[field];

						switch ( conf[field].type ) {
							case 'richtext': {
								var f = $field.children('textarea').get(0);

								if ( f.id && tinymce.editors[f.id] ) {
									values[field] = tinymce.editors[f.id].getContent();
								} else {
									values[field] = '';
								}

								break;
							}

							case 'group': {
								values[field] = [];

								$field.children('.sortable-list').children('.sortable-item:not(.hidden)').each( function() {
									values[field].push( ContentBlock.fetch( $(this) ) );
								} );

								break;
							}

							default: {
								values[field] = $field.children('input[type="text"], textarea').val();
							}
						}
					}

					return values;
				},

				setValues: function( conf, $list, values ) {
					for ( var field in conf ) {
						var $field = $list.children('.field[data-field="' + field + '"]');

						if ( conf[field].type == 'group' ) {
							if ( typeof values[field] === 'object' && values[field].length ) {
								var $sortable = $field.children('.sortable-list'),
									$element  = $sortable.children('.sortable-item.hidden');

								for ( var i = 0; i < values[field].length; i++ ) {
									var $clone = $element.clone( true );
									
									$clone.children('.fields-list').removeClass( 'hidden' );
									$clone.removeClass( 'hidden' ).appendTo( $sortable );

									ContentBlock.setValues( conf[field].fields, $clone.children('.fields-list'), values[field][i] );
								}
							}
						} else {
							if ( typeof values[field] !== 'undefined' && typeof values[field] != 'object' ) {
								$field.children('input[type="text"], textarea').val( values[field] );
							}
						}
					}
				},

				changeType: function( $block, type ) {
					var values = this.fetch( $block ),
						$newblock = $('.content-blocks-configs').children('[data-config="' + type + '"]');

					if ( $newblock.length ) {
						$newblock = $newblock.clone();
						$block.replaceWith( $newblock );

						ContentBlock.setValues( opts.config[type].fields, $newblock.children('.fields-list'), values );
						ContentBlock.initialize( $newblock );
					}
				},

				append: function( $after ) {
					var $block = $('.content-blocks-configs').children().eq(0);

					if ( $block.length ) {
						$block = $block.clone();
						$block.hide().insertAfter( $after ).slideDown( 200 );
						ContentBlock.initialize( $block );
					}
				},

				move: function( $block, direction ) {
					if ( direction == 'up' ) {
						var $sibling = $block.prev('.block');

						if ( !$sibling.length ) {
							return;
						}
					} else {
						var $sibling = $block.next('.block');

						if ( $sibling.length ) {
							$block.insertAfter( $sibling );
						}
					}

					var $rich = $block.find('textarea.richtext');

					$rich.each( function() {
						if ( this.id && tinymce.editors[this.id] ) {
							tinymce.editors[this.id].destroy();
						}
					} );

					if ( direction == 'up' ) {
						$block.insertBefore( $sibling );
					} else {
						$block.insertAfter( $sibling );
					}

					$rich.each( function() {
						ContentBlock.initializeRichField( $(this) );
					} );
				},

				insertItem: function( $after ) {
					if ( $after.hasClass( 'hidden' ) ) {
						var $clone = $after.clone( true );
					} else {
						var $clone = $after.parent().children('.hidden').eq(0).clone( true );
					}

					$clone.removeClass( 'hidden' ).hide().insertAfter( $after );
					$clone.children('.fields-list').removeClass( 'hidden' );

					if ( $after.hasClass( 'hidden' ) ) {
						ContentBlock.initializeSortableList( $after.parent() );
					}

					ContentBlock.initializeFieldsList( $after.children('.fields-list').data( 'fields' ), $clone.children('.fields-list') );

					$clone.slideDown( 200 );
				},

				initializeFieldsList: function( conf, $list ) {
					$list.data( 'fields', conf );

					for ( var field in conf ) {
						var $field = $list.children('.field[data-field="' + field + '"]'),
							fieldConfig = conf[field];

						switch ( fieldConfig.type ) {
							case 'richtext': {
								var $textarea = $field.children('textarea');

								if ( fieldConfig.options ) {
									$textarea.data( 'options', fieldConfig.options );
								}
								
								if ( fieldConfig.theme ) {
									$textarea.data( 'theme', fieldConfig.theme );
								}
								
								ContentBlock.initializeRichField( $textarea );

								break;
							}

							case 'group': {
								var $sortable = $field.children('.sortable-list');

								$sortable.children('.sortable-item').each( function() {
									ContentBlock.initializeFieldsList( conf[field].fields, $(this).children('.fields-list') );
								} );

								if ( !$list.parent().hasClass( 'hidden' ) ) {
									ContentBlock.initializeSortableList( $sortable );
								}

								break;
							}
						}
					}
				},

				initializeSortableList: function( $sortable ) {
					$sortable.sortable( {
						axis:  'y',
						items: '> .sortable-item:not(.hidden)',
						handle: '> .handle',
						start: function( e, ui ) {
							ui.item.find('textarea.richtext').each( function() {
								if ( this.id && tinymce.editors[this.id] ) {
									tinymce.editors[this.id].save();
								}
							} );
						},
						stop: function( e, ui ) {
							ui.item.find('textarea.richtext').each( function() {
								if ( this.id && tinymce.editors[this.id] ) {
									tinymce.editors[this.id].destroy();
								}
								ContentBlock.initializeRichField( $(this) );
							} );
						}
					} );
				},

				initializeRichField: function( $textarea ) {
					if ( $textarea.closest('.hidden').length ) {
						return;
					}

					var theme   = $textarea.data( 'theme' ),
						options = $textarea.data( 'options' );

					$textarea.get(0).id = 'rich' + ( ( ( 1 + Math.random() ) * 0x100000 ) | 0 ).toString( 16 );
								
					if ( typeof tinymce !== 'undefined' ) {
						var conf = theme != undefined ? window['config_tinymce4_' + theme] : window[ modxRTEbridge_tinymce4.default ];

						// content field configuration for tinymce
						if ( options ) {
							var old = {};

							// save all standard options for other fields
							for ( option in options ) {
								old[option] = conf[option] ? conf[option] : undefined;
								conf[option] = options[option];
							}
						}

						conf['selector'] = '#' + $textarea.attr( 'id' );
						tinymce.init( conf );

						if ( options ) {
							for ( option in old ) {
								if ( old[option] != undefined ) {
									conf[option] = old[option];
								} else {
									delete conf[option];
								}
							}
						}
					}
				},

				openBrowser: function( ctrl, type ) {
					if ( type == 'images' ) {
						lastImageCtrl = ctrl;
					} else {
						lastFileCtrl = ctrl;
					}

					var width  = screen.width * .8,
						height = screen.height * .8,
						left   = ( screen.width  - width ) * .5,
						top    = ( screen.height - height ) * .5,
						params = 'toolbar=no,status=no,resizable=yes,dependent=yes,width=' + width + ',height=' + height + ',left=' + left + ',top=' + top;

					window.open( opts.browser + '?Type=' + type, 'FCKBrowseWindow', params ) ;
				}

			}

			ContentBlock.initialize( $container.children('.block') );

			$container.closest('form').submit( function() {
				var $form = $(this);

				$form.children('input[name^="contentblocks"]').remove();

				$container.children('.block').each( function( i ) {
					var $block = $(this),
						$id = $block.children('[name="contentblocks_id"]');

					$('<input type="hidden"/>').attr( 'name', 'contentblocks[' + i + '][config]' ).val( $block.attr( 'data-config' ) ).appendTo( $form );
					$('<input type="hidden"/>').attr( 'name', 'contentblocks[' + i + '][values]' ).val( JSON.stringify( ContentBlock.fetch( $block ) ) ).appendTo( $form );

					if ( $id.length ) {
						$('<input type="hidden"/>').attr( 'name', 'contentblocks[' + i + '][id]' ).val( $id.val() ).appendTo( $form );
					}
				} );
			} );

			$container.children('.add-block').children('[type="button"]').click( function( e ) {
				e.preventDefault();

				var config = $(this).prev('select').val();

				if ( config != '' ) {
					var $block = $('.content-blocks-configs').children('[data-config="' + config + '"]');

					if ( $block.length ) {
						$block = $block.clone();
						$block.hide().insertAfter( $(this).parent() ).slideDown( 200 );
						ContentBlock.initialize( $block );
					}
				}
			} );

		} )( jQuery );
	}

