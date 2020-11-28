#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;

init()
{
	wait 1;
	// Below is an example.
	//thread add_zapper("zapper1", 1500, "enter_zone3");
	thread add_zapper("zapper1", 1000, "enter_zone1");
	thread add_zapper("zapper2", 1000, "enter_zone4");
}
add_zapper(zapper_name, cost, flag)
{
	triggers = getentarray(zapper_name + "_trigger", "targetname");
	handles = getentarray(zapper_name + "_handle", "targetname");
	lights = getentarray(zapper_name + "_light", "targetname");
	damage_trigs = getentarray(zapper_name + "_damage", "targetname");
	fx_structs = getentarray(zapper_name + "_struct", "targetname");
	
	if(!isDefined(cost))
		cost = 1000;
	
	triggers wait_for_power(cost);

	if(isDefined(flag))
	{
		triggers handle_zapper_trigs(handles, "disable");
		zapper_light_red( lights );
		flag_wait( flag );
		triggers handle_zapper_trigs(handles, "enable");
	}
	zapper_light_green( lights );
	
	while(1)
	{
		wait 0.01;
		player = undefined;
		notifier_struct = spawnStruct();
		for(i=0;i<triggers.size;i++)
		{
			triggers[i] thread wait_until_zapper_trigged(notifier_struct);
		}
		notifier_struct waittill("trigger", player);
		notifier_struct delete();
		if( player.score < cost )
		{
			play_sound_at_pos( "no_purchase", player.origin );
			continue;
		}
		play_sound_at_pos( "purchase", player.origin );
		player maps\_zombiemode_score::minus_to_player_score( cost );
		triggers handle_zapper_trigs(handles, "disable");
		wait 0.7;
		zapper_light_red( lights );
		array_thread(fx_structs,::zapperFx,zapper_name);
		damage_trigs do_damage(zapper_name);
		wait 25;
		level notify(zapper_name + "_end");
		wait 25;
		triggers handle_zapper_trigs(handles, "enable");
		zapper_light_green( lights );
		wait 0.7;
	}
}
do_damage(name)
{
	for(i=0;i<self.size;i++)
		self[i] thread barrier_do_damage(name);
}
barrier_do_damage(name)
{
	level endon(name + "_end");
	while(1)
	{
		self waittill("trigger",who);

		if(isplayer(who) )
		{
			who thread maps\dlc3_code::player_elec_damage();
		}
		else
		{
			who thread maps\dlc3_code::zombie_elec_death( randomint(100) );
		}
		// wait 0;	Delay between trap kills was already removed when I looked  --JC
	}
}
zapperFx(name)
{
	self.tag_origin = spawn("script_model",self.origin);
	self.tag_origin setmodel("tag_origin");
	playfxontag(level._effect["zapper"],self.tag_origin,"tag_origin");
	self.tag_origin playsound("elec_start");
	self.tag_origin playloopsound("elec_loop");
	self thread play_electrical_sound();
	
	level waittill(name + "_end");
	for(i=0;i<self.size;i++)
	{
		self.tag_origin stoploopsound();
		self notify ("arc_done");
		self.tag_origin delete();
	}
}
play_electrical_sound()
{
	self endon ("arc_done");
	while(1)
	{	
		wait(randomfloatrange(0.1, 0.5));
		playsoundatposition("elec_arc", self.origin);
	}
}
handle_zapper_trigs(handles, type)
{
	for(i=0;i<self.size;i++)
	{
		if(type == "disable")
			self[i] disable_trigger();
		else if(type == "enable")
			self[i] enable_trigger();	
	}
	for(i=0;i<handles.size;i++)
	{
		if(type == "disable")
			handles[i] disable_zapper_switch();
		else if(type == "enable")
			handles[i] enable_zapper_switch();
	}
}
zapper_light_red( zapper_lights )
{
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_red");	

		if(isDefined(zapper_lights[i].fx))
		{
			zapper_lights[i].fx delete();
		}

		zapper_lights[i].fx = maps\_zombiemode_net::network_safe_spawn( "trap_light_red", 2, "script_model", zapper_lights[i].origin );
		zapper_lights[i].fx setmodel("tag_origin");
		zapper_lights[i].fx.angles = zapper_lights[i].angles+(-90,0,0);
		playfxontag(level._effect["zapper_light_notready"],zapper_lights[i].fx,"tag_origin");
	}
}
zapper_light_green( zapper_lights )
{
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_green");	

		if(isDefined(zapper_lights[i].fx))
		{
			zapper_lights[i].fx delete();
		}

		zapper_lights[i].fx = maps\_zombiemode_net::network_safe_spawn( "trap_light_green", 2, "script_model", zapper_lights[i].origin );
		zapper_lights[i].fx setmodel("tag_origin");
		zapper_lights[i].fx.angles = zapper_lights[i].angles+(-90,0,0);
		playfxontag(level._effect["zapper_light_ready"],zapper_lights[i].fx,"tag_origin");
	}
}
wait_for_power(cost)
{
	for(i=0;i<self.size;i++)
	{
		self[i] SetHintString( &"ZOMBIE_FLAMES_UNAVAILABLE" );
		self[i] SetCursorHint( "HINT_NOICON" );
	}
	flag_wait( "electricity_on" );
	
	for(i=0;i<self.size;i++)
		self[i] SetHintString( "Press & hold &&1 to activate the electric barrier [Cost: "+cost+"]" );
}
enable_zapper_switch()
{
	self rotatepitch(-180,.5);
	self playsound("switch_flip");
}
disable_zapper_switch()
{
	self rotatepitch(180,.5);
	self playsound("switch_flip");
}
wait_until_zapper_trigged(struct)
{
	self waittill("trigger", who);
	struct notify("trigger", who);
}