<div class="block" data-config="<?= $block['config'] ?>">
	<div class="block-inner">
		<div class="change-type">
			<?= $this->renderTpl('tpl/add_block_dropdown.tpl', ['configs' => $configs]); ?>

			<label class="visible">
				<input type="checkbox" name="visible[]" value="1"<?php if (!(isset($block['visible']) && $block['visible'] == 0)): ?> checked<?php endif; ?>>
				<?= $l['Visible'] ?>
			</label>
		</div>

		<?php if (!empty($block['id'])): ?>
			<input type="hidden" name="contentblocks_id" value="<?= $block['id'] ?>">
		<?php endif; ?>

		<div class="controls">
			<a href="#" class="moveup" title="<?= $l['Move up'] ?>"><i class="fa fa-chevron-up"></i></a>
			<a href="#" class="movedown" title="<?= $l['Move down'] ?>"><i class="fa fa-chevron-down"></i></a>
			<a href="#" class="remove" title="<?= $l['Delete block'] ?>"><i class="fa fa-times-circle"></i></a>
		</div>

		<div class="fields-list">
			<?php if (!isset($configs[$block['config']]['fields'])): ?>
				<div class="field">
					<b><?= $configs[$block['config']]['title'] ?></b><br>
					<i><?= $l['No fields provided in this block'] ?></i>
				</div>
			<?php else: ?>
				<?php foreach ($configs[$block['config']]['fields'] as $name => $field): ?>
					<?= $this->renderField($field, $name, isset($block['values'][$name]) ? $block['values'][$name] : null); ?>
				<?php endforeach; ?>
			<?php endif; ?>
		</div>

		<div class="controls controls-bottom">
			<a href="#" class="insert" title="<?= $l['Insert block'] ?>"><i class="fa fa-plus-circle"></i></a>
		</div>
	</div>

	<?php foreach ($addType as $type): ?>
		<?= $this->renderTpl('tpl/add_block.tpl', [
			'configs' => $configs,
			'type'    => $type,
		]) ?>
	<?php endforeach; ?>
</div>
