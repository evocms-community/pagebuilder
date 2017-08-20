<?php if ($container['placement'] == 'tab'): ?>
    <div class="tab-page content-blocks-tab">
        <h2 class="tab"><?= $container['title'] ?></h2>
<?php else: ?>
    <div class="content-blocks-container" id="cb-<?= $name ?>">
        <h4 class="container-title"><?= $container['title'] ?></h4>
<?php endif; ?>

    <div class="content-blocks" data-add-type="<?= $container['addType'] ?>" data-container="<?= $name ?>">
        <div class="change-type" style="display: none;">
            <?= $this->renderTpl( 'tpl/add_block_dropdown.tpl', [ 'configs' => $configs ] ); ?>
        </div>

        <?= $this->renderTpl('tpl/add_block.tpl', [
            'configs' => $configs,
            'type'    => $container['addType'],
        ]) ?>

        <?php foreach ($blocks as $block): ?>
            <?php if ($block['container'] == $name): ?>
                <?= $this->renderTpl( 'tpl/block.tpl', [
                    'configs' => $configs, 
                    'block'   => $block,
                    'addType' => [$container['addType']],
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
