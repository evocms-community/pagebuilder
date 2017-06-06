<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
	<? if ( !empty( $field['caption'] ) ) { ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<? } ?> 
	<textarea name="contentblocks_<?= $name ?>" class="richtext"><?= htmlentities( $value ) ?></textarea>
</div>