<select name="available">
	<option value="">-- <?= $l['Select type of block'] ?> --</option>
	<?php foreach ($configs as $filename => $config): ?>
		<option value="<?= $filename ?>"><?= $config['title'] ?></option>
	<?php endforeach; ?>
</select>
