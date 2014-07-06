/* =============================================================================
:: File Name	::	UAI_ArriveA.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_ArriveA extends UAI_Arrive;


var(SB_ArriveA) vector SeekLocation;
var(SB_ArriveA) vector SeekOffset;
var(SB_ArriveA) vector AllForces;
var(SB_ArriveA) vector NewAccel;

var(SB_ArriveA) vector FinalAccel;


var(SB_ArriveA) float GoalLength;
var(SB_ArriveA) float MaxForce;

var(SB_ArriveA) float MaxSpeed;
var(SB_ArriveA) float AccelDamping;



event Tick( float DeltaTime )
{
	if( bTrail )
		DrawTrail(DeltaTime);

	if( SteerTarget == None )
		return;

	SeekOffset = SteerTarget.Location - Location;
	DrawDebugLine(Location, SteerTarget.Location, 128, 0, 0);

	GoalLength = 2 * VSize(Velocity);
	SeekOffset = VTrunc(GoalLength, SeekOffset);
	DrawDebugLine(Location+vect(10,0,0), Location+SeekOffset+vect(10,0,0), 0, 128, 0);

	SeekOffset = SeekOffset - Velocity;
	SeekOffset = VTrunc(MaxForce, SeekOffset);
	DrawDebugLine(Location+vect(-10,0,0), Location+SeekOffset+vect(-10,0,0), 0, 0, 128);

	// global force
	AllForces = SeekOffset;

	// update
	AllForces = VTrunc(MaxForce, AllForces);

	if( Mass == 1.0 )	NewAccel = AllForces;
	else				NewAccel = (1.0 / Mass) * AllForces;
	NewAccel = AllForces;

	FinalAccel = VLerp(AccelDamping, NewAccel, FinalAccel);
	FinalAccel = NewAccel;


	// set velocity
	Velocity += FinalAccel;
	Velocity = VTrunc(MaxSpeed, Velocity);
	SetRotation(rotator(Velocity));

}

/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bTrail=false
	MaxForce=1
	MaxSpeed=500
	AccelDamping=0.07
	Velocity=(X=100,Y=0,Z=0)
}
/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
