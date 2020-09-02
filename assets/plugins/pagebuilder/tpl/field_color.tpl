<div class="field type-<?= $field['type'] ?> <?= $layout ?>" data-field="<?= $name ?>">
    <?php if (!empty($field['caption'])): ?> 
        <div class="field-name"><?= $field['caption'] ?></div>
    <?php endif; ?>
    <input type="color" value="<?= htmlentities($value) ?>" onchange="this.nextElementSibling.value = this.value" style="float: left; margin-right: .5rem; width: 30px; height: 30px;"/>
    <input type="text" value="<?= htmlentities($value) ?>" onchange="this.previousElementSibling.value = this.value" style="float: left; width: 5rem;" />
    <div style="clear:both;"></div>
</div>
