//<?php
/**
 * ContentBlocks
 * 
 * Creates form for manage content blocks
 *
 * @category    plugin
 * @version     0.6.0
 * @author      sunhaim
 * @internal    @properties &tabName=Tab name;text;Content Blocks &addType=Add type;menu;dropdown,icons,images;dropdown
 * @internal    @events OnDocFormRender,OnDocFormSave,OnBeforeEmptyTrash,OnDocDuplicate 
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base,sample
 */

include_once MODX_BASE_PATH . 'assets/plugins/contentblocks/contentblocks.php';

$e = &$modx->event;

switch ( $e->name ) {
	case 'OnDocFormRender': { 
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

