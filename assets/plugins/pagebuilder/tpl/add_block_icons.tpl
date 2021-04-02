<div class="trigger">
    <a href="#" class="fa fa-plus-circle" title="<?= $l['Add block'] ?>"></a>
</div>

<div class="add-block-icons">
    <div class="title">
        <?= $l['Select type of block'] ?>
    </div>

    <div class="icons-list">
        <?php foreach ($configs as $filename => $config): ?>
            <div class="icon-wrapper">
                <?php if ($type == 'images' && isset($config['image'])): ?>
                    <i class="fa fa-search" onclick="window.open('<?= $this->modx->getConfig('base_url') ?><?= $config['image']?>', 'popup', 'status=no,location=no,toolbar=no,menubar=no');"></i>
                <?php endif; ?>
                <a href="#" data-config="<?= $filename ?>" title="<?= $config['title'] ?>">
                    <span class="icon">
                        <?php if ($type == 'images' && isset($config['image'])): ?>
                            <img src="../<?= $this->modx->runSnippet('phpthumb', ['input' => $config['image'], 'options' => 'w=160,h=120']) ?>" alt="">
                        <?php elseif ($type == 'icons' && isset($config['icon'])): ?>
                            <i class="<?= $config['icon'] ?>"></i>
                        <?php endif; ?>
                    </span>

                    <?= $config['title'] ?>
                </a>
            </div>
        <?php endforeach; ?>
    </div>
</div>