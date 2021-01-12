<link rel="stylesheet" href="../assets/plugins/pagebuilder/styles/styles.css?<?= $version ?>">
<script src="../assets/plugins/pagebuilder/js/jquery-ui.min.js"></script>
<script src="../assets/plugins/pagebuilder/js/interaction.js?<?= $version ?>"></script>

<div class="content-blocks-configs" data-formid="<?= $this->getCurrentFormId() ?>">
    <?php foreach ($configs as $filename => $config): ?>
        <?= $this->renderTpl('tpl/block.tpl', [
            'configs' => $configs,
            'block'   => ['config' => $filename],
            'addType' => [],
        ]) ?>
    <?php endforeach; ?>
</div>

<?php $names = []; ?>

<?php $containers = array_filter($containers, function($container) {
    return empty($container['isSub']);
}); ?>

<?php foreach ($containers as $name => $container): ?>
    <?php if ($container['placement'] == 'tab'): ?>
        <div class="tab-page content-blocks-tab" id="tabPB_<?= $container['alias'] ?>">
            <h2 class="tab"><?= $container['title'] ?></h2>
    <?php else: ?>
        <div class="content-blocks-container" id="contentPB_<?= $container['alias'] ?>">
            <?php if ($container['placement'] == 'content'): ?>
                <h4 class="container-title"><?= $container['title'] ?></h4>
            <?php endif; ?>
    <?php endif; ?>

        <div class="btn-group content-blocks-exchange-controls">
            <a href="#" class="btn btn-secondary export"><?= $l['Export'] ?></a>
            <label href="#" class="btn btn-secondary import"><input type="file" name="import-file"><?= $l['Import'] ?></label>
        </div>

        <?= $this->renderTpl('tpl/container.tpl', [
            'block_id'  => 0,
            'name'      => $name,
            'container' => $container,
            'blocks'    => array_filter($blocks, function($block) use ($container) {
                return in_array($block['config'], $container['sections']);
            }),
            'configs'   => $configs,
        ]) ?>
    </div>

    <table></table>

    <script>
        <?php if ($container['placement'] == 'content'): ?>
            var $element = jQuery('#content_body').closest('table'),
                $containers = $element.nextAll('.content-blocks-container');

            if ($containers.length) {
                $element = $containers.last();
            }

            jQuery('#contentPB_<?= $container['alias'] ?>').insertAfter($element);
        <?php elseif ($container['placement'] == 'tab'): ?>
            tpSettings.addTabPage(jQuery('#tabPB_<?= $container['alias'] ?>').get(0));
        <?php endif; ?>
    </script>

    <?php $names[] = '#PB_' . $container['alias']; ?>
<?php endforeach; ?>

<?php foreach ($this->themes as $theme): ?>
    <?= $theme ?>
<?php endforeach; ?>

<script>
    jQuery(function() {
        initcontentblocks({
            containers: jQuery('<?= implode(', ', $names) ?>'),
            values:     <?= json_encode($block, JSON_UNESCAPED_UNICODE) ?>,
            config:     <?= json_encode($configs, JSON_UNESCAPED_UNICODE) ?>,
            relations:  <?= json_encode($relations, JSON_UNESCAPED_UNICODE) ?>,
            lang:       <?= json_encode($l, JSON_UNESCAPED_UNICODE) ?>,
            browser:    "<?= $browseurl ?>",
            thumbsDir:  "<?= $thumbsDir ?>",
            picker: {
                yearOffset: <?= $picker['yearOffset'] ?>,
                format:     '<?= $picker['format'] ?>',
                dayNames:   <?= $adminlang['dp_dayNames'] ?>,
                monthNames: <?= $adminlang['dp_monthNames'] ?>,
                startDay:   <?= $adminlang['dp_startDay'] ?>,
            }
        });
    });
</script>
