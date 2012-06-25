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
var bool bIsMoving;
var bool bIsStunned;
var bool bIsKnockedDown;

var bool bIsInCombo;            //@TODO: factor out for AI players only
var float maxBlockLengthInSecs;
var float elapsedTimeBlockingInSecs;

//@TODO: these should be enums (punch type should be (high or low) + (left or right))
var string currentPunch;
var string currentBlock;
var string currentMove;


//Punching-------------------------

exec function LeftJab()
{
	AttemptPunch("LeftJab");
}

exec function RightJab()
{
	AttemptPunch("RightJab");
}

exec function LeftHook()
{
	AttemptPunch("LeftHook");
}

exec function RightHook()
{
	AttemptPunch("RightHook");
}

function bool AttemptPunch(string punchType)  //@TODO:all Attempt* functions could be refactored to 1 "AttemptStateChange" function
{
	local bool canPunch;
	canPunch = false;

	if (!bIsPunching && !bIsBlocking && !bIsMoving)
	{
		currentPunch = punchType;
		GotoState('Punching');
		canPunch = true;
	}
	return canPunch;
}

state Punching
{

//boxer is unhittable after first few frames of animation
UnHittable:

	bIsHittable = false;  //@TODO: really the AI guys are not hittable mid-punch whereas the Human players will be
	`Log("[BGFight] PC is punching and hittable = " $bIsHittable );
	sleep(2);  //@TODO: when punching anim is just about done
	goto 'Impact';

Impact:

	//@TODO: if AI bIsHittable = true then record hit (animation, energy down, points up)
	//@TODO: AI and Human go into stun state: can't punch or block or anything
	bIsHittable = true;
	bIsPunching = false;
	`Log("[BGFight] PC is impacting and hittable = " $bIsHittable );
	GotoState('Idle');

//@TODO: implement Tick() to remove sleep()s

//boxer is hittable during windup
Begin:
	
	//@TODO:while punch in is windup mode still hittable
	bIsHittable = true; 
	bIsPunching = true;
	`Log("[BGFight] PC is winding up and hittable = " $bIsHittable );
	sleep(1); //@TODO: after windup time
	goto 'UnHittable'; 
}


//Blocking-------------------------------

exec function BlockHigh()
{
	AttemptBlock("High");
}

exec function BlockLow()
{
	AttemptBlock("Low");
}

function bool AttemptBlock(string blockType)
{
	local bool canBlock;
	canBlock = false;

	if (!bIsPunching && !bIsBlocking && !bIsMoving)
	{
		currentBlock = blockType;
		GotoState('Blocking');
		canBlock = true;
	}
	return canBlock;
}

state Blocking 
{

UnHittable:

	bIsHittable = false;
	`Log("[BGFight] PC is in Blocking state and hittable = " $bIsHittable );
	sleep(1);  //@TODO: do we allow holding block indefinetely, max amount of time or no holding???
	goto 'EndBlock';

EndBlock:

	bIsHittable = true;
	bIsBlocking = false;
	`Log("[BGFight] PC block has ended, exiting Blocking state and hittable = " $bIsHittable );
	GotoState('Idle');

Begin:
	
	bIsHittable = true;
	bIsBlocking = true;
	`Log("[BGFight] PC is begin Blocking state and hittable = " $bIsHittable );
	sleep(0.1); //@TODO: wait for hands to raise
	goto 'UnHittable';
}

//Moving--------------------------------

exec function MoveLeft()
{
	AttemptMove("MoveLeft");
}

exec function MoveRight()
{
	AttemptMove("MoveRight");
}

function bool AttemptMove(string moveType)
{
	local bool canMove;
	canMove = false;

	if (!bIsPunching && !bIsBlocking && !bIsMoving)
	{
		currentMove = moveType;
		GotoState('Moving');
		canMove = true;
	}
	return canMove;
}

state Moving 
{

UnHittable:
	
	bIsHittable = false;
	`Log("[BGFight] PC is in Moving state and hittable = " $bIsHittable );
	sleep(0.3);  //@TODO: allow hold? check for key down? will need another bool that says is key still down?
	goto 'EndMove';

EndMove:

	bIsHittable = true;
	bIsMoving = false;
	`Log("[BGFight] PC move has ended, exiting Moving state and hittable = " $bIsHittable );
	GotoState('Idle');

Begin:
	
	bIsHittable = true;
	bIsMoving = true;
	`Log("[BGFight] PC is begin Moving state and hittable = " $bIsHittable );
	sleep(0.1);
	goto 'UnHittable';
}

//@todo, add some states (which should be subclassed to be reused by AI)
//add HUD and call DisplayDebug stuff

auto state Idle
{



Begin:
	//sleep(1);
	//goto 'Begin';
}

//@TODO:stunned state after punch
//@TODO:knockdown state (can't punch, other boxer can't punch (is Idle))

defaultproperties
{
	bIsHittable = false;
	bIsBlocking = false;
	bIsPunching = false;
	bIsMoving = false;
	bIsStunned = false;
	bIsKnockedDown = false;
	bIsInCombo = false;
	maxBlockLengthInSecs = 2;
	elapsedTimeBlockingInSecs = 0;
}
