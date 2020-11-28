Tutorial by: Tom_Bmx. 			Date: 28/1/10

xfire: tombmx

//----------------------------------//
//   ZAPPER 1.4 Der Rresie Style	  //
//----------------------------------//

Please read it all from start to finish it's all important :)..

///////////////////////////////////////////

There are three sets of folders ill explain them now.

*fully_built_in*

These are built in to wall's and have everything needed to drop straight into a map.

*semi_built_in*

These still have all the kvp's but just less brushes and detail.

*standalone* 

These are just the zappers no blocker or bridge.

Now!

COPY the _prefabs folder in to your map_source folder. Which is in your main cod directory ( Program files ).

///////////////////////////////////////////
Notes.

**IMPORTANT**: you can only use a number ONCE.

for example you can use zapper1 from one folder and zapper 2 from another.
You cannot use zapper1 form one folder and zapper1 from another.

You have to use the zappers with a blocker in 1.4 as the trigger activates the zapper.
BUT you can easily make it so you don't need a blocker by finding this line in the script "flag_wait( enable_flag );" and putting a "//" before it Eg. "// flag_wait( enable_flag );"
If you really want 1 to be turned on with power while the other by a blocker, then xfire me and ill send you a script for it ( if im not busy :P or you can do it yourself ).

The Zapper3 is setup to use the bridge zappers so if you use zapper_3_blocker you will need to comment out the bridge script in the power function as this will turn it on. :P

All zappers must be linked to the zones( this may require some renaming of zones ).

///////////////////////////////////////////

Script Setup: you will need to switch out the old script with this slightly edited one.

See Script in file included: zapper_script.gsc


Advanced user NOTE: The only part that is edited is the section on the damage trigger, if you can get the damage trigger
				to work by targerting it with the buy trigger then no need to change it out. Just during testing it didn't seam to want to work for me lol :( !
				
///////////////////////////////////////////

Setup.
///////

Each blocker waits till power is turned on the a notification from the blocker it is linked to.
if you look at the kvp's on the blockers in the prefabs you will notice it has this KVP. 

"script_flag"

You may rember this from doing you zones as you have to put "enter_ZONENAME".

Well the zappers are setup for ceratin zone names in the script.

zapper1 = "script_flag", "enter_warehouse_building"
zapper2 = "script_flag", "enter_wnuen_building"

You can either rename your zone OR rename to zone name in the script.

**renaming the zone in script**

You will need to go to the same palce you put the script included. just above it you should see these lines.

	array_thread( getentarray("warehouse_electric_trap",	"targetname"), ::electric_trap_think, "enter_warehouse_building" );
	array_thread( getentarray("wuen_electric_trap",			"targetname"), ::electric_trap_think, "enter_wnuen_building" );
	array_thread( getentarray("bridge_electric_trap",		"targetname"), ::electric_trap_think, "bridge_down" );
	
The parts at the end are the zone names. If my zone was called "start_zone" and i was using it for zapper1 ( Top Line ). i would get this.

	array_thread( getentarray("warehouse_electric_trap",	"targetname"), ::electric_trap_think, "enter_start_zone" );
	
	**REMBER** you will need to change the script flag on the blocker to the you new zone name.
	
If you want to make the 3rd zapper work with a blocker then you can just rename the "bridge_down" to your zone name.

///////////////////////////////////////////
Damge triggers:

the damge trigger KVP's are:

script_flag 11 = "zapper_damage_wuen" "targetname"

script_flag 22 = "zapper_damage_warehouse" "targetname"

script flag 33 = "zapper_damage_bridge" "targetname"

///////////////////////////////////////////

how to add more zappers:

to add more zappers

step 1: make a new array thread..

	array_thread( getentarray("new_trap",	"targetname"), ::electric_trap_think, "enter_zone_name" );
	
	"new_trap" = the targetname you give the trigger.
	
	"enter_zone_name" the zone name.
	
step 2: add a new case to the switch function..

	switch ( tswitch.script_linkname )
	{
	case "10":	// wnuenn
	case "11":
		light_name = "zapper_light_wuen";
		damage_trigger = "zapper_damage_wuen";
		break;

	case "20":	// warehouse
	case "21":
		light_name = "zapper_light_warehouse";
		damage_trigger = "zapper_damage_warehouse";
		break;

	case "30":	// Bridge
	case "31":
		light_name = "zapper_light_bridge";
		damage_trigger = "zapper_damage_bridge";
		break;
	}
	
	the new case:
	
		case "32":
		light_name = "zapper_light_NEW";
		damage_trigger = "zapper_damage_NEW";
		break;
		
		The case number is the script linkto you give the trigger and handle.
		this thenlets you define the targetnames for this trap.
		
		for example:
				light_name = "zapper_light_NEW";
				damage_trigger = "zapper_damage_NEW";
				
				the bits inside " " are the targetnames for the damge trigger and light ( script_model ).

//------------------------------------------------------------------------------------------------------------------------------//

p.s i have not included a tutorial on how to make the zappers as you can just use the prefabs. but if you need me to ill write it out.

*********************************************
** If you get stuck or don't understand   **
** xfire me or pm me on customcod        **
** and ill update the tutorial                      **
********************************************

