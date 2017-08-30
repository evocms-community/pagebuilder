<div class="field type-<?= $field['type'] ?> uploadable" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?> 
	<input type="button" class="open-browser" value="<?= $l['Choose'] ?>"><input type="text" name="contentblocks_<?= $name ?>" value="<?= htmlentities($value) ?>">
</div>