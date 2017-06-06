<select name="available">
	<option value="">-- Выберите тип блока --</option>
	<? foreach ( $configs as $filename => $config ) { ?>
		<option value="<?= $filename ?>"><?= $config['title'] ?></option>
	<? } ?>
</select>
