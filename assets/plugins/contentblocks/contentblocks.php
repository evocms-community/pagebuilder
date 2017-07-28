<?php

    class ContentBlocks {

        const version = '0.6.1';

        private $modx;
        private $data;
        private $conf   = [];
        private $themes = [];
        private $path;
        private $params;
        private $lang;
        private $iterations = [];

        public function __construct( $modx ) {
            $this->modx = $modx;

            $this->richeditor  = $modx->getConfig( 'which_editor' );
            $this->browser     = $modx->getConfig( 'which_browser' );
            $this->table       = $modx->getFullTableName( 'contentblocks' );
            $this->path        = MODX_BASE_PATH . 'assets/plugins/contentblocks/config/';
            $this->params      = $modx->event->params;

            $lang = $modx->getConfig( 'manager_language' );
            $lang = __DIR__ . '/lang/' . $lang . '.php';

            if ( !is_readable( $lang ) ) {
                $lang = __DIR__ . '/lang/english.php';
            }

            $this->lang = include $lang;
        }

        /**
         * Load and parse template
         *
         * @param  string $template String that contains template or binding with name of template
         * @param  array $data Values
         * @return string Result of parsing
         */
        private function parseTemplate( $template, $data ) {
            if ( !function_exists( 'ParseCommand' ) ) {
                require_once( MODX_MANAGER_PATH . 'includes/tmplvars.commands.inc.php' );
            }

            $binding = ParseCommand( $template );

            if ( !empty( $binding ) ) {
                list( $command, $source ) = $binding;

                switch ( $command ) {
                    case 'CHUNK': {
                        $template = $this->modx->getChunk( trim( $source ) );
                        break;
                    }

                    case 'FILE': {
                        $template = $this->modx->atBindFileContent( $template );
                        break;
                    }
                }
            }

            $template = $this->modx->mergeSettingsContent( $template );

            return $this->modx->parseText( $template , $data );
        }

        private function renderFieldsList( $templates, $template, $config, $values ) {
            $out = '';
            $data = [];

            if ( isset( $config['fields'] ) ) {
                foreach ( $config['fields'] as $field => $options ) {
                    if ( isset( $options['elements'] ) ) {
                        if ( !isset( $templates[$field] ) ) {
                            $data[$field] = $values[$field];

                            if ( is_array( $data[$field] ) ) {
                                $data[$field] = implode( '||', $data[$field] );
                            }
                        } else {
                            $fieldTemplates = $templates[$field];

                            if ( !is_array( $fieldTemplates ) ) {
                                $fieldTemplates = [ $fieldTemplates ];
                            }

                            foreach ( $fieldTemplates as $name => $tpl ) {
                                $key = $field . ( !is_numeric( $name ) || $name > 0 ? '.' . $name : '' );
                                $data[$key] = '';

                                foreach ( $values[$field] as $index => $value ) {
                                    $this->iterations["{$field}_index"]     = $index;
                                    $this->iterations["{$field}_iteration"] = $index + 1;

                                    $data[$key] .= $this->parseTemplate( $tpl, array_merge( $this->iterations, [
                                        'value' => $value,
                                        'title' => $options['elements'][$value],
                                    ] ) );
                                }
                            }
                        }

                        continue;
                    }

                    if ( $options['type'] != 'group' ) {
                        $data[$field] = $values[$field];
                        continue;
                    }

                    if ( !isset( $templates[$field] ) ) {
                        $data[$field] = "<div>Template for fieldgroup '$field' not defined</div>";
                        continue;
                    }

                    $fieldTemplates = $templates[$field];

                    if ( !is_array( $fieldTemplates ) ) {
                        $fieldTemplates = [ $fieldTemplates ];
                    }

                    foreach ( $fieldTemplates as $name => $tpl ) {
                        $key = $field . ( !is_numeric( $name ) || $name > 0 ? '.' . $name : '' );
                        $data[$key] = '';

                        foreach ( $values[$field] as $index => $value ) {
                            $this->iterations["{$field}_index"]     = $index;
                            $this->iterations["{$field}_iteration"] = $index + 1;

                            $data[$key] .= $this->renderFieldsList( $templates, $tpl, $options, $value );
                        }
                    }
                }
            }

            return $this->parseTemplate( $template, array_merge( $this->iterations, $data ) );
        }

        /**
         * Shows all content blocks for document
         * 
         * @param  int $params Snippet parameters
         * @return string Output
         */
        public function render( $params ) {
            $params = array_merge( [
                'docid'     => $this->modx->documentIdentifier,
                'blocks'    => '*',
                'templates' => '',
                'offset'    => 0,
                'limit'     => 0,
            ], $params );

            if ( $params['blocks'] != '*' ) {
                $params['blocks'] = explode( ',', $params['blocks'] );
            }

            $out = '';
            $idx = -1;

            $this->fetch( $params['docid'], false );

            foreach ( $this->data as $row ) {
                $idx++;

                $this->iterations['index']     = $idx;
                $this->iterations['iteration'] = $idx + 1;

                if ( $params['blocks'] != '*' ) {
                    $config = pathinfo( $row['config'], PATHINFO_FILENAME );

                    if ( !in_array( $config, $params['blocks'] ) ) {
                        continue;
                    }
                }

                if ( $idx < $params['offset'] ) {
                    continue;
                }

                if ( $params['limit'] > 0 && $idx >= $params['limit'] ) {
                    break;
                }

                $conf = $this->conf[ $row['config'] ];
                $templates = $conf['templates'];

                if ( !empty( $params['templates'] ) ) {
                    if ( !isset( $templates[ $params['templates'] ] ) ) {
                        $out .= "<div>Templates set '" . $params['templates'] . "' not defined</div>";
                        continue;
                    }

                    $templates = $templates[ $params['templates'] ];
                }

                if ( !isset( $templates['owner'] ) ) {
                    $out .= "<div>Template 'owner' not defined</div>";
                    continue;
                }

                $out .= $this->renderFieldsList( $templates, $templates['owner'], $conf, $row['values'] );
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
            $data['l'] = $this->lang;
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
            $this->fetch( $this->params['id'] );

            if ( empty( $this->conf ) ) {
                return '';
            }

            // load manager lang file for date settings
            include MODX_MANAGER_PATH . 'includes/lang/' . $this->modx->getConfig( 'manager_language' ) . '.inc.php';

            return $this->renderTpl( 'tpl/form.tpl', [
                'version'   => self::version,
                'tabname'   => !empty( $this->params['tabName'] ) ? $this->params['tabName'] : 'Content Blocks',
                'addType'   => !empty( $this->params['addType'] ) ? $this->params['addType'] : 'dropdown',
                'placement' => !empty( $this->params['placement'] ) ? $this->params['placement'] : 'content',
                'browseurl' => MODX_MANAGER_URL . 'media/browser/' . $this->browser . '/browse.php',
                'configs'   => $this->conf,
                'blocks'    => $this->data,
                'adminlang' => $_lang,
                'picker'    => [
                    'yearOffset' => $this->modx->getConfig( 'datepicker_offset' ),
                    'format'     => $this->modx->getConfig( 'datetime_format' ) . ' hh:mm:00',
                ],
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

            $templateid = isset( $this->params['template'] ) ? $this->params['template'] : $this->modx->documentObject['template'];

            foreach ( scandir( $this->path ) as $entry ) {
                if ( pathinfo( $entry, PATHINFO_EXTENSION ) == 'php' ) {
                    $config = include( $this->path . $entry );

                    foreach ( [ 'show_in_templates', 'show_in_docs', 'hide_in_docs' ] as $opt ) {
                        if ( isset( $config[$opt] ) && !is_array( $config[$opt] ) ) {
                            $config[$opt] = [ $config[$opt] ];
                        }
                    }

                    $add = true;

                    if ( isset( $config['show_in_templates'] ) && !in_array( $templateid, $config['show_in_templates'] ) ) {
                        $add = false;
                    }

                    if ( $add && isset( $config['hide_in_docs'] ) && in_array( $docid, $config['hide_in_docs'] ) ) {
                        $add = false;
                    }

                    if ( isset( $config['show_in_docs'] ) ) {
                        if ( in_array( $docid, $config['show_in_docs'] ) ) {
                            $add = true;
                        } else if ( !isset( $config['show_in_templates'] ) ) {
                            $add = false;
                        }
                    }

                    if ( $add ) {
                        $this->conf[$entry] = $config;

                        if ( $notpl ) {
                            unset( $this->conf[$entry]['templates'] );
                        }
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
            if ( isset( $_POST['contentblocks'] ) ) {
                if ( is_array( $_POST['contentblocks'] ) ) {
                    $docid  = $this->params['id'];

                    $exists = array_map( function( $element ) { 
                        return $element['id'];
                    }, $_POST['contentblocks'] );

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
                } else {
                    if ( $_POST['contentblocks'] == 0 ) {
                        $this->modx->db->delete( $this->table, "`document_id` = '" . $this->params['id'] . "'" );
                    }
                }
            }
        }

        /**
         * Parse values from modx-style string, 
         * e.g. 1||2,
         * or @EVAL ...,
         * or @SELECT
         *
         * @param  mixed $input
         * @return mixed
         */
        private function parseValues( $input ) {
            if ( !function_exists( 'ParseIntputOptions' ) ) {
                require_once( MODX_MANAGER_PATH . 'includes/tmplvars.inc.php' );
            }

            if ( !function_exists( 'ProcessTVCommand' ) ) {
                require_once( MODX_MANAGER_PATH . 'includes/tmplvars.commands.inc.php' );
            }

            if ( !is_string( $input ) ) {
                return $input;
            } else {
                $values   = [];
                $elements = ParseIntputOptions( ProcessTVCommand( $input, '', '', 'tvform', $tv = [] ) );

                if ( !empty( $elements ) ) {
                    foreach ( $elements as $element ) {
                        list( $val, $key ) = is_array( $element ) ? $element : explode( '==', $element );

                        if ( strlen( $val ) == 0 ) {
                            $val = $key;
                        }

                        if ( strlen( $key ) == 0 ) {
                            $key = $val;
                        }

                        $values[$key] = $val;
                    }
                }
            }

            return $values;
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

            $default = '';

            if ( !empty( $field['default'] ) ) {
                $default = $this->parseValues( $field['default'] );
                
                if ( $field['type'] != 'checkbox' && is_array( $default ) ) {
                    $default = reset( $default );
                }
            }

            $params = [
                'name'     => $name,
                'field'    => $field,
                'value'    => is_null( $value ) ? $default : $value,
                'elements' => [ 
                    '' => $this->lang['No variants provided'],
                ],
            ];

            switch ( $field['type'] ) {
                case 'group': {
                    if ( !is_array( $value ) ) {
                        $value = [ [] ];
                    } else {
                        array_unshift( $value, [] );
                    }

                    return $this->renderTpl( 'tpl/field_group.tpl', array_merge( $params, [
                        'values' => $value,
                    ] ) );
                }

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

                    return $this->renderTpl( 'tpl/field_richtext.tpl', $params );
                }

                case 'checkbox': {
                    if ( !is_array( $value ) ) {
                        $value = [ $value ];
                    }
                }

                case 'radio': {
                    $params['layout'] = 'vertical';

                    if ( isset( $field['layout'] ) && in_array( $field['layout'], [ 'horizontal', 'vertical' ] ) ) {
                        $params['layout'] = $field['layout'];
                    }
                }

                case 'dropdown': {
                    if ( !empty( $field['elements'] ) ) {
                        $params['elements'] = $this->parseValues( $field['elements'] );
                    }
                }

                default: {
                    return $this->renderTpl( 'tpl/field_' . $field['type'] . '.tpl', $params );
                }
            }

            return '';
        }

        /**
         * Called at OnDocDuplicate event
         */
        public function duplicate() {
            if ( $this->params['id'] && $this->params['new_id'] ) {
                $query = $this->modx->db->select( '*', $this->table, "`document_id` = '" . $this->params['id'] . "'", "`index` ASC" );

                while ( $row = $this->modx->db->getRow( $query ) ) {
                    $this->modx->db->insert( [
                        'document_id' => $this->params['new_id'],
                        'config'      => $this->modx->db->escape( $row['config'] ),
                        'values'      => $this->modx->db->escape( $row['values'] ),
                        'index'       => $row['index'],
                    ], $this->table );
                }
            }
        }

        /**
         * Called at OnBeforeEmptyTrash event
         */
        public function delete() { 
            if ( !empty( $this->params['ids'] ) ) {
                $this->modx->db->delete( $this->table, "`document_id` IN ('" . implode( "','", $this->params['ids'] ) . "')" );
            }
        }

    }

