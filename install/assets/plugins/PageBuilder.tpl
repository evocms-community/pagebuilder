//<?php
/**
 * PageBuilder
 * 
 * Creates form for manage content sections
 *
 * @category    plugin
 * @version     1.3.2
 * @author      mnoskov
 * @internal    @properties &tabName=Tab name;text;Page Builder &addType=Add type;menu;dropdown,icons,images;dropdown &placement=Placement;menu;content,tab;tab &order=Default container ordering;text;0
 * @internal    @events OnWebPageInit,OnManagerPageInit,OnDocFormRender,OnDocFormSave,OnBeforeEmptyTrash,OnDocDuplicate 
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base,sample
 */

include_once MODX_BASE_PATH . 'assets/plugins/pagebuilder/pagebuilder.php';

$e = &$modx->event;

switch ($e->name) {
    case 'OnWebPageInit':
    case 'OnManagerPageInit': {
        $modx->db->query("DELETE FROM " . $modx->getFullTableName('site_plugin_events') . "
            WHERE pluginid IN (
               SELECT id
               FROM " . $modx->getFullTableName('site_plugins') . "
               WHERE name = '" . $e->activePlugin . "'
               AND disabled = 0
            )
            AND evtid IN (
               SELECT id
               FROM " . $modx->getFullTableName('system_eventnames') . "
               WHERE name IN ('OnWebPageInit', 'OnManagerPageInit')
            )");

        $modx->clearCache('full');

        (new PageBuilder($modx))->install();

        return;
    }

    case 'OnDocFormRender': {
        $e->output((new PageBuilder($modx))->renderForm());
        return;
    }

    case 'OnDocFormSave': {
        (new PageBuilder($modx))->save();
        return;
    }

    case 'OnBeforeEmptyTrash': {
        (new PageBuilder($modx))->delete();
        return;
    }

    case 'OnDocDuplicate': {
        (new PageBuilder($modx))->duplicate();
        return;
    }
}


