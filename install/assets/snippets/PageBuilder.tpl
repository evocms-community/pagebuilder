<?php
/**
 * PageBuilder
 * 
 * output content sections for current page
 * 
 * @version     1.3.1
 * @author      mnoskov
 * @category    snippet
 * @internal    @properties
 * @internal    @modx_category Content
 * @internal    @installset base,sample
 */
 
include_once MODX_BASE_PATH . 'assets/plugins/pagebuilder/pagebuilder.php';
return (new PageBuilder($modx))->render($params);

