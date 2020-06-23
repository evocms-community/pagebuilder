<?php if ($container['placement'] == 'tab'): ?>
    <div class="tab-page content-blocks-tab" id="tabPB_<?= $container['alias'] ?>">
        <h2 class="tab"><?= $container['title'] ?></h2>
<?php else: ?>
    <div class="content-blocks-container" id="contentPB_<?= $container['alias'] ?>">
        <?php if ($container['placement'] == 'content'): ?>
            <h4 class="container-title"><?= $container['title'] ?></h4>
        <?php endif; ?>
<?php endif; ?>

    <div class="content-blocks<?php if (count($configs) < 2): ?> single<?php endif; ?>" data-add-type="<?= $container['addType'] ?>" data-container="<?= $name ?>" id="PB_<?= $container['alias'] ?>" data-formid="<?= $formid ?>">
        <div class="btn-group">
            <a href="#" class="btn btn-secondary export"><?= $l['Export'] ?></a>
            <label href="#" class="btn btn-secondary import"><input type="file" name="import-file"><?= $l['Import'] ?></label>
        </div>

        <div class="change-type" style="display: none;">
            <?= $this->renderTpl('tpl/add_block_dropdown.tpl', ['configs' => $configs]); ?>
        </div>

        <?= $this->renderTpl('tpl/add_block.tpl', [
            'configs' => $configs,
            'type'    => $container['addType'],
        ]) ?>

        <?php foreach ($blocks as $block): ?>
            <?php if ($block['container'] == $name): ?>
                <?= $this->renderTpl('tpl/block.tpl', [
                    'configs' => $configs, 
                    'block'   => $block,
                    'addType' => [$container['addType']],
                ]); ?> 
            <?php endif; ?>
        <?php endforeach; ?>

        <?= $this->trigger('OnPBContainerRender', [
            'name'      => $name,
            'container' => $container,
            'configs'   => $configs,
            'blocks'    => $blocks,
        ]) ?>
    </div>

    <table></table>
</div>

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
