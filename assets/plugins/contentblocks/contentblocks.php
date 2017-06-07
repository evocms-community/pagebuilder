<?php

	class ContentBlocks {

		const version = 'alpha.3';

		private $modx;
		private $data;
		private $conf   = [];
		private $themes = [];
		private $path;
		private $params;

		public function __construct( $modx ) {
			$this->modx = $modx;

			$this->richeditor = $modx->getConfig( 'which_editor' );
			$this->browser    = $modx->getConfig( 'which_browser' );
			$this->table      = $modx->getFullTableName( 'contentblocks' );
			$this->path       = MODX_BASE_PATH . 'assets/plugins/contentblocks/config/';
			$this->params     = $modx->event->params;
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

		/**
		 * Shows all content blocks for document
		 * 
		 * @param  int $docid Document identificator
		 * @return string Output
		 */
		public function render( $docid ) {
			$out = '';

			$this->fetch( $docid, false );

			foreach ( $this->data as $row ) {
				$conf = $this->conf[ $row['config'] ];
				$out .= $this->renderFieldsList( $conf['templates'], $conf['templates']['owner'], 'owner', $conf, $row['values'] );
			}

			return $out;
		}

		/**
		 * Renders template in admin panel
		 * 
		 * @param  string $template Template
		 * @param  array $data Values for binding to template
		 * @return string Output
		 */
		public function renderTpl( $template, $data ) {
			$data['instance'] = $this;
			extract( $data );

			ob_start();
			include( __DIR__ . '/' . $template );
			$output = ob_get_contents();
			ob_end_clean();
			
			return $output;
		}

		/**
		 * Renders form in new tab on document editing page, called at OnDocFormRender event
		 * 
		 * @return string Output
		 */
		public function renderForm() {
			$this->fetch( $this->modx->event->params['id'] );

			return $this->renderTpl( 'tpl/form.tpl', [
				'version'   => self::version,
				'themes'    => $this->themes,
				'tabname'   => !empty( $this->params['tabName'] ) ? $this->params['tabName'] : 'Content Blocks',
				'browseurl' => MODX_MANAGER_URL . 'media/browser/' . $this->browser . '/browse.php',
				'configs'   => $this->conf,
				'blocks'    => $this->data,
			] );
		}

		/**
		 * Loads saved content blocks and configuration files
		 * 
		 * @param  int $docid Document identificator
		 * @param  boolean $notpl If true, template will be cut from configuration array
		 */
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

		/**
		 * Called at OnDocFormSave event for saving content blocks
		 */
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
			}
		}

		/**
		 * Renders field control
		 * 
		 * @param  array $field Array with field options
		 * @param  string $name Symbolic identificator of field
		 * @param  mixed $value Value of field
		 * @return string Output
		 */
		public function renderField( $field, $name, $value ) {
			$out = '';

			switch ( $field['type'] ) {
				case 'richtext': {
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
				}

				case 'text':
				case 'image': {
					return $this->renderTpl( 'tpl/field_' . $field['type'] . '.tpl', [
						'name'  => $name,
						'field' => $field,
						'value' => $value,
					] );
				}

				case 'group': {
					if ( !is_array( $value ) ) {
						$value = [ [] ];
					} else {
						array_unshift( $value, [] );
					}

					return $this->renderTpl( 'tpl/field_group.tpl', [
						'name'   => $name,
						'field'  => $field,
						'values' => $value,
					] );
				}
			}

			return '';
		}

	}

