<div class="field fields-group" data-field="<?= $name ?>">
	<div class="group-title">
		<?= $field['caption'] ?>

		<div class="btn-group">
			<a href="#" class="btn btn-secondary toggle-group"><?= $l['Show group items'] ?></a>
		</div>
	</div>

	<div class="sortable-list<?= count($values) > 1 ? ' collapsed' : '' ?><?= !empty($field['layout']) ? ' ' . $field['layout'] . '-layout' : '' ?>">
		<?php foreach ($values as $i => $value): ?> 
			<div class="sortable-item<?= !$i ? ' hidden' : '' ?>">
				<div class="handle"></div>

				<div class="fields-list<?= !$i ? ' hidden' : '' ?>">
					<?php foreach ($field['fields'] as $child => $childfield): ?> 
						<?= $this->renderField($childfield, $child, isset($value[$child]) ? $value[$child] : null) ?> 
					<?php endforeach; ?> 
				</div>

				<div class="controls">
					<a href="#" class="remove" title="<?= $l['Delete element'] ?>"><i class="fa fa-minus-circle"></i></a>
					<a href="#" class="insert" title="<?= $l['Insert element'] ?>"><i class="fa fa-plus-circle"></i></a>
				</div>
			</div>
		<?php endforeach; ?> 
	</div>
</div>