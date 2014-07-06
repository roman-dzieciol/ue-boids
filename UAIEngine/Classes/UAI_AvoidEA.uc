/* =============================================================================
:: File Name	::	UAI_AvoidEA.uc
:: Description	::	none
:: Comments		::	good for tight passages
:: =============================================================================
:: Revision history:
:: 00.00.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
class UAI_AvoidEA extends UAI_AvoidE;


/* =============================================================================
:: Copyright © 2003 Roman Dzieciol                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	MaxForce=1
	MaxSpeed=500
	BaseSpeed=300
	mult=12
	Extent=(X=16,Y=16,Z=8)
}
