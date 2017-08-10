<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
	<? if ( !empty( $field['caption'] ) ) { ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<? } ?> 

	<? $random = md5( rand() ); ?>

	<input type="text" name="contentblocks_<?= $name ?>_<?= $random ?>" value="<?= htmlentities( $value ) ?>">
	<i class="fa fa-calendar"></i>
</div>