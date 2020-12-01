#include clientscripts\_utility;


main_start()
{
    players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread set_fov();
	}
}

set_fov()
{
	self endon("disconnect");

	while(1)
	{
		fov = GetDvarFloat("cg_fov_settings");
		if(fov == GetDvarFloat("cg_fov"))
		{
			wait .05;
			continue;
		}

		SetClientDvar("cg_fov", fov);

		wait .05;
	}
}


main_end()
{
}

