/**
 *	BoxingPC
 *
 *	Creation date: 31/05/2012 19:32
 *	Copyright 2012, MattsWin7
 */
class BoxingPC extends PlayerController;

var bool bIsHittable;
var bool bIsBlocking;
var bool bIsPunching;
var string currentPunch;

exec function LeftJab()
{
	if (bIsPunching || bIsBlocking) return;
	currentPunch = 'LeftJab';
	GotoState('Punching');
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

state Punching
{

//boxer is unhittable after first few frames of animation
UnHittable:

	bIsHittable = false;
	`Log("[BGFight] PC is punching and hittable = " $bIsHittable );
	sleep(2);  //@TODO: when punching anim is done
	goto 'Impact';

Impact:

	`Log("[BGFight] PC is impacting and hittable = " $bIsHittable );
	//@TODO: if AI bIsHittable = true then record hit (animation, energy down, points up)
	GotoState('Idle');
	
//boxer is hittable during windup
Begin:
	
	//@TODO:while punch in is windup mode still hittable
	bIsHittable = true;
	`Log("[BGFight] PC is winding up and hittable = " $bIsHittable );
	sleep(1); //@TODO: after windup time
	goto 'UnHittable'; 
}

//@TODO:blocking state (can't punch, can't be punched)

//@TODO:knockdown state (can't punch, other boxer can't punch (is Idle))

defaultproperties
{
	bIsHittable = false;
	bIsBlocking = false;
	bIsPunching = false;
}
