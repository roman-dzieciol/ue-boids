/* =============================================================================
:: File Name	::	UAI_AvoidJ.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_AvoidJ extends UAI_Avoid;



var() vector SeekOffset;		// Vector between the agent and target
var() vector SteerForce;		// Accumulated seekforce

var() Actor Obstacle;		// Accumulated seekforce

var() vector MoveForce;
var() vector FinalForce;

var() vector HitLocation;
var() vector HitNormal;
var() vector TraceEnd;
var() vector TraceStart;
var() vector Extent;
var() vector VR;

var() float vmod,amod;
var() float HitAngle;
var() float HitAngle2;
var() float HitAngle3;

var() float Speed;
var() float Distance;
var() float MaxSteer;
var() float TraceRange;
var() float SteerMult;
var() float MoveMult;

var() float	MaxForce;		// Max steering force allowed = MaxForce*MaxSpeed

event Tick( float DeltaTime )
{
	// - Calc Params -----------------------------------------------------------

	Speed = VSize(Velocity);
	VR = vector(rotation);
	TraceRange = Speed;

	// - Do Trace --------------------------------------------------------------

	TraceStart = Location;
	TraceEnd = Location + VR*TraceRange;

	Obstacle = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, Extent);
	if( Obstacle == None )
	{
		HitLocation = TraceEnd;
		HitNormal = VR;
		SteerForce = HitNormal * MaxSteer * DeltaTime;
	}
	else
	{
	}


	// - Calc Params -----------------------------------------------------------

	SeekOffset = HitLocation - Location;
	Distance = VSize(SeekOffset);

	HitAngle2 = HitNormal dot VR;
	HitAngle2 = Abs(HitAngle2);

	vmod = FClamp(Distance / Speed, 0.001, 1);
	amod = FClamp(Speed*HitAngle2 / Distance, 0.001, 1);

	cm(vsize(SteerForce));

	SteerMult = amod;

	// - Base Forces -----------------------------------------------------------

	SteerForce = HitNormal * MaxSteer * DeltaTime * SteerMult;
	SteerForce = VTrunc(MaxSteer, SteerForce);

	MoveForce = VR * MaxSpeed * MoveMult + VRand();
	MoveForce = VTrunc(MaxSpeed, MoveForce);

	FinalForce = SteerForce + MoveForce;

	// Set Velocity
	Velocity = FinalForce;
	Velocity = VTrunc(MaxSpeed, Velocity);
	Velocity.Z = 0;
	SetRotation(rotator(Velocity));

	// - Debug -----------------------------------------------------------------

	if( bTrail )	DrawTrail(DeltaTime);
	if( !bDebug )	return;

	ZU.Z=0;
	ZU.Z+=1;	DrawDebugLine(ZU+TraceStart, ZU+TraceEnd, 128, 128, 128);
	ZU.Z+=1;	DrawDebugLine(ZU+Location, ZU+Location+FinalForce, 0, 128, 0);
	ZU.Z+=1;	DrawDebugLine(ZU+Location, ZU+Location+MoveForce, 255, 0, 0);
	ZU.Z+=1;	DrawDebugLine(ZU+Location, ZU+Location+SteerForce, 0, 255, 0);
//	ZU.Z+=1;	DrawDebugLine(ZU+Location, ZU+Location+HitNormal*128, 255, 255, 0);
	ZU.Z+=1;	DrawDebugLine(ZU+HitLocation, ZU+HitLocation+HitNormal*128, 255, 255, 0);
//	ZU.Z+=1;	DrawDebugLine(ZU+Location, ZU+Location+MoveForce, 255, 128, 0);

//	ZU.Z+=1;	DrawCircleC(ZU+Location, ZU+VSize(SeekOffset), CircleSides, 128, 128, 128);
}


/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	cTrail=(R=0,G=128,B=255,A=255)
	bTrail=true
	bdebug=true

	MaxForce=1.0
	SteerMult=1.0
	MoveMult=1.0

	MaxSpeed=300
	MaxSteer=3000

	TraceRange=300

	bRandomVelocity=true
	bResetOnTrigger=true
	Extent=(X=10,Y=10,Z=8)
}
