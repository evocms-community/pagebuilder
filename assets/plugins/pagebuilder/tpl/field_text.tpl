<div class="field type-<?= $field['type'] ?>" data-field="<?= $name ?>">
    <?php if (!empty($field['caption'])): ?> 
        <div class="field-name"><?= $field['caption'] ?></div>
    <?php endif; ?> 
	<input type="text" name="contentblocks_<?= $name ?>" value="<?= htmlentities($value) ?>">
</div>