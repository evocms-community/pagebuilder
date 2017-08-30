<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?> 

	<select name="contentblocks_<?= $name ?>">
		<?php foreach ($elements as $val => $title): ?> 
			<option value="<?= $val ?>" <?php if ($val == $value) { ?> selected<?php } ?>><?= htmlentities($title) ?></option>
		<?php endforeach; ?> 
	</select>
</div>