<link rel="stylesheet" href="/assets/plugins/contentblocks/styles/styles.css?<?= $version ?>">
<script src="/assets/plugins/contentblocks/js/jquery-ui.min.js"></script>
<script src="/assets/plugins/contentblocks/js/interaction.js?<?= $version ?>"></script>

<div class="tab-page" style="width: 100%; -moz-box-sizing: border-box; box-sizing: border-box;">
	<h2 class="tab" id="contentblockstab"><?= $tabname ?></h2>

	<div class="content-blocks-configs">
		<? foreach ( $configs as $filename => $config ) { ?> 
			<?= $instance->renderTpl( 'tpl/block.tpl', [ 
				'configs' => $configs, 
				'block'   => [ 'config' => $filename ],
			] ); ?> 
		<? } ?>
	</div>
	
	<div class="content-blocks" id="content-blocks">
		<div class="add-block">
			<?= $instance->renderTpl( 'tpl/configs_dropdown.tpl', [ 'configs' => $configs ] ); ?> 
			<input type="button" value="<?= $l['Add block'] ?>">
		</div>
		<? foreach ( $blocks as $block ) { ?> 
			<?= $instance->renderTpl( 'tpl/block.tpl', [ 
				'configs' => $configs, 
				'block'   => $block,
			] ); ?> 
		<? } ?> 
	</div>
</div>

<? foreach ( $instance->themes as $theme ) { ?> 
	<?= $theme ?> 
<? } ?> 

<script>
	jQuery( function() {
		initcontentblocks( {
			container: document.getElementById( "content-blocks" ), 
			values: <?= json_encode( $block, JSON_UNESCAPED_UNICODE ) ?>, 
			config: <?= json_encode( $configs, JSON_UNESCAPED_UNICODE ) ?>,
			lang: <?= json_encode( $l, JSON_UNESCAPED_UNICODE ) ?>,
			browser: "<?= $browseurl ?>",
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