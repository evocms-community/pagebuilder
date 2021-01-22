<div class="field type-<?= $field['type'] ?> <?= $layout ?>" data-field="<?= $name ?>">
    <?php if (!empty($field['caption'])): ?>
        <div class="field-name"><?= $field['caption'] ?></div>
    <?php endif; ?>

    <div class="check-list>
        <?php foreach ($elements as $val => $title): ?>
            <div class="check-row">
                <label><input type="checkbox" name="contentblocks_<?= $name ?>" value="<?= $val ?>" <?php if (in_array($val, $value)) { ?> checked<?php } ?>><?= htmlentities($title) ?></label>
            </div>
        <?php endforeach; ?>
    </div>

    <?php if (!empty($field['note'])): ?>
        <div class="field-note"><?= $field['note'] ?></div>
    <?php endif; ?>
</div>
