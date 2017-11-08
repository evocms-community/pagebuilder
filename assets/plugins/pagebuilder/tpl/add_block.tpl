<div class="add-block" data-type="<?= $type ?>">
    <?php if ($type == 'icons' || $type == 'images'): ?>
        <?= $this->renderTpl('tpl/add_block_icons.tpl', ['configs' => $configs, 'type' => $type]); ?> 
    <?php else: ?>
        <?= $this->renderTpl('tpl/add_block_dropdown.tpl', ['configs' => $configs]); ?> 
        
        <a href="#" class="dropdown-add-block" title="<?= $l['Add block'] ?>">
            <i class="fa fa-plus-circle"></i>
        </a>
    <?php endif; ?>
</div>