/* =============================================================================
:: File Name	::	UAI_AvoidI.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_AvoidI extends UAI_Avoid;

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
var() vector side;

var() rotator rside;

var() vector ObstacleLocation;

var() float vmod,amod,factor;
var() float HitAngle;
var() float HitAngle2;
var() float HitAngle3;
var() float dist;
var() float mult;
var() float TraceMax;
var() float maxsteer;


var() float	MaxForce;		// Max steering force allowed = MaxForce*MaxSpeed
var() float	Aggressiveness;	// Values between 0-1

event Tick( float DeltaTime )
{
	local vector x,y,z;

	if( bTrail )
		DrawTrail(DeltaTime);

	// Do Trace
	TraceStart = Location;
	TraceEnd = Location+vector(rotation)*TraceMax;
	Obstacle = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, Extent);
	if( Obstacle == None )
	{
		HitLocation = TraceEnd;
//		SteerForce += vector(rotation)*MaxSpeed*DeltaTime;
	}
	else
	{
		DrawDebugLine(HitLocation, HitLocation+HitNormal*128, 255, 0, 255);
		log(obstacle@hitnormal);
	}


	// Calc Params
	SeekOffset = HitLocation - Location;

	getaxes(rotation,x,y,z);
	side = vector(rotation) >> rot(0,16384,0);
	HitAngle = HitNormal dot vector(rotation);
	HitAngle2 = Normal(SeekOffset) dot vector(rotation);
	HitAngle3 = y dot HitNormal;
	dist = vsize(SeekOffset);
	vmod = FClamp(dist / TraceMax, 0.1, 1);
	amod = FClamp(TraceMax / dist, 0.1, 1);
	if( HitAngle3 > 0) HitAngle3 = 1;
	if( HitAngle3 < 0) HitAngle3 = -1;
	cm(HitAngle3);

	// Base Forces

	SteerForce += side * HitAngle3 * Maxsteer * DeltaTime;
	SteerForce = VTrunc(MaxForce*Maxsteer, SteerForce);

	MoveForce = (vector(rotation))*MaxSpeed+VRand();
	MoveForce = VTrunc(MaxForce*MaxSpeed, MoveForce);

	FinalForce = SteerForce + MoveForce;

	// Set Velocity
	Velocity = FinalForce;
	Velocity = VTrunc(MaxSpeed, Velocity);
	Velocity.Z = 0;
	SetRotation(rotator(Velocity));

	// Debug
	DrawDebugLine(TraceStart, TraceEnd, 128, 128, 128);
	DrawDebugLine(Location, Location+Velocity, 255, 0, 0);
	DrawDebugLine(Location, Location+SteerForce, 0, 255, 0);
	DrawDebugLine(Location+ZD4, Location+MoveForce+ZD4, 255, 128, 0);

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
	MaxSpeed=300
	BaseSpeed=300
	mult=1
	TraceMax=300
	maxsteer=600

	bRandomVelocity=true
	bResetOnTrigger=true
	Extent=(X=10,Y=10,Z=8)
}
