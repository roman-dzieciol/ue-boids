/* =============================================================================
:: File Name	::	UAI_Arrive.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_Arrive extends UAI_Avatar;


var() float		AgentPower, AgentMaxPower;	// agent's speed
var() vector	AgentForce;					// agent's velocity

var() float		SteerPower;					// desired power
var() vector	SteerForce;					// desired velocity
var() vector	SteerDirection;				// desired direction vector
var() rotator	SteerRotation;				// desired direction rotation
var() float		SteerScale;					// rotation speed scale

var() vector	ResultingForce;				// resulting force vector
var() rotator	ResultingForceRotation;		// resulting force rotator
var() rotator	ResultingRotationDelta;		// resulting force rotation for this frame
var() rotator	ResultingRotation;			// final rotator

var(New) float	AvgRotationRate;

var() float		BrakeDistance;					//


var float dt;

var() UAI_Avatar SteerTarget;


function DrawDebugLines( float DeltaTime )
{
	if( SteerTarget != None )
		SteerDirection = SteerTarget.Location - Location;


	SteerRotation = rotator(SteerDirection);
//	SteerRotation = Rotation + default.SteerRotation;

	AgentPower = FMin(AgentPower, AgentMaxPower);
	AgentForce = vector(Rotation)*AgentPower;
//	DrawDebugLine(Location, Location + AgentForce, 255, 0, 0 );

	SteerPower = FMin(SteerPower, AgentMaxPower);
	SteerForce = vector(SteerRotation)*SteerPower;
//	DrawDebugLine(Location, Location + SteerForce, 0, 128, 255 );

	ResultingForce = SteerForce + AgentForce;
	ResultingForce = VClamp(ResultingForce, AgentMaxPower);
//	DrawDebugLine(Location, Location + ResultingForce, 0, 192, 0 );

	SetRotation( Normalize(Rotation + (Normalize(rotator(ResultingForce) - Rotation) * DeltaTime * SteerScale)) );

	if( VSize(SteerDirection)+16 < BrakeDistance )
		ResultingForce *= VSize(SteerDirection) / BrakeDistance;

	Velocity = ResultingForce;
//	ResultingForceRotation = Normalize(rotator(ResultingForce) - Rotation);
//	ResultingRotationDelta = ResultingForceRotation * DeltaTime * SteerScale;
//	ResultingRotation = Normalize(Rotation + ResultingRotationDelta);
//	SetRotation(ResultingRotation);

//	AvgRotationRate = (AvgRotationRate + ResultingRotationDelta.Yaw)/2;
}

/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bTrail=true

	AgentMaxPower=400
	AgentPower=200

	SteerPower=100
	SteerScale=20
	BrakeDistance=200

	SteerRotation=(Pitch=0,Yaw=16384,Roll=0)
}
