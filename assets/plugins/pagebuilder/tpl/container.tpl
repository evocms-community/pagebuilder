<div class="content-blocks<?php if (count($configs) < 2): ?> single<?php endif; ?>" data-add-type="<?= $container['addType'] ?>" data-container="<?= $name ?>" id="PB_<?= $container['alias'] ?>" data-formid="<?= $this->getCurrentFormId() ?>"<?php if (!empty($hash)): ?> data-hash="<?= $hash ?>"<?php endif; ?>>
    <?php if (!empty($caption)): ?>
        <div class="group-title">
            <?= $caption ?>
        </div>
    <?php endif; ?>

    <div class="change-type" style="display: none;">
        <?= $this->renderTpl('tpl/add_block_dropdown.tpl', ['configs' => $configs]); ?>
    </div>

    <?= $this->renderTpl('tpl/add_block.tpl', [
        'configs' => $configs,
        'type'    => $container['addType'],
    ]) ?>

    <?php $blocks = array_filter($blocks, function($block) use ($block_id, $name, $hash) {
        $containerName = $block_id ? $block['subcontainer'] : $block['container'];
        return $block['parent_id'] == $block_id && $containerName == $name && (empty($hash) || $hash == $block['hash']);
    }); ?>

    <?php foreach ($blocks as $block): ?>
        <?= $this->renderTpl('tpl/block.tpl', [
            'configs' => $configs,
            'block'   => $block,
            'addType' => [$container['addType']],
        ]); ?>
    <?php endforeach; ?>

    <?= $this->trigger('OnPBContainerRender', [
        'name'      => $name,
        'container' => $container,
        'configs'   => $configs,
        'blocks'    => $blocks,
    ]) ?>
</div>
