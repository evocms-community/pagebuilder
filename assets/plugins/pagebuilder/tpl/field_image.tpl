<div class="field type-<?= $field['type'] ?> uploadable  <?= $layout ?>" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?> 

	<div class="preview"></div>
	<input type="button" class="open-browser btn btn-secondary" value="<?= $l['Choose'] ?>"><input type="text" name="contentblocks_<?= $name ?>" value="<?= htmlentities($value) ?>">

    <?php if (!empty($field['note'])): ?> 
        <div class="field-note"><?= $field['note'] ?></div>
    <?php endif; ?>
</div>