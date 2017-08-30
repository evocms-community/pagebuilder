<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?> 
	<textarea name="contentblocks_<?= $name ?>" class="richtext"><?= htmlentities($value) ?></textarea>
</div>