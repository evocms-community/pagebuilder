<link rel="stylesheet" href="../assets/plugins/pagebuilder/styles/styles.css?<?= $version ?>">
<script src="../assets/plugins/pagebuilder/js/jquery-ui.min.js"></script>
<script src="../assets/plugins/pagebuilder/js/interaction.js?<?= $version ?>"></script>

<?php $formid = md5(rand()); ?>

<div class="content-blocks-configs" data-formid="<?= $formid ?>">
	<?php foreach ($configs as $filename => $config): ?> 
		<?= $this->renderTpl('tpl/block.tpl', [ 
			'configs' => $configs, 
			'block'   => ['config' => $filename],
			'addType' => [],
		]) ?> 
	<?php endforeach; ?>
</div>

<?php $names = []; ?>

<?php foreach ($containers as $name => $container): ?>
	<?= $this->renderTpl('tpl/container.tpl', [
		'name'      => $name,
		'container' => $container,
		'formid'    => $formid,
		'blocks'    => array_filter($blocks, function($block) use ($container) {
            return in_array($block['config'], $container['sections']);
        }),
		'configs'   => array_filter($configs, function($key) use ($container) {
            return in_array($key, $container['sections']);
        }, ARRAY_FILTER_USE_KEY),
	]) ?>

	<?php $names[] = '#PB_' . $container['alias']; ?>
<?php endforeach; ?>

<?php foreach ($this->themes as $theme): ?> 
	<?= $theme ?> 
<?php endforeach; ?> 

<script>
	jQuery( function() {
		initcontentblocks( {
			containers: jQuery('<?= implode(', ', $names) ?>'), 
			values: <?= !empty($block) ? json_encode( $block, JSON_UNESCAPED_UNICODE ) : "{}" ?>, 
			config: <?= !empty($configs) ? json_encode( $configs, JSON_UNESCAPED_UNICODE ) : "{}" ?>,
			lang: <?= !empty($l) ? json_encode( $l, JSON_UNESCAPED_UNICODE ) : "{}" ?>,
			browser: "<?= $browseurl ?>",
			thumbsDir: "<?= $thumbsDir ?>",
			picker: {
				yearOffset: <?= $picker['yearOffset'] ?>,
				format: '<?= $picker['format'] ?>',
				dayNames: <?= $adminlang['dp_dayNames'] ?>,
				monthNames: <?= $adminlang['dp_monthNames'] ?>,
				startDay: <?= $adminlang['dp_startDay'] ?>,
			}
		} );
	} );
</script>