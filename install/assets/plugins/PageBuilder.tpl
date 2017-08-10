//<?php
/**
 * PageBuilder
 * 
 * Creates form for manage content sections
 *
 * @category    plugin
 * @version     1.0.0
 * @author      sunhaim
 * @internal    @properties &tabName=Tab name;text;Content Blocks &addType=Add type;menu;dropdown,icons,images;dropdown &placement=Placement;menu;content,tab;tab
 * @internal    @events OnDocFormRender,OnDocFormSave,OnBeforeEmptyTrash,OnDocDuplicate 
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base,sample
 */

include_once MODX_BASE_PATH . 'assets/plugins/pagebuilder/pagebuilder.php';

$e = &$modx->event;

switch ( $e->name ) {
	case 'OnDocFormRender': { 
		$e->output( ( new PageBuilder( $modx ) )->renderForm() );
		return;
	}

	case 'OnDocFormSave': {
		( new PageBuilder( $modx ) )->save();
		return;
	}
		
	case 'OnBeforeEmptyTrash': {
		( new PageBuilder( $modx ) )->delete();
		return;
	}
		
	case 'OnDocDuplicate': {
		( new PageBuilder( $modx ) )->duplicate();
		return;
	}
}

