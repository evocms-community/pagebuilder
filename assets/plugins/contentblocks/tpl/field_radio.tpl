<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
	<? if ( !empty( $field['caption'] ) ) { ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<? } ?> 

	<? $random = md5( rand() ); ?>

	<div class="check-list layout-<?= $layout ?>">
		<? foreach ( $elements as $val => $title ) { ?> 
			<div class="check-row">
				<label><input type="radio" name="contentblocks_<?= $name ?>_<?= $random ?>" value="<?= $val ?>" <? if ( $val == $value ) { ?> checked<? } ?>><?= htmlentities( $title ) ?></label>
			</div>
		<? } ?> 
	</div>
</div>