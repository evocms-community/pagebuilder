<div class="field fields-group" data-field="<?= $name ?>">
	<div class="group-title">
		<?= $field['caption'] ?> 
	</div>

	<div class="sortable-list">
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