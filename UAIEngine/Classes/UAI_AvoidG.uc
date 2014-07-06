/* =============================================================================
:: File Name	::	UAI_AvoidG.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_AvoidG extends UAI_Avoid;


var() vector SeekOffset;		// Vector between the agent and target
var() vector SeekForce;		// Force used to achieve desired direction
var() vector SteerForce;		// Accumulated seekforce

var() Actor Obstacle;		// Accumulated seekforce

var() vector MoveForce;
var() vector FinalForce;

var() vector HitLocation;
var() vector HitNormal;
var() vector TraceEnd;
var() vector TraceStart;
var() vector Extent;

var() vector ObstacleLocation;

var() float vmod,amod,factor;
var() float HitAngle;
var() float dist;
var() float mult;

var() float	MaxForce;		// Max steering force allowed = MaxForce*MaxSpeed
var() float	Aggressiveness;	// Values between 0-1

event Tick( float DeltaTime )
{
	if( bTrail )
		DrawTrail(DeltaTime);

	F0 = VSize(Velocity);

	// Do Trace
	TraceStart = Location;
	TraceEnd = Location+vector(rotation)*F0;
	Obstacle = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, Extent);
	if( Obstacle == None )
	{
		HitLocation = TraceEnd;
		SteerForce += MoveForce;
	}
	else					log(obstacle@hitnormal);

	// Calc Params
	SeekOffset = HitLocation - Location;

	HitAngle = Abs(HitNormal dot vector(rotation));
	dist = vsize(SeekOffset)*0.9;
	vmod = FClamp(dist / F0, 0.1, 1);
	amod = FClamp(F0 / dist, 0.1, 1);

	// Base Forces
	SteerForce += hitnormal * MaxSpeed * DeltaTime * Mult;
	MoveForce *= amod;
//	SteerForce *= (1-HitAngle)*f0;
	SteerForce = VTrunc(MaxForce*MaxSpeed, SteerForce);

	MoveForce = vector(rotation)*BaseSpeed;
	MoveForce *= vmod;
	MoveForce *= (1-HitAngle);
	MoveForce = VTrunc(MaxForce*MaxSpeed, MoveForce);

	FinalForce = SteerForce + MoveForce;

	// Set Velocity
	Velocity += FinalForce*DeltaTime;
	Velocity = VTrunc(MaxSpeed, Velocity);
	SetRotation(rotator(Velocity));

	// Debug
	DrawDebugLine(TraceStart, TraceEnd, 128, 128, 128);
	DrawDebugLine(Location, Location+Velocity, 255, 0, 0);
//	DrawDebugLine(Location+ZD2, Location+SeekVelocity+ZD2, 0, 255, 255);
//	DrawDebugLine(Location+ZU1, Location+SeekForceN*maxspeed+ZU1, 0, 128, 255);
//	DrawDebugLine(Location+ZU2, Location+SeekForce+ZU2, 0, 255, 255);
	DrawDebugLine(Location+ZD4, Location+SteerForce+ZD4, 0, 255, 0);
//	DrawDebugLine(Location+ZD3, Location+SeekOffset+ZD3, 128, 128, 128);

//	DrawDebugLine(SeekLocation+ZD2, SeekLocation-SeekForce+ZD2, 192, 0, 192);
//	DrawDebugLine(SeekLocation+ZD1, SeekLocation-Velocity+ZD1, 0, 96, 192);

//	DrawCircleC(Location, VSize(SeekOffset), CircleSides, 128, 128, 128);
}


/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	cTrail=(R=0,G=128,B=255,A=255)
	bTrail=true

	Aggressiveness=1.0

	MaxForce=1.0
	MaxSpeed=500
	BaseSpeed=300
	mult=10

	bRandomVelocity=true
	bResetOnTrigger=true
	Extent=(X=10,Y=10,Z=8)
}
