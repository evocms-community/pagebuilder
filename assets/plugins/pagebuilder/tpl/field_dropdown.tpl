<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
	<? if ( !empty( $field['caption'] ) ) { ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<? } ?> 

	<select name="contentblocks_<?= $name ?>">
		<? foreach ( $elements as $val => $title ) { ?> 
			<option value="<?= $val ?>" <? if ( $val == $value ) { ?> selected<? } ?>><?= htmlentities( $title ) ?></option>
		<? } ?> 
	</select>
</div>