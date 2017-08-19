<?php if ($container['placement'] == 'tab'): ?>
    <div class="tab-page content-blocks-tab add-type-<?= $container['addType'] ?>">
        <h2 class="tab"><?= $container['title'] ?></h2>
<?php else: ?>
    <div class="content-blocks-container add-type-<?= !empty($container['addType']) ? $container['addType'] : 'dropdown' ?>" id="cb-<?= $name ?>">
        <h4 class="container-title"><?= $container['title'] ?></h4>
<?php endif; ?>

    <div class="content-blocks">
        <?= $this->renderTpl('tpl/add_block.tpl', [
            'configs' => $configs,
        ]) ?>

        <?php foreach ($blocks as $block): ?> 
            <?php if ($block['container'] == $name): ?>
                <?= $this->renderTpl( 'tpl/block.tpl', [ 
                    'configs' => $configs, 
                    'block'   => $block,
                ] ); ?> 
            <?php endif; ?>
        <?php endforeach; ?> 
    </div>
</div>

<?php if ($container['placement'] == 'content'): ?>
    <script>
        jQuery('#cb-<?= $name ?>').insertAfter(jQuery('#content_body').closest('table'));
    </script>
<?php endif; ?>
