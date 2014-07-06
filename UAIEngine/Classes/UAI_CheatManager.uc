/* =============================================================================
:: File Name	::	UAI_CheatManager.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.50 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Roman Dzieciol	                     All Rights Reserved.
============================================================================= */
class UAI_CheatManager extends CheatManager;

var() string EditPrefix;

exec function ea(string s)	{	ConsoleCommand("editactor class="$EditPrefix$s);	}
exec function eaa(string s)	{	ConsoleCommand("editactor class="$EditPrefix$s);	}
exec function ed(string s)	{	ConsoleCommand("editdefault class="$EditPrefix$s);	}
exec function eda(string s)	{	ConsoleCommand("editdefault class="$EditPrefix$s);	}

exec function su(string s)	{	ConsoleCommand("summon UAIEngine.UAI_"$s);	}

/* =============================================================================
:: Copyright © 2003 Roman Dzieciol	                     All Rights Reserved.
============================================================================= */
DefaultProperties
{
	EditPrefix="UAI_"
}
