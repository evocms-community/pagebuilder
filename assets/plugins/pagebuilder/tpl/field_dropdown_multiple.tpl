<div class="field type-<?= $field['type'] ?>  <?= $layout ?>" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?>
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?>

	<select name="contentblocks_<?= $name ?>" multiple size="10">
		<?php foreach ($elements as $val => $title): ?>
			<option value="<?= $val ?>" <?php if (in_array($val, $value)) { ?> selected<?php } ?>><?= htmlentities($title) ?></option>
		<?php endforeach; ?>
	</select>

    <?php if (!empty($field['note'])): ?>
        <div class="field-note"><?= $field['note'] ?></div>
    <?php endif; ?>
</div>
