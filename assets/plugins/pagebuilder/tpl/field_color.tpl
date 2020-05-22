<div class="field type-<?= $field['type'] ?> uploadable" data-field="<?= $name ?>">
	<?php if (!empty($field['caption'])): ?> 
		<div class="field-name"><?= $field['caption'] ?></div>
	<?php endif; ?>
	<div>
		<input type="color" value="<?= htmlentities($value) ?>" onchange="document.getElementById('color_<?= $name ?>').value = this.value" style="float: left; margin-right: .5rem; height: 30px;"/> <input type="text" id="color_<?= $name ?>" value="<?= htmlentities($value) ?>" onchange="document.getElementById('color_<?= $name ?>').value = this.value" style="float: left; width: 5rem;" />
		<div style="clear:both;"></div>
	</div>
</div>
