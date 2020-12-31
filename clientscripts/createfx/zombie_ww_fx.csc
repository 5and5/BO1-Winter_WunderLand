main()
{	
	precache_createfx_fx();
	spawn_my_fx();
	clientscripts\_fx::reportNumEffects();
}

precache_createfx_fx()
{
	level._effect["fac_fog"]		 			    = loadfx("maps/zombie/fx_zombie_theater_fog_lg");
	level._effect["fac_snow"]		 			    = loadfx("env/weather/fx_snow_flakes_windy_med_looping");
	level._effect["mp_smoke_plume_md"]								= loadfx("maps/mp_maps/fx_mp_smk_plume_md_grey");
}

spawn_my_fx()
{
	// ent = clientscripts\_fx::createOneshotEffect( "fac_fog" );
 //    ent.v[ "origin" ] = (5263.5, 5250.2, 444);
 //    ent.v[ "angles" ] = ( 90, 0, 0 );
 //    ent.v[ "type" ] = "oneshotfx";
 //    ent.v[ "fxid" ] = "fac_fog";
 //    ent.v[ "delay" ] = -15;

    ent = clientscripts\_fx::createOneshotEffect( "fac_snow" );
    ent.v[ "origin" ] = (4800, 5700, 25);
    ent.v[ "angles" ] = ( 0, 0, 0 );
    ent.v[ "type" ] = "oneshotfx";
    // ent.v[ "type" ] = "exploder";
    // ent.v[ "exploder" ] = 202;
    ent.v[ "fxid" ] = "fac_snow";
    ent.v[ "delay" ] = -15;

    ent = clientscripts\_fx::createOneshotEffect( "mp_smoke_plume_md" );
    ent.v[ "origin" ] = (5265.5, 5248.2, 448);
    ent.v[ "angles" ] = ( 0, 0, 0 );
    ent.v[ "type" ] = "oneshotfx";
    ent.v[ "fxid" ] = "mp_smoke_plume_md";
    ent.v[ "delay" ] = 0;

    ent = clientscripts\_fx::createOneshotEffect( "mp_smoke_plume_md" );
    ent.v[ "origin" ] = (3917.5, 5522.2, 520);
    ent.v[ "angles" ] = ( 0, 0, 0 );
    ent.v[ "type" ] = "oneshotfx";
    ent.v[ "fxid" ] = "mp_smoke_plume_md";
    ent.v[ "delay" ] = 0;
	
} 
