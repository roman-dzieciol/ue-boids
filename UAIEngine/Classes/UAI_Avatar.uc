/* =============================================================================
:: File Name	::	UAI_Avatar.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.50 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class UAI_Avatar extends Actor
	placeable;

const SqrtTwo		= 1.414213;
const Sqrt2			= 1.414213;


struct TrailPoint
{
	var vector TLocation;
	var color TColor;
};


var() UAI_Avatar SteerTarget;

var float BaseSpeed;
var(SB_Seek) float MaxSpeed;

var color cSpeed, cWanderBig, cWanderSmall, cSteerDir;
var color cTrail;

var color cTrailBase;
var color cTrailMax;

var float TrailTime, TrailTimer;
var array<vector> TrailPoints;
var array<TrailPoint> TrailList;

var(SB_Debug) bool		bTrail;			// draw trail
var(SB_Debug) float	CircleSides;	// pretty good framerate killer
var() bool bRandomVelocity;
var() bool bResetOnTrigger;
var() bool bdebug;

var float ResetTime;
var(SB_Debug) float		F0,F1,F2,F3,F4,F5,F6,F7,F8;
var(SB_Debug) vector	V0,V1,V2,V3,V4,V5,V6,V7,V8;
var vector ZD1, ZD2, ZD3, ZD4, ZD5, ZD6, ZD7, ZD8;
var vector ZU, ZU1, ZU2, ZU3, ZU4, ZU5, ZU6, ZU7, ZU8;
var vector VZero;

event PreBeginPlay()
{
	InitAgent();
}

function InitAgent()
{
	// set location
	// set velocity
	if( bRandomVelocity )
	{
		Velocity.X = RandRange(-MaxSpeed,MaxSpeed);
		Velocity.Y = RandRange(-MaxSpeed,MaxSpeed);
	}
	if( bTrail )
	{
		TrailPoints.Remove(0,TrailPoints.Length);
		TrailPoints[TrailPoints.Length] = location;
//		TrailList.Remove(0,TrailList.Length);
//		TrailList[TrailList.Length].TLocation = Location;
//		TrailList[TrailList.Length-1].TColor = Location;
	}
	// set rotation
}



event PhysicsVolumeChange( PhysicsVolume NewVolume )
{
	if( bTrail )
	{
		TrailPoints.Remove(0,TrailPoints.Length);
		TrailPoints[TrailPoints.Length] = location;
	}
}

event Tick( float DeltaTime )
{
	if( bTrail )
		DrawTrail(DeltaTime);
	DrawDebugLines(DeltaTime);
//	SetRotation(rotator(Velocity));
}

function DrawDebugLines( float DeltaTime );

function DrawCircle( vector Position, float Radius, int Sides, color C )
{
	local array<vector> Points;
	local int i;

	Points.Insert(i, 1);
	Points[i] = Position;
	Points[i].X += Radius*sin((2*i)*pi/Sides);
	Points[i].Y += Radius*cos((2*i)*pi/Sides);

	for( i=1; i<Sides; i++ )
	{
		Points.Insert(i, 1);
		Points[i] = Position;
		Points[i].X += Radius*sin((2*i)*pi/Sides);
		Points[i].Y += Radius*cos((2*i)*pi/Sides);
		DrawDebugLine(Points[i-1], Points[i],C.R,C.G,C.B);
	}

	DrawDebugLine(Points[0], Points[i-1],C.R,C.G,C.B);
}

function DrawCircleC( vector Position, float Radius, int Sides, byte R, byte G, byte B )
{
	local array<vector> Points;
	local int i;

	Points.Insert(i, 1);
	Points[i] = Position;
	Points[i].X += Radius*sin((2*i)*pi/Sides);
	Points[i].Y += Radius*cos((2*i)*pi/Sides);

	for( i=1; i<Sides; i++ )
	{
		Points.Insert(i, 1);
		Points[i] = Position;
		Points[i].X += Radius*sin((2*i)*pi/Sides);
		Points[i].Y += Radius*cos((2*i)*pi/Sides);
		DrawDebugLine(Points[i-1], Points[i],R,G,B);
	}

	DrawDebugLine(Points[0], Points[i-1],R,G,B);
}

function DrawTrail( float DeltaTime )
{
	local int i;

	TrailTimer += DeltaTime;
	if( TrailTimer > TrailTime )
	{
		TrailTimer = 0;
		TrailPoints[TrailPoints.Length] = Location;
		//if( TrailPoints.Length > 500 )
		//	TrailPoints.Remove(0,1);
	}

	for( i=1; i<TrailPoints.Length; i++ )
	{
		DrawDebugLine(TrailPoints[i-1], TrailPoints[i], cTrail.R, cTrail.G, cTrail.B);
	}
}



function vector VClamp( vector v, float size )
{
	if( VSize(v) > size )	return Normal(v)*size;
	else					return v;
}

function vector VRandXY()
{
	local vector v;
	V = VRand();
	V.Z = 0;
	return Normal(V);
}

function vector VTrunc( float size, vector v )
{
	if( VSize(v) > size )	return Normal(v)*size;
	else					return v;
}

function vector VLerp( float Alpha, vector A, vector B )
{
	local vector V;
	V.X = A.X + Alpha * (B.X - A.X);
	V.Y = A.Y + Alpha * (B.Y - A.Y);
	V.Z = A.Z + Alpha * (B.Z - A.Z);
	return V;
}

function vector RCirclePos( vector Origin, float Radius )
{
	local vector v;
	local float f;

//	Radius *= FRand();
	f = 2*FRand()*pi;
	v = Origin;
	v.x = Radius*sin(f);
	v.y = Radius*cos(f);
	return v;
}
static final function string FSTR( float Value, optional int Precision )
{
	local string IntString, FloatString;
	local float FloatPart;
	local int IntPart;

	if( Precision == 0 )	Precision = 6;
	else					Precision = Max(Precision, 1);

	if( Value < 0 )
	{
		IntString = "-";
		Value *= -1;
	}

	IntPart = int(Value);
	FloatPart = Value - IntPart;
	IntString = IntString $ string(IntPart);
	FloatString = string(int(FloatPart * 10 ** Precision));

	while( Len(FloatString) < Precision )
		FloatString = "0" $ FloatString;

//	while( Len(IntString) < Precision )
//		IntString = "0" $ IntString;

	return IntString$"."$FloatString;
}

static final function string RSTR(rotator R){ return R.Pitch$", "$R.Yaw$", "$R.Roll; }

function CM( coerce string S )
{
	Level.GetLocalPlayerController().ClientMessage(S);
}

event Trigger( Actor Other, Pawn EventInstigator )
{
	if( bResetOnTrigger && TimerRate == 0 )
		SetTimer(ResetTime, false);
}


event Timer()
{
	SetLocation(RCirclePos(vect(0,0,0), 500));
	InitAgent();
}

function color MC(byte R, byte G, byte B)
{
	local color C;
	C.R = R;
	C.G = G;
	C.B = B;
	//C.A = A;
	return C;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	CircleSides=64

	cSpeed=(R=255,G=0,B=255,A=255)
	cWanderBig=(R=192,G=192,B=192,A=255)
	cWanderSmall=(R=255,G=255,B=255,A=255)
	cSteerDir=(R=0,G=255,B=255,A=255)
	cTrail=(R=192,G=0,B=0,A=255)

	StaticMesh=StaticMesh'UAISM_Avatar.CylinderH'
	DrawType=DT_StaticMesh
	bUnlit=true
	PrePivot=(X=0,Y=0,Z=8)

	bCollideActors=True
	bCollideWorld=True
	bBlockActors=false
	bBlockPlayers=false
	bProjTarget=True

	CollisionRadius=8.000000
	CollisionHeight=8.000000

	bDirectional=True
	bCanBeDamaged=false
	bShouldBaseAtStartup=True
	Physics=PHYS_Projectile

	MaxSpeed=500
	BaseSpeed=192
	TrailTime=0.02
	ResetTime=0.5

	F0=1
	F1=1
	F2=1
	F3=1
	F4=1
	F5=1
	F6=1
	F7=1
	F8=1

	ZD1=(X=0,Y=0,Z=-1)
	ZD2=(X=0,Y=0,Z=-2)
	ZD3=(X=0,Y=0,Z=-3)
	ZD4=(X=0,Y=0,Z=-4)
	ZD5=(X=0,Y=0,Z=-5)
	ZD6=(X=0,Y=0,Z=-6)
	ZD7=(X=0,Y=0,Z=-7)
	ZD8=(X=0,Y=0,Z=-8)

	ZU1=(X=0,Y=0,Z=1)
	ZU2=(X=0,Y=0,Z=2)
	ZU3=(X=0,Y=0,Z=3)
	ZU4=(X=0,Y=0,Z=4)
	ZU5=(X=0,Y=0,Z=5)
	ZU6=(X=0,Y=0,Z=6)
	ZU7=(X=0,Y=0,Z=7)
	ZU8=(X=0,Y=0,Z=8)
}
