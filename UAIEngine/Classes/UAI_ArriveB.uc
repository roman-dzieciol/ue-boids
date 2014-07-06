/* =============================================================================
:: File Name	::	UAI_ArriveB.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_ArriveB extends UAI_Arrive;


var(SB_Seek) vector SeekLocation;
var(SB_Seek) vector SeekOffset;

var(SB_Seek) float MaxForce;
var(SB_Seek) float Distance;



event Tick( float DeltaTime )
{
	if( bTrail )
		DrawTrail(DeltaTime);

	// find seek target
	if( SteerTarget == None )	SeekLocation = vect(0,0,0);
	else						SeekLocation = SteerTarget.Location;


	SeekOffset = SeekLocation - Location;
	Distance = Vsize(SeekOffset);

	SeekOffset += SeekOffset;
	SeekOffset -= Velocity;

	SeekOffset *= (MaxSpeed*MaxSpeed) / Distance;
	SeekOffset *= Deltatime;
	SeekOffset = VTrunc(MaxForce, SeekOffset);

	SeekOffset = VTrunc(maxForce, SeekOffset);
	DrawDebugLine(Location+ZU1, Location+SeekOffset*25+ZU1, 0, 128, 255);

	Velocity += SeekOffset;
	Velocity = VTrunc(MaxSpeed, Velocity);

	SetRotation(rotator(Velocity));


	DrawCircle(Location, VSize(SeekOffset), CircleSides, cSpeed);
	DrawDebugLine(Location, Location+Velocity, 255, 0, 255);
}


/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bTrail=false

	F0=0.01

	MaxForce=1
	MaxSpeed=500

	bRandomVelocity=true
	bResetOnTrigger=true
}
