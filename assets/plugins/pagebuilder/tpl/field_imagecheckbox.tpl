<div class="field type-<?= $field['type'] ?> image-toggle  <?= $layout ?>" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?> 

	<div class="check-list <?= $layout ?>-layout">
		<?php foreach ($elements as $val => $image): ?> 
			<div class="check-row">
				<label>
					<input type="checkbox" name="contentblocks_<?= $name ?>" value="<?= $val ?>" <?php if (in_array((string)$val, $value)) { ?> checked<?php } ?>>
					<span><img src="<?= $image ?>" style="max-width: 140px; max-height: 140px;"></span>
				</label>
			</div>
		<?php endforeach; ?> 
	</div>

    <?php if (!empty($field['note'])): ?> 
        <div class="field-note"><?= $field['note'] ?></div>
    <?php endif; ?>
</div>
