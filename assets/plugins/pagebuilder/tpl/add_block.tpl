<div class="add-block">
    <? if ( $type == 'icons' || $type == 'images' ) { ?>
        <?= $instance->renderTpl( 'tpl/add_block_icons.tpl', [ 'configs' => $configs, 'type' => $type ] ); ?> 
    <? } else { ?>
        <?= $instance->renderTpl( 'tpl/add_block_dropdown.tpl', [ 'configs' => $configs ] ); ?> 
        
        <a href="#" class="dropdown-add-block" title="<?= $l['Add block'] ?>">
            <i class="fa fa-plus-circle"></i>
        </a>
    <? } ?>
</div>