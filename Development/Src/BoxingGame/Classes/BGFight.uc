/**
 *	BGFight
 *
 *	Creation date: 25/05/2012 18:43
 *	Copyright 2012, MattsWin7
 */
class BGFight extends UDKGame
	config(Game);

var int numberOfRounds;
var int currentRound;
var int roundLengthInSeconds;
var int secondsRemainingInRound;
var PlayerController playerController;
var bool bFightHasStarted;

event InitGame( string Options, out string ErrorMessage )
{

}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage)
{
	Super.PreLogin(Options, Address, UniqueId, bSupportsAuth, ErrorMessage);
}

event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
{
	local PlayerController newPlayer;
	newPlayer = Super.Login(Portal, Options, UniqueID, ErrorMessage);
	return newPlayer;
}

event PostLogin( PlayerController NewPlayer )
{
	Super.PostLogin(NewPlayer);
	playerController = NewPlayer;
	SetRoundTimeAndStartRound();
	bFightHasStarted = true;
}

function StartMatch()
{
	Super.StartMatch();	
}

function Reset()
{
	Super.Reset();
	SetRoundTimeAndStartRound();
}

function Timer() 
{
}

function SetRoundTimeAndStartRound()
{
	//reset timelimit
	//TimeLimit = roundLengthInSeconds / 60; //@todo, should be loaded in GameInfo.uc with GetOptionsInt()?
	//`Log("[BGFight] SetRoundTimeAndStartRound()");
	GameReplicationInfo.RemainingTime = roundLengthInSeconds;
	playerController.GotoState('Idle');
	
	// if the round lasted less than one minute, we won't be actually changing RemainingMinute
	// which will prevent it from being replicated, so in that case
	// reduce the time limit by one second to ensure that it is unique
	if ( GameReplicationInfo.RemainingTime == GameReplicationInfo.RemainingMinute )
	{
		GameReplicationInfo.RemainingTime--;
	}
	GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
	GameReplicationInfo.bStopCountDown = false;
	GotoState('RoundInProgress');
}

function EndRound()
{
	currentRound +=1;
	SetRoundTimeAndStartRound();
}

function EndFight()
{
	currentRound = 1;
	GotoState('FightHasEnded');
}

state FightHasEnded
{

Begin:
	//`Log("[BGFight] Entered FightHasEnded state.");
}

state RoundInProgress
{
	function Timer()
	{
		//`Log("[BGFight] Time remaining in round is " $GameReplicationInfo.RemainingTime);
		//`Log("[BGFight] Current round is " $currentRound);
		//`Log("[BGFight] Player controller is in state " $playerController.GetStateName());
		
		Global.Timer();

		if (GameReplicationInfo.RemainingTime <= 0)
		{
			if (currentRound == numberOfRounds)
			{
				EndFight();
			}
			else
			{
				EndRound();
			}
		}
	}

Begin:
	//`Log("[BGFight] Entered RoundInProgress state.");
}

//@todo: add state for round has ended

defaultproperties
{
	PlayerControllerClass=class'BoxingGame.BoxingPC';

	//bDelayedStart=false;
	//bWaitingToStartMatch=true;

	bFightHasStarted = false;
	
	numberOfRounds = 3;
	currentRound = 1;	
	roundLengthInSeconds = 10;
	secondsRemainingInRound = roundLengthInSeconds;
}
