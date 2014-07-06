/* =============================================================================
:: File Name	::	UAI_WarpPhysicsVolume.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_WarpPhysicsVolume extends PhysicsVolume;

var float limit;

event ActorLeavingVolume(Actor Other)
{
	local vector v;
	if( Other.bJustTeleported ) return;
	log(Other@Other.location);
	v = Other.location;

	// this wont handle very high velocities
	if( v.x > limit )	v.x = -limit;
	if( v.x < -limit )	v.x = limit;
	if( v.y > limit )	v.y = -limit;
	if( v.y < -limit )	v.y = limit;

	Other.SetLocation(v);
}

/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	limit=1024
}
