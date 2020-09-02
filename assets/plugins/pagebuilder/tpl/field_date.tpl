<div class="field type-<?= $field['type'] ?>  <?= $layout ?>" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?> 

	<?php $random = md5(rand()); ?>

	<input type="text" name="contentblocks_<?= $name ?>_<?= $random ?>" value="<?= htmlentities($value) ?>">
	<i class="fa fa-calendar"></i>

    <?php if (!empty($field['note'])): ?> 
        <div class="field-note"><?= $field['note'] ?></div>
    <?php endif; ?>
</div>