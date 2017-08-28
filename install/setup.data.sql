CREATE TABLE IF NOT EXISTS `{PREFIX}pagebuilder` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `config` varchar(255) NOT NULL,
  `values` mediumtext NOT NULL,
  `index` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`,`instance`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;


# Upgrading to v1.0.0 - adding column for sections container

ALTER TABLE {PREFIX}pagebuilder ADD COLUMN container varchar(255) DEFAULT NULL AFTER document_id;

