<select name="available">
	<option value="">-- <?= $l['Select type of block'] ?> --</option>
	<? foreach ( $configs as $filename => $config ) { ?>
		<option value="<?= $filename ?>"><?= $config['title'] ?></option>
	<? } ?>
</select>
