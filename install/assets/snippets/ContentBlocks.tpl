<?php
/**
 * ContentBlocks
 * 
 * output content blocks for current page
 * 
 * @version     0.6.2
 * @category    snippet
 * @internal    @properties
 * @internal    @modx_category Content
 * @internal    @installset base,sample
 */
 
include_once MODX_BASE_PATH . 'assets/plugins/contentblocks/contentblocks.php';
return ( new ContentBlocks( $modx ) )->render( $params );

