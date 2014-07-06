/* =============================================================================
:: File Name	::	UAI_Console.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.50 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class UAI_Console extends ExtendedConsole;

var Material PromptMaterial;
var color PromptColor;

var string ConsoleFontName;
var font ConsoleFont;

/*
var(Display) enum ERenderStyle
{
	STY_None,
	STY_Normal,
	STY_Masked,
	STY_Translucent,
	STY_Modulated,
	STY_Alpha,
	STY_Additive,
	STY_Subtractive,
	STY_Particle,
	STY_AlphaZ,
} Style;
*/

event Initialized()
{
	ConsoleFont = DynamicLoadFont( ConsoleFontName );
}

state Typing
{
	function PostRender(Canvas Canvas)
	{
		local float xl,yl;
		local string OutStr;

		Canvas.Font	= ConsoleFont;
		Canvas.Style = 5;
		OutStr = "(>"@TypedStr$"_";
		Canvas.Strlen(OutStr,xl,yl);

		Canvas.SetPos (0, Canvas.ClipY-6-yl);
		Canvas.SetDrawColor(255,255,255,192);
		Canvas.DrawTileStretched(PromptMaterial,Canvas.ClipX,YL+6);

		Canvas.SetPos(0,Canvas.ClipY-3-yl);
		Canvas.DrawColor = PromptColor;
		Canvas.bCenter = False;
		Canvas.DrawText( OutStr, false );
	}
}


simulated function Font DynamicLoadFont( string S )
{
	local Font F;

	F = Font(DynamicLoadObject(S, class'Font'));
	if( F == None )
		Log("Warning: "$Self$" Couldn't dynamically load font "$S);

	return F;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ConsoleFontName="EM_Fonts_T.jFontSmallText800x600"
	PromptMaterial=Material'Engine.MenuBlack'
	PromptColor=(R=255,G=144,B=0,A=255)
}
