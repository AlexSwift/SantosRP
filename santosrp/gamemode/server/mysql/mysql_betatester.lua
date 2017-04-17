if not santosRP.isBeta then return end

local should_load = false

if santosRP.WhiteList then
	should_load = true
end

santosRP.WhiteList = santosRP.WhiteList or {}
santosRP.WhiteList.players = santosRP.WhiteList.players or {}

function santosRP.WhiteList.LoadBetaTesters()
	GAMEMODE.Database:RawQuery[[
		CREATE TABLE IF NOT EXISTS `santosrp`.`betatesters` (
			`steamid64` BIGINT UNSIGNED NOT NULL,
			PRIMARY KEY (`steamid64`),
  			UNIQUE INDEX `player_id_UNIQUE` (`steamid64` ASC))
		ENGINE = InnoDB;
	]]
	
	GAMEMODE.Database:RawQuery[[
		INSERT IGNORE INTO `santosrp`.`betatesters` ( steamid64 ) VALUES ( 76561198062956686 );
		INSERT IGNORE INTO `santosrp`.`betatesters` ( steamid64 ) VALUES ( 76561198021109934 );
		INSERT IGNORE INTO `santosrp`.`betatesters` ( steamid64 ) VALUES ( 76561197995912046 );
	]]
	
	GAMEMODE.Database:RawQuery("SELECT `betatesters`.`steamid64` FROM `santosrp`.`betatesters`;" , function(data)
		if data and data.steamid64 then 
			santosRP.WhiteList.players[data.steamid64] = true
		end
	end, function(...) PrintTable({...}) end)

end
hook.Add("postDatabaseConnected","LoadSantosRP_BetaTesters", santosRP.WhiteList.LoadBetaTesters)
concommand.Add( 'santosrp_reload_betatesters', santosRP.WhiteList.LoadBetaTesters)

hook.Add("CheckPassword", "whitelist", function(id64)
	if not santosRP.WhiteList.players[id64] then return false, "Not a tester" end
end)

if should_load then
	santosRP.WhiteList.LoadBetaTesters()
end