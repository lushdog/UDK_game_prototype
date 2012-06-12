/**
 *	BoxingPC
 *
 *	Creation date: 31/05/2012 19:32
 *	Copyright 2012, MattsWin7
 */
class BoxingPC extends PlayerController;

exec function LeftJab()
{
}

exec function RightJab()
{
}

exec function LeftHook()
{
}

exec function RightHook()
{
}

exec function BlockHigh()
{
}

exec function BlockLow()
{
}

exec function MoveLeft()
{
}

exec function MoveRight()
{
}

//@todo, add some states (which should be subclassed to be reused by AI)
//add HUD and call DisplayDebug stuff

auto state Idle
{



Begin:
	//sleep(1);
	//goto 'Begin';
}


defaultproperties
{
	
}
