//<?php
/**
 * PageBuilderInstall
 *
 * PageBuilder installer
 *
 * @category    plugin
 * @author      mnoskov
 * @internal    @events OnWebPageInit,OnManagerPageInit,OnPageNotFound
 * @internal    @installset base
*/

$table = $modx->getFullTablename('pagebuilder');
$tableEventnames = $modx->getFullTablename('system_eventnames');

$modx->clearCache('full');

$events = [
    'OnPBContainerRender',
    'OnPBFieldRender',
];

$query  = $modx->db->select('*', $tableEventnames, "`groupname` = 'PageBuilder'");
$exists = [];

while ($row = $modx->db->getRow($query)) {
    $exists[$row['name']] = $row['id'];
}

foreach ($events as $event) {
    if (!isset($exists[$event])) {
        $modx->db->insert([
            'name'      => $event,
            'service'   => 6,
            'groupname' => 'PageBuilder',
        ], $tableEventnames);
    }
}

$modx->db->query("
    CREATE TABLE IF NOT EXISTS $table (
        `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `document_id` int(10) unsigned NOT NULL,
        `title` varchar(255) NOT NULL,
        `config` varchar(255) NOT NULL,
        `values` mediumtext NOT NULL,
        `index` smallint(5) unsigned NOT NULL,
        PRIMARY KEY (`id`),
        KEY `document_id` (`document_id`)
    );
");

// Upgrading to v1.1.0
// adding column for sections container
$modx->db->query("ALTER TABLE $table ADD COLUMN container varchar(255) DEFAULT NULL AFTER document_id;", false);
$modx->db->query("ALTER TABLE $table DROP INDEX `document_id`;", false);
$modx->db->query("ALTER TABLE $table ADD INDEX `document_id` (`document_id`, `container`);", false);

// Adding visibility option
$modx->db->query("ALTER TABLE $table ADD COLUMN visible tinyint(1) unsigned DEFAULT 1 AFTER `values`;", false);

// Fix #51
$modx->db->query("UPDATE $table SET `container` = 'default' WHERE `container` IS NULL;", false);
$modx->db->query("UPDATE $table SET `config` = REPLACE(`config`, '.php', '') WHERE `config` REGEXP '\.php$';", false);

// Fix, default value for title
$modx->db->query("ALTER TABLE $table CHANGE `title` `title` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;", false);

// Subcontainers
$modx->db->query("ALTER TABLE $table DROP `title`;", false);
$modx->db->query("ALTER TABLE $table ADD COLUMN `parent_id` INT(10) UNSIGNED NOT NULL DEFAULT '0' AFTER `container`;", false);
$modx->db->query("ALTER TABLE $table ADD COLUMN `subcontainer` VARCHAR(255) NOT NULL DEFAULT '' AFTER `parent_id`;", false);
$modx->db->query("ALTER TABLE $table ADD COLUMN `hash` VARCHAR(255) NOT NULL DEFAULT '' AFTER `subcontainer`;", false);

// удаляем установщик
$tablePlugins      = $modx->getFullTablename('site_plugins');
$tablePluginEvents = $modx->getFullTablename('site_plugin_events');

$query = $modx->db->select('id', $tablePlugins, "`name` = '" . $modx->event->activePlugin . "'");

if ($id = $modx->db->getValue($query)) {
    $modx->db->delete($tablePlugins, "`id` = '$id'");
    $modx->db->delete($tablePluginEvents, "`pluginid` = '$id'");
}
