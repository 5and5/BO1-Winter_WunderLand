/*
	Der Frost / Nazi Zombie Sniperbolt Tutorial Version 2.0
		Scripter: Sparks
		Tutorial: Sniperbolt

	Version 1.0 (9/24/2009 7:51:18 PM)
		-- Initial Release Of Source Files
*/

// Tutorial From Sniperbolt!

// Utilities
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility; 
#include maps\_zombiemode_zone_manager; 
#include maps\_music;

// DLC3 Utilities
#include maps\dlc3_code;
#include maps\dlc3_teleporter;

main()
{
	level.DLC3 = spawnStruct(); // Leave This Line Or Else It Breaks Everything
	
	// Must Change These To Your Maps
	level.DLC3.createArt = maps\createart\nazi_zombie_wunder_art::main;
	level.DLC3.createFX = maps\createfx\nazi_zombie_wunder_fx::main;
	level.DLC3.myFX = ::preCacheMyFX;
	
	/*--------------------
	 FX
	----------------------*/
	DLC3_FX();
	
	/*--------------------
	 LEVEL VARIABLES
	----------------------*/	
	
	// Variable Containing Helpful Text For Modders -- Don't Remove
	level.modderHelpText = [];
	
	//
	// Change Or Tweak All Of These LEVEL.DLC3 Variables Below For Your Level If You Wish
	//
	
	// Edit The Value In Mod.STR For Your Level Introscreen Place
	level.DLC3.introString = &"nazi zombie tes";
	
	// Weapons. Pointer function automatically loads weapons used in Der Riese.
	level.DLC3.weapons = maps\dlc3_code::include_weapons;
	
	// Power Ups. Pointer function automatically loads power ups used in Der Riese.
	level.DLC3.powerUps =  maps\dlc3_code::include_powerups;
	
	// Adjusts how much melee damage a player with the perk will do, needs only be set once. Stock is 1000.
	level.DLC3.perk_altMeleeDamage = 1000; 
	
	// Adjusts barrier search override. Stock is 400.
	level.DLC3.barrierSearchOverride = 400;
	
	// Adjusts power up drop max per round. Stock is 3.
	level.DLC3.powerUpDropMax = 3;
	
	// _loadout Variables
	level.DLC3.useCoopHeroes = true;
	
	// Bridge Feature
	level.DLC3.useBridge = false;
	
	// Hell Hounds
	level.DLC3.useHellHounds = true;
	
	// Mixed Rounds
	level.DLC3.useMixedRounds = true;
	
	// Magic Boxes -- The Script_Noteworthy Value Names On Purchase Trigger In Radiant
	boxArray = [];
	boxArray[ boxArray.size ] = "start_chest";
	boxArray[ boxArray.size ] = "chest1";
	boxArray[ boxArray.size ] = "chest2";
	boxArray[ boxArray.size ] = "chest3";
	boxArray[ boxArray.size ] = "chest4";
	boxArray[ boxArray.size ] = "chest5";
	level.DLC3.PandoraBoxes = boxArray;
	
	// Initial Zone(s) -- Zone(s) You Want Activated At Map Start
	zones = [];
	zones[ zones.size ] = "start_zone";
	level.DLC3.initialZones = zones;
	
	// Electricity Switch -- If False Map Will Start With Power On
	level.DLC3.useElectricSwitch = true;
	
	// Electric Traps
	level.DLC3.useElectricTraps = true;
	
	// _zombiemode_weapons Variables
	level.DLC3.usePandoraBoxLight = true;
	level.DLC3.useChestPulls = true;
	level.DLC3.useChestMoves = true;
	level.DLC3.useWeaponSpawn = true;
	level.DLC3.useGiveWeapon = true;
	
	// Weight Functions -Demzyy
	level.pulls_since_last_tesla_gun = 0;
	level.pulls_since_last_thundergun = 0;
	level.pulls_since_last_scavenger = 0;
	
	// _zombiemode_spawner Varibles
	level.DLC3.riserZombiesGoToDoorsFirst = true;
	level.DLC3.riserZombiesInActiveZonesOnly = true;
	level.DLC3.assureNodes = true;
	
	// _zombiemode_perks Variables
	level.DLC3.perksNeedPowerOn = true;
	
	// _zombiemode_devgui Variables
	level.DLC3.powerSwitch = true;
	
	level.DLC3.useSnow = true;
	
	/*--------------------
	 FUNCTION CALLS - PRE _Load
	----------------------*/
	level thread DLC3_threadCalls();
	maps\_character_randomize::init();
	
	/*--------------------
	 ZOMBIE MODE
	----------------------*/
	[[level.DLC3.weapons]]();
	[[level.DLC3.powerUps]]();
	maps\ugx_jukebox::jukebox_precache();
	
	/*--------------------
	 Viewhands Precache
	----------------------*/
	PrecacheModel( "bo2_c_zom_dempsey_viewhands" );
	PrecacheModel( "bo2_c_zom_nikolai_viewhands" );
	PrecacheModel( "bo2_c_zom_richtofen_viewhands" );
	PrecacheModel( "bo2_c_zom_takeo_viewhands" );
	
	/*--------------------
	 ZOMBIE MODE
	----------------------*/
	// [[level.DLC3.weapons]]();
	// [[level.DLC3.powerUps]]();
	level.tom_victory = false;
	end_trig = getentarray( "end_game","targetname" );
	array_thread( end_trig,::end_game );
	maps\_zombiemode::main();
	
	thread maps\ugx_jukebox::jukebox_init();
	// level thread maps\ScoreSolo::CheckScore();
	
	/*--------------------
	 FUNCTION CALLS - POST _Load
	----------------------*/
	level.zone_manager_init_func = ::dlc3_zone_init;
	level thread DLC3_threadCalls2();
	thread maps\_custom_zapper_system::init();
	level thread onLoad_dvars();
}

dlc3_zone_init()
{

	/*
	add_adjacent_zone( "start_zone", "zone1", "enter_zone1" ); // Spawn to PM63 Porch
	add_adjacent_zone( "start_zone", "zone2", "enter_zone2_from_spawn" ); // Spawn to Power
	add_adjacent_zone( "zone1", "zone2", "enter_zone2_from_zone1" ); // PM63 Porch to Power
	add_adjacent_zone( "zone1", "zone3", "enter_zone3" ); // PM63 Porch to Courtyard
	// add_adjacent_zone( "zone3", "zone4", "enter_zone4" ); // Courtyard to Speed Floor
	add_adjacent_zone( "zone4", "zone5", "enter_zone5" ); // Speed Floor to Jug Floor
	 add_adjacent_zone( "zone5", "zone4", "enter_zone4" ); // Jug Floor to Speed Floor
	*/
	
	//start zone = spawn;  zone1 = pm63 porch;  zone2 = power;  zone3 = courtyard+saloon porch;  zone4 = bottom saloon/speed floor;  zone5 = top saloon/jug floor;
    //start_zone is already active at launch because of earlier line ^
    add_adjacent_zone( "start_zone", "zone1", "enter_zone1" ); // Spawn to PM63 Porch
	add_adjacent_zone( "zone2", "zone1", "enter_zone1_from_zone2"); // Power to PM63 Porch
    add_adjacent_zone( "start_zone", "zone2", "enter_zone2_from_spawn" ); // Spawn to Power
    add_adjacent_zone( "zone1", "zone2", "enter_zone2_from_zone1" ); // PM63 Porch to Power
    add_adjacent_zone( "zone1", "zone3", "enter_zone3" ); // PM63 Porch to Courtyard
    // add_adjacent_zone( "zone3", "zone4", "enter_zone4" ); // Courtyard to Speed Floor -- we don't want this one now
    add_adjacent_zone( "zone4", "zone4", "enter_zone4" ); // Speed Floor to... uh, Speed Floor, lol
    add_adjacent_zone( "zone4", "zone5", "enter_zone5" ); // Speed Floor to Jug Floor
    //add_adjacent_zone( "zone5", "zone4", "enter_zone4" ); // Jug Floor to Speed Floor -- this is redundant now
	
	/*
	=============
	///ScriptDocBegin
	"Name: add_adjacent_zone( <zone_1>, <zone_2>, <flag>, <one_way> )"
	"Summary: Sets up adjacent zones."
	"MandatoryArg: <zone_1>: Name of first Info_Volume"
	"MandatoryArg: <zone_2>: Name of second Info_Volume"
	"MandatoryArg: <flag>: Flag to be set to initiate zones"
	"OptionalArg: <one_way>: Make <zone_1> adjacent to <zone_2>. Defaults to false."
	"Example: add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );"
	///ScriptDocEnd
	=============
	*/

	// Outside East Door
	//add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );
}

preCacheMyFX()
{
 level._effect["smokey_fire"] = Loadfx("system_elements/fx_fire_wood_sm");
 level._effect["med_chimney_smoke"] = Loadfx("env/smoke/fx_smoke_wood_chimney_med");
 // level._effect["light_blizzard"] = Loadfx("env/weather/fx_snow_blizzard_light");
}

end_game()
{
    user = undefined;
    cost = 66000;                                        //change to cost that you want

    self setCursorHint("HINT_NOICON");
    self UseTriggerRequireLookAt();
    // self setHintString("The power must be activated first");                //remove line if you want it to work without power

    // flag_wait( "electricity_on" ); 	//remove line if you want it to work without power
	
	flag_wait( "item_built" );
	
    self setHintString("Press &&1 to radio for help and end the game [Cost: "+cost+"]");            //text hint trigger

    while(1)
    {
        self waittill("trigger", user);
        if( is_player_valid(user) && user.score >= cost )
        {
            play_sound_at_pos( "cha_ching", self.origin );
            user thread maps\_zombiemode_score::minus_to_player_score( cost );
            self delete();

            level notify( "end_game" );
                        level notify("tom_planes");
            level.tom_victory = true;
        }
        else
        {
            play_sound_at_pos( "no_cha_ching", self.origin );
        }
    }
}

onLoad_dvars()
{
	players = Get_Players();	
	for(i=0;i<players.size;i++)
	{
    	//players[i] SetClientDvar("r_fog",0);
		//players[i] SetClientDvar("cg_fov",85);
		//players[i] SetClientDvar("cg_fovScale",1.125);
		players[i] SetClientDvar("sv_cheats", "1");		// change this to "1" to enable cheats  --Just Crusader / JC
		players[i] SetClientDVar("sv_disableClientConsole","0");
		players[i] SetClientDVar("player_backSpeedScale","1");
		players[i] SetClientDVar("player_strafeSpeedScale","1"); 
		players[i] SetClientDVar("aim_automelee_enabled","0");
		players[i] SetClientDVar("aim_automelee_range","0");
		players[i] SetClientDVar("cg_drawfps","2");
		players[i] SetClientDVar("hud_fade_ammodisplay","0");		// ammo on HUD never fades away
		players[i] SetClientDVar("cg_blood","0");
		players[i] SetClientDVar("cg_mature","0");

	}

	if( getdvar("sv_cheats") != "1" )		// have to do this check, otherwise "naughty boy" message plays at the start of first load, lol  --Just Crusader / JC
	{
		SetDvar("sf_use_ignoreammo" , "0");
		SetDvar("magic_chest_movable" , "1");
	}

	while( getdvar("sv_cheats") != "1" )		// anti-cheat  --JC / Just Crusader
	{
		if( getdvar("sf_use_ignoreammo") != "0" )
		{
			SetDvar("sf_use_ignoreammo" , "0");
			iprintlnbold( "What are you doing, naughty boy?! :eyes:" );
		}

		if( getdvar("magic_chest_movable") != "1" )
		{
			SetDvar("magic_chest_movable" , "1");	
			iprintlnbold( "What are you doing, naughty boy?! :eyes:" );
		}
		
		wait (0.1);
	}
}