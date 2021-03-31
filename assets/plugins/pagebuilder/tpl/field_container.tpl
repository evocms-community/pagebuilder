<div class="field field-container <?= $layout ?>" data-field="<?= $name ?>">
    <?= $this->renderTpl('tpl/container.tpl', [
        'caption'   => $field['caption'],
        'block_id'  => $block['id'],
        'hash'      => $hash ?: '',
        'name'      => $name,
        'alias'     => $name,
        'configs'   => $this->conf,
        'blocks'    => $this->data,
        'blocks'    => $this->data,
        'container' => $container,
    ]); ?>
</div>
