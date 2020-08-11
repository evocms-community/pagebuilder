<?php

if (IN_MANAGER_MODE != 'true') {
    die('<h1>ERROR:</h1><p>Please use the MODx Content Manager instead of accessing this file directly.</p>');
}

$path   = __DIR__ . '/../../plugins/pagebuilder/';
$parts  = explode('/', $row['name']);
$name   = 'container.' . array_pop($parts) . '.php';
$config = $path . 'config/' . implode('/', $parts) . '/' . $name;

require_once $path . 'pagebuilder.php';

if (!file_exists($config)) {
    echo 'File "' . $config . '" not exists!';
}

$container = include $config;

$pb = new PageBuilder($modx, [
    'placement' => 'tv',
    'tv'        => $field_id,
    'id'        => isset($content['modulecode']) ? 0 : $content['id'],
    'template'  => isset($content['modulecode']) ? 0 : $content['template'],
    'container' => $row['name'],
    'addType'   => !empty($container['addType']) ? $container['addType'] : 'dropdown',
]);

echo $pb->renderForm();
