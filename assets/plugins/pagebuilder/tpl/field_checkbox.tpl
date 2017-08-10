<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
	<? if ( !empty( $field['caption'] ) ) { ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<? } ?> 

	<div class="check-list layout-<?= $layout ?>">
		<? foreach ( $elements as $val => $title ) { ?> 
			<div class="check-row">
				<label><input type="checkbox" name="contentblocks_<?= $name ?>" value="<?= $val ?>" <? if ( in_array( $val, $value ) ) { ?> checked<? } ?>><?= htmlentities( $title ) ?></label>
			</div>
		<? } ?> 
	</div>
</div>