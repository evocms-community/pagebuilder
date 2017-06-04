<?php

	class ContentBlocks {

		private $modx;
		private $data;
		private $conf   = [];
		private $themes = [];
		private $path;

		public function __construct( $modx ) {
			$this->modx = $modx;

			$this->richeditor = $modx->getConfig( 'which_editor' );
			$this->browser    = $modx->getConfig( 'which_browser' );
			$this->table      = $modx->getFullTableName( 'contentblocks' );
			$this->path       = MODX_BASE_PATH . 'assets/plugins/contentblocks/config/';
		}

		private function renderFieldsList( $templates, $template, $fieldname, $config, $values ) {
			$out = '';
			$data = [];

			foreach ( $config['fields'] as $field => $options ) {
				if ( $options['type'] == 'group' ) {
					if ( !isset( $templates[$field] ) ) {
						return "NO TEMPLATE FOR FIELDGROUP '$field'";
					}

					if ( is_array( $templates[$field] ) ) {
						foreach ( $templates[$field] as $tplname => $tpl ) {
							$key = $field . '.' . $tplname;
							$data[$key] = '';

							foreach ( $values[$field] as $row ) {
								$data[$key] .= $this->renderFieldsList( $templates, $tpl, $field, $options, $row );
							}
						}
					} else {
						$data[$field] = '';

						foreach ( $values[$field] as $row ) {
							$data[$field] .= $this->renderFieldsList( $templates, $templates[$field], $field, $options, $row );
						}
					}
				} else {
					$data[$field] = $values[$field];
				}
			}

			return $this->modx->parseText( $template, $data );
		}

		public function render( $docid ) {
			$out = '';

			$this->fetch( $docid, false );

			foreach ( $this->data as $row ) {
				$conf = $this->conf[ $row['config'] ];
				$out .= $this->renderFieldsList( $conf['templates'], $conf['templates']['owner'], 'owner', $conf, $row['values'] );
			}

			return $out;
		}

		private function fetch( $docid, $notpl = true ) {
			if ( $docid ) {
				$query = $this->modx->db->select( '*', $this->table, "`document_id` = '$docid'", "`index` ASC" );
				$data  = $this->modx->db->makeArray( $query );
			} else {
				$data = [];
			}

			$this->conf = [];

			foreach ( scandir( $this->path ) as $entry ) {
				if ( pathinfo( $entry, PATHINFO_EXTENSION ) == 'php' ) {
					$this->conf[$entry] = include( $this->path . $entry );
					if ( $notpl ) {
						unset( $this->conf[$entry]['templates'] );
					}
				}
			}

			foreach ( $data as $i => $row ) {
				if ( isset( $this->conf[ $row['config'] ] ) ) {
					$data[$i]['values'] = json_decode( $data[$i]['values'], true );
				} else {
					unset( $data[$i] );
				}
			}

			$this->data = $data;
		}

		public function save() {
			if ( isset( $_POST['contentblocks'] ) && is_array( $_POST['contentblocks'] ) ) {
				$exists = array_column( $_POST['contentblocks'], 'id' );
				$docid  = $this->modx->event->params['id'];

				$this->modx->db->delete( $this->table, "`document_id` = '$docid' AND `id` NOT IN ('" . implode( "','", $exists ) . "')" );

				foreach ( $_POST['contentblocks'] as $index => $row ) {
					if ( !empty( $row['id'] ) ) {
						$this->modx->db->update( [
							'config' => $this->modx->db->escape( $row['config'] ),
							'values' => $this->modx->db->escape( $row['values'] ),
							'index'  => $index,
						], $this->table, "`id` = '{$row[id]}'" );
					} else {
						$this->modx->db->insert( [
							'document_id' => $docid,
							'config'      => $this->modx->db->escape( $row['config'] ),
							'values'      => $this->modx->db->escape( $row['values'] ),
							'index'       => $index,
						], $this->table );
					}
				}

				file_put_contents( $_SERVER['DOCUMENT_ROOT'] . '/test.txt', print_r($_POST,1));
			}
		}

		public function renderField( $field, $name, $value ) {
			$out = '';

			switch ( $field['type'] ) {
				case 'text': {
					$out = '<input type="text" name="contentblocks_' . $name . '" value="' . htmlentities( $value ) . '">';
					break;
				}

				case 'richtext': {
					$out = '<textarea name="contentblocks_' . $name . '" class="richtext">' . htmlentities( $value ) . '</textarea>';

					if ( isset( $field['theme'] ) && !isset( $this->themes[ $field['theme'] ] ) && in_array( $this->richeditor, [ 'TinyMCE4' ] ) ) {
                        $result = $this->modx->invokeEvent( 'OnRichTextEditorInit', [
                            'editor'  => $this->richeditor,
                            'options' => [ 'theme' => $field['theme'] ],
                        ] );

                        if ( is_array( $result ) ) {
                            $result = implode( '', $result );
                        }

                        $this->themes[ $field['theme'] ] = $result;
					}

					break;
				}

				case 'image': {
					$out = '<div class="preview"></div><input type="button" class="open-browser" value="Выбрать"><input type="text" name="contentblocks_' . $name . '" value="' . htmlentities( $value ) . '">';
					break;
				}

				case 'group': {
					if ( !is_array( $value ) ) {
						$value = [ [] ];
					} else {
						array_unshift( $value, [] );
					}

					foreach ( $value as $i => $row ) {
						$item = '';
	
						foreach ( $field['fields'] as $child => $childfield ) {
							$item .= $this->renderField( $childfield, $child, isset( $row[$child] ) ? $row[$child] : '' );
						}

						$out .= '
							<div class="sortable-item' . ( !$i ? ' hidden' : '' ) . '">
								<div class="handle"></div>

								<div class="fields-list' . ( !$i ? ' hidden' : '' ) . '">
									' . $item . '
								</div>

								<div class="controls">
									<a href="#" class="remove" title="Удалить элемент"><i class="fa fa-minus-circle"></i></a>
									<a href="#" class="insert" title="Вставить элемент"><i class="fa fa-plus-circle"></i></a>
								</div>
							</div>
						';
					}

					return '
						<div class="field fields-group" data-field="' . $name . '">
							<div class="group-title">
								' . $field['caption'] . '
							</div>
							<div class="sortable-list">
								' . $out . '
							</div>
						</div>
					';
				}
			}

			return '<div class="field type-' . $field['type'] . '" data-field="' . $name . '">' . ( !empty( $field['caption'] ) ? '<div class="field-name">' . $field['caption'] . '</div>' : '' ) . $out . '</div>';
		}

		public function renderBlockFields( $conf, $block = [] ) {
			$out = '';

			foreach ( $conf['fields'] as $name => $field ) {
				$out .= $this->renderField( $field, $name, isset( $block['values'][$name] ) ? $block['values'][$name] : '' );
			}

			return $out;
		}

		public function renderBlock( $block ) {
			return '
				<div class="block" data-config="' . $block['config'] . '">
					<div class="change-type">
						<select name="available">
							' . $this->available . '
						</select>
					</div>

					' . ( !empty( $block['id'] ) ? '<input type="hidden" name="contentblocks_id" value="' . $block['id'] . '">' : '' ) . '

					<div class="controls">
						<a href="#" class="remove" title="Удалить блок"><i class="fa fa-minus-circle"></i></a>
						<a href="#" class="moveup" title="Переместить наверх"><i class="fa fa-arrow-up"></i></a>
						<a href="#" class="movedown" title="Переместить вниз"><i class="fa fa-arrow-down"></i></a>
					</div>

					<div class="fields-list">
						' . $this->renderBlockFields( $this->conf[ $block['config'] ], $block ) . '
					</div>

					<div class="controls controls-bottom">
						<a href="#" class="insert" title="Вставить блок"><i class="fa fa-plus-circle"></i></a>
					</div>
				</div>
			';
		}

		public function renderForm() {
			$this->fetch( $this->modx->event->params['id'] );

			$this->available = '<option value="">-- Выберите тип блока --</option>';

			$blocks = $configs = '';

			foreach ( $this->conf as $fn => $conf ) {
				$this->available .= '<option value="' . $fn . '">' . $conf['title'] . '</option>';
			}

			foreach ( $this->conf as $fn => $conf ) {
				$configs .= $this->renderBlock( [ 'config' => $fn ] );
			}

			foreach ( $this->data as $block ) {
				$blocks .= $this->renderBlock( $block );
			}

			return '
				<link rel="stylesheet" href="/assets/plugins/contentblocks/styles/styles.css">
				<script src="/assets/plugins/contentblocks/js/jquery-ui.min.js"></script>
				<script src="/assets/plugins/contentblocks/js/interaction.js"></script>

				' . implode( "\n", $this->themes ) . '

				<div class="tab-page" style="width:100%;-moz-box-sizing: border-box; box-sizing: border-box;">
					<h2 class="tab" id="contentblockstab">Content Blocks</h2>

					<div class="content-blocks-configs">
						' . $configs . '
					</div>
					
					<div class="content-blocks" id="content-blocks">
						<div class="add-block">
							<select name="available">
								' . $this->available . '
							</select>
							<input type="button" value="Добавить блок">
						</div>
						' . $blocks . '
					</div>
				</div>
				
				<script>
					jQuery( function() {
						initcontentblocks( {
							container: document.getElementById( "content-blocks" ), 
							values: ' . json_encode( $this->data, JSON_UNESCAPED_UNICODE ) . ', 
							config: ' . json_encode( $this->conf, JSON_UNESCAPED_UNICODE ) . ',
							browser: "' . MODX_MANAGER_URL . 'media/browser/' . $this->browser . '/browser.php"
						} );
					} );
				</script>
			';
		}

	}

