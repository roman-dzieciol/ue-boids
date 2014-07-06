/* =============================================================================
:: File Name	::	UAI_ArriveD.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_ArriveD extends UAI_Arrive;


var vector SeekLocation;	// Seek target location
var vector SeekOffset;		// Vector between the agent and target
var vector SeekForce;		// Force used to achieve desired direction
var vector SteerForce;		// Accumulated seekforce

var(SB_Seek) float	MaxForce;		// Max steering force allowed = MaxForce*MaxSpeed
var(SB_Seek) float	Aggressiveness;	// Values between 0-1

event Tick( float DeltaTime )
{
	if( bTrail )
		DrawTrail(DeltaTime);

	if( SteerTarget == None )
		return;

	SeekLocation	= SteerTarget.Location;
	SeekOffset		= SeekLocation - Location;
	SeekForce		= SeekOffset - Velocity;
	SteerForce		+= Normal(SeekOffset) * VSize(SteerTarget.Velocity);
	SteerForce		+= SteerTarget.Velocity;

	SeekForce = VTrunc(MaxForce*MaxSpeed, SeekForce);

	SteerForce += SeekForce;
	SteerForce = VLerp(Aggressiveness,SeekForce,SteerForce);
	SteerForce = VTrunc(MaxForce*MaxSpeed, SteerForce);

	Velocity += SteerForce * DeltaTime;
	Velocity = VTrunc(MaxSpeed, Velocity);
	SetRotation(rotator(Velocity));

	DrawDebugLine(Location, Location+Velocity, 255, 0, 255);
//	DrawDebugLine(Location+ZD2, Location+SeekVelocity+ZD2, 0, 255, 255);
//	DrawDebugLine(Location+ZU1, Location+SeekForceN*maxspeed+ZU1, 0, 128, 255);
//	DrawDebugLine(Location+ZU2, Location+SeekForce+ZU2, 0, 255, 255);
//	DrawDebugLine(Location+ZD4, Location+SteerForce+ZD4, 0, 255, 0);
//	DrawDebugLine(Location+ZD3, Location+SeekOffset+ZD3, 128, 128, 128);

//	DrawDebugLine(SeekLocation+ZD2, SeekLocation-SeekForce+ZD2, 192, 0, 192);
//	DrawDebugLine(SeekLocation+ZD1, SeekLocation-Velocity+ZD1, 0, 96, 192);

	DrawCircleC(Location, VSize(SeekOffset), CircleSides, 128, 128, 128);
}


/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	cTrail=(R=0,G=128,B=255,A=255)
	bTrail=true

	Aggressiveness=0.8

	MaxForce=2
	MaxSpeed=500

	bRandomVelocity=true
	bResetOnTrigger=true
}
