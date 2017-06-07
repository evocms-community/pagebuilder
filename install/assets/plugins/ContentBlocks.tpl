//<?php
/**
 * ContentBlocks
 * 
 * Creates form for manage content blocks
 *
 * @category    plugin
 * @version     alpha
 * @author      sunhaim
 * @internal    @properties &tabName=Tab name;text;Content Blocks &templates=Templates;text; &documents=Documents;text; &ignore=Ignore Documents;text;
 * @internal    @events OnDocFormRender,OnDocFormSave,OnBeforeEmptyTrash,OnDocDuplicate 
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base,sample
 */

include_once MODX_BASE_PATH . 'assets/plugins/contentblocks/contentblocks.php';

$e = &$modx->event;

switch ( $e->name ) {
	case 'OnDocFormRender': { 
		$options = [];

		foreach ( [ 'templates', 'documents', 'ignore' ] as $field ) {
			if ( !empty( $e->params[$field] ) ) {
				$options[$field] = array_map( function( $item ) {
					return trim( $item );
				}, explode( ',', $e->params[$field] ) );
			} else {
				$options[$field] = [];
			}
		}

		if ( in_array( $e->params['id'], $options['ignore'] ) ) {
			return;
		}

		if ( !in_array( $e->params['template'], $options['templates'] ) && !in_array( $e->params['id'], $options['documents'] ) ) {
			return;
		}

		$e->output( ( new ContentBlocks( $modx ) )->renderForm() );
		return;
	}

	case 'OnDocFormSave': {
		( new ContentBlocks( $modx ) )->save();
		return;
	}
		
	case 'OnBeforeEmptyTrash': {
		( new ContentBlocks( $modx ) )->delete();
		return;
	}
		
	case 'OnDocDuplicate': {
		( new ContentBlocks( $modx ) )->duplicate();
		return;
	}
}

