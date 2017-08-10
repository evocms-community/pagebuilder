<div class="trigger">
    <a href="#" class="fa fa-plus-circle" title="<?= $l['Add block'] ?>"></a>
</div>

<div class="add-block-icons">
    <div class="title">
        <?= $l['Select type of block'] ?>
    </div>

    <? foreach ( $configs as $filename => $config ) { ?>
        <a href="#" data-config="<?= $filename ?>" title="<?= $config['title'] ?>">
            <span class="icon">
                <? if ( $type == 'images' && isset( $config['image'] ) ) { ?>
                    <img src="../<?= $instance->modx->runSnippet( 'phpthumb', [ 'input' => $config['image'], 'options' => 'w=80,h=60' ] ) ?>" alt="">
                <? } else if ( $type == 'icons' && isset( $config['icon'] ) ) { ?>
                    <i class="<?= $config['icon'] ?>"></i>
                <? } ?>
            </span>

            <?= $config['title'] ?>
        </a>
    <? } ?>
</div>