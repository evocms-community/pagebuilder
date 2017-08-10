<link rel="stylesheet" href="../assets/plugins/pagebuilder/styles/styles.css?<?= $version ?>">
<script src="../assets/plugins/pagebuilder/js/jquery-ui.min.js"></script>
<script src="../assets/plugins/pagebuilder/js/interaction.js?<?= $version ?>"></script>

<? if ( $placement == 'tab' ) { ?>
	<div class="tab-page content-blocks-tab" style="width: 100%; -moz-box-sizing: border-box; box-sizing: border-box;">
		<h2 class="tab" id="contentblockstab"><?= $tabname ?></h2>
<? } ?>

	<div class="content-blocks-configs">
		<? foreach ( $configs as $filename => $config ) { ?> 
			<?= $instance->renderTpl( 'tpl/block.tpl', [ 
				'configs' => $configs, 
				'block'   => [ 'config' => $filename ],
				'type'    => $addType,
			] ); ?> 
		<? } ?>
	</div>
	
	<div class="content-blocks" id="content-blocks">
		<?= $instance->renderTpl( 'tpl/add_block.tpl', [
			'configs' => $configs,
			'type'    => $addType,
		] ) ?>

		<? foreach ( $blocks as $block ) { ?> 
			<?= $instance->renderTpl( 'tpl/block.tpl', [ 
				'configs' => $configs, 
				'block'   => $block,
				'type'    => $addType,
			] ); ?> 
		<? } ?> 
	</div>

<? if ( $placement == 'tab' ) { ?>
	</div>
<? } ?>

<? foreach ( $instance->themes as $theme ) { ?> 
	<?= $theme ?> 
<? } ?> 

<script>
	<? if ( $placement == 'content' ) { ?>
		jQuery('#content-blocks').insertAfter( jQuery('#content_body').closest('table') );
	<? } ?>

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