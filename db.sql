CREATE TABLE `sdc_pumpkinsmash_score` (
  `ident` VARCHAR(140) NOT NULL,
  `psmashed` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `sdc_pumpkinsmash_score`
  ADD PRIMARY KEY (`ident`)
;

CREATE TABLE `sdc_pumpkinsmash_users` (
  `ident` VARCHAR(140) NOT NULL,
  `name` VARCHAR(40) NOT NULL,
  `tcaught` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `sdc_pumpkinsmash_users`
  ADD PRIMARY KEY (`ident`)
;
