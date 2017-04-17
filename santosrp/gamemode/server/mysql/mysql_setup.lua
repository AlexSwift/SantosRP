local function initDB()
	GAMEMODE.Database = assert(mysql.New{
		Host = "198.27.74.181",
		User = "santosrp",
		Pass = "A$fj1x6E3Tm#",
		Name = "santosrp"
	}, "Couldn't connect to database! Retrying in 5..")
	if not GAMEMODE.Database then timer.Simple(5, initDB) return end

	hook.Add("Tick", "MySQLPoll", mysql.Poll)

	hook.Call("postDatabaseConnected") --godlike
	hook.Call("postDatbaseBaseTablesCreated")
	hook.Call("postDatabaseTablesCreated")
	
	santosRP.Items.LoadItems()
	santosRP.Vehicles.LoadVehicles( CarList )
	
end
hook.Add("Initialize", "InitMySQL", initDB)

hook.Add("postDatabaseConnected","CreateBaseTables", function()
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`steamid` BIGINT UNSIGNED NOT NULL COMMENT 'this hold all players that ever joined and assigns them an id',
			PRIMARY KEY (`id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			UNIQUE INDEX `steamid_UNIQUE` (`steamid` ASC))
		ENGINE = InnoDB;
	]]

	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`item` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`name` VARCHAR(100) NOT NULL,
			UNIQUE INDEX `name_UNIQUE` (`name` ASC),
			PRIMARY KEY (`id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC))
		ENGINE = InnoDB;
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`vehicle` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`name` VARCHAR(100) NOT NULL,
			UNIQUE INDEX `name_UNIQUE` (`name` ASC),
			PRIMARY KEY (`id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC))
		ENGINE = InnoDB;
	]]

	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_info` (
			`player_id` INT NOT NULL,
			`rpname` VARCHAR(25) NULL,
			`money` BIGINT UNSIGNED NOT NULL,
			`bank_money` BIGINT NOT NULL,
			`model` VARCHAR(100) NULL,
			`color` VARCHAR(15) NULL,
			PRIMARY KEY (`player_id`),
			UNIQUE INDEX `player_id_UNIQUE` (`player_id` ASC),
		  	CONSTRAINT `fk_player_info_player1`
				FOREIGN KEY (`player_id`)
		    	REFERENCES `santosrp`.`player` (`id`)
		    	ON DELETE NO ACTION
		    	ON UPDATE NO ACTION)
		ENGINE = InnoDB;
	]]

	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_inventory` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`player_id` INT NOT NULL,
			`item_id` INT NOT NULL,
			`slot` INT NOT NULL,
			`amount` INT NOT NULL,
			PRIMARY KEY (`id`, `item_id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_inventory_items1_idx` (`item_id` ASC),
			INDEX `fk_player_inventory_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_inventory_items1`
				FOREIGN KEY (`item_id`)
				REFERENCES `santosrp`.`item` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION,
			CONSTRAINT `fk_player_inventory_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_vehicles` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`player_id` INT NOT NULL,
			`vehicle_id` INT NOT NULL,
			PRIMARY KEY (`id`, `vehicle_id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_vehicles_vehicle1_idx` (`vehicle_id` ASC),
			INDEX `fk_player_vehicles_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_vehicles_vehicles1`
				FOREIGN KEY (`vehicle_id`)
				REFERENCES `santosrp`.`vehicle` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION,
			CONSTRAINT `fk_player_vehicles_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_clothing` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`player_id` INT NOT NULL,
			`item_id` INT NOT NULL,
			PRIMARY KEY (`id`, `item_id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_clothing_items1_idx` (`item_id` ASC),
			INDEX `fk_player_clothing_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_clothing_items1`
				FOREIGN KEY (`item_id`)
				REFERENCES `santosrp`.`item` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION,
			CONSTRAINT `fk_player_clothing_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_skills` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`player_id` INT NOT NULL,
			`skills` INT NOT NULL,
			PRIMARY KEY (`id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_skills_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_skills_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `SantosRP_Organizations` (
  		`idx` varchar(255) NOT NULL,
  		`pass` text,
  		`players` text,
  		PRIMARY KEY (`idx`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;
	]]
end)

concommand.Add( 'santosrp_mysql_createall', function()

	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`steamid` BIGINT UNSIGNED NOT NULL COMMENT 'this hold all players that ever joined and assigns them an id',
			PRIMARY KEY (`id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			UNIQUE INDEX `steamid_UNIQUE` (`steamid` ASC))
		ENGINE = InnoDB;
	]]

	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`item` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`name` VARCHAR(100) NOT NULL,
			UNIQUE INDEX `name_UNIQUE` (`name` ASC),
			PRIMARY KEY (`id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC))
		ENGINE = InnoDB;
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`vehicle` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`name` VARCHAR(100) NOT NULL,
			UNIQUE INDEX `name_UNIQUE` (`name` ASC),
			PRIMARY KEY (`id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC))
		ENGINE = InnoDB;
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_info` (
			`player_id` INT NOT NULL,
			`rpname` VARCHAR(25) NULL,
			`money` BIGINT UNSIGNED NOT NULL,
			`bank_money` BIGINT NOT NULL,
			`model` VARCHAR(100) NULL,
			`color` VARCHAR(15) NULL,
			PRIMARY KEY (`player_id`),
			UNIQUE INDEX `player_id_UNIQUE` (`player_id` ASC),
		  	CONSTRAINT `fk_player_info_player1`
				FOREIGN KEY (`player_id`)
		    	REFERENCES `santosrp`.`player` (`id`)
		    	ON DELETE NO ACTION
		    	ON UPDATE NO ACTION)
		ENGINE = InnoDB;
	]]

	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_inventory` (
			`id` INT NOT NULL,
			`player_id` INT NOT NULL,
			`item_id` INT NOT NULL,
			`amount` INT NOT NULL,
			PRIMARY KEY (`id`, `item_id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_inventory_items1_idx` (`item_id` ASC),
			INDEX `fk_player_inventory_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_inventory_items1`
				FOREIGN KEY (`item_id`)
				REFERENCES `santosrp`.`item` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION,
			CONSTRAINT `fk_player_inventory_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_vehicles` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`player_id` INT NOT NULL,
			`vehicle_id` INT NOT NULL,
			PRIMARY KEY (`id`, `vehicle_id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_vehicles_vehicle1_idx` (`vehicle_id` ASC),
			INDEX `fk_player_vehicles_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_vehicles_vehicles1`
				FOREIGN KEY (`vehicle_id`)
				REFERENCES `santosrp`.`vehicle` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION,
			CONSTRAINT `fk_player_vehicles_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_clothing` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`player_id` INT NOT NULL,
			`item_id` INT NOT NULL,
			PRIMARY KEY (`id`, `item_id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_vehicles_item1_idx` (`item_id` ASC),
			INDEX `fk_player_vehicles_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_vehicles_item1`
				FOREIGN KEY (`item_id`)
				REFERENCES `santosrp`.`item` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION,
			CONSTRAINT `fk_player_vehicles_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]
	
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`player_skills` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`player_id` INT NOT NULL,
			`skills` INT NOT NULL,
			PRIMARY KEY (`id`, `player_id`),
			UNIQUE INDEX `id_UNIQUE` (`id` ASC),
			INDEX `fk_player_skills_players1_idx` (`player_id` ASC),
			CONSTRAINT `fk_player_skills_players1`
				FOREIGN KEY (`player_id`)
				REFERENCES `santosrp`.`player` (`id`)
				ON DELETE NO ACTION
				ON UPDATE NO ACTION)
		ENGINE = InnoDB
	]]

	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `SantosRP_Organizations` (
  		`idx` varchar(255) NOT NULL,
  		`pass` text,
  		`players` text,
  		PRIMARY KEY (`idx`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;
	]]

end)

concommand.Add( 'santosrp_mysql_dropall' , function( )
	if not santosRP.isBeta then return end
	GAMEMODE.Database:RawQuery [[ DROP TABLE `santosrp`.`SantosRP_Organizations`, `santosrp`.`player_inventory`, `santosrp`.`player_vehicles`, `santosrp`.`player_info`;]]
	GAMEMODE.Database:RawQuery [[ DROP TABLE `santosrp`.`item`, `santosrp`.`vehicle`, `santosrp`.`player`;]]
end)