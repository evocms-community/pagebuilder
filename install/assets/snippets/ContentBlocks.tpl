<?php
/**
 * ContentBlocks
 * 
 * output content blocks for current page
 * 
 * @version     alpha
 * @category    snippet
 * @internal    @properties
 * @internal    @modx_category Content
 * @internal    @installset base,sample
 */
 
include_once MODX_BASE_PATH . 'assets/plugins/contentblocks/contentblocks.php';
return ( new ContentBlocks( $modx ) )->render( $modx->documentIdentifier );

