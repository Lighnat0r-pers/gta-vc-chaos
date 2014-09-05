Chaos% by Lighnat0r:

Welcome to Chaos%! This mod will cause all kinds of effects to trigger while playing GTA: Vice City. As it does not change any game files, you do not have to worry about messing up the game.

Instructions:
Start the program either before or during running Vice City.
When you start the program you will be greeted by a window with several options.
The first is an input box for the seed (a number of your own choosing). The seed affects which permanent effects will be enabled and which timed effects are picked when. Entering all zeros will disable all permanent effects.
Below this are the following options: 
Difficulty - This changes how many permanent effects are enabled. Timed effects are as of yet NOT affected by this (will change in the future).
Static effects enabled - Unchecking this will disable static effects.
Timed effects enabled - Unchecking this will disable timed effects.
Sånic mode enabled - Checking this will cause the timed effects to switch 10 times as fast.
After you are happy with the settings, confirm them and start playing!

Closing Chaos% will automatically restore the game to its normal state. If something doesn't, contact me so I can fix the bug. Restarting the game will always remove all traces of Chaos%, as it doesn't change the game files.
Note: Saves created while running Chaos% might retain some traces of the mod, such as changed maximum health. 

Created by Lighnat0r
Contact me at Lighnat0r@gmail.com for any questions, bugs, suggestions or find me in the speedrunslive.com #gta irc channel. You can also message me on Twitch (www.twitch.tv/Lighnat0r)

Version 1.12 Updates:
ESA Hype!
Night% is now called Eclipse%.
Home% difficulty increased from 3 to 4.
Rave% difficulty increased from 2 to 3.
SuddenCarDeath% can no longer trigger during Cherry Poppers.




List of effects:
Static:
	CrazyCones%			(Cones are bouncy)

Permanent:
[4]	PackageHealth% 			(Your max health equals twice the amount of packages collected)
[4]	Vampire%			(You gain health for killing people, but lose health during daytime)
[3]	MissionSuicide% 		(Die after every mission completion)
[2]	Flintstone% 			(Force the walking in car glitch. This also changes the control scheme in a car, refer to http://imgur.com/UckV0fI)
[2]	NoDriveby% 			(Disable drive-by's)
[5]	Immersion% 			(Disable HUD and radar)
[2]	AngryDrivers% 			(All random vehicles are angry drivers and car collisions are more extreme)
[2]	Bounce%				(Cars have very limited suspension damping)
[3]	ImTheInvisibleDriver% 		(Any vehicle you get in becomes invisible)
[2]	Rayman%				(Punching while running will deal massive damage to everything in a sizable radius)
[2]	NoMagicalBackpack%		(You have just one weapon slot available)


Timed:
[2]	FlatTire% 			(Both tires flattened if on bike, back left/right and front left tire flattened if in car)
[1]	ToFlatTireOrNotToFlatTire%	(Continuously pop and restore your tires)
[1]	DrunkCam%			(Activate the drunk camera)
[2]	Interior% 			(Load a pseudo-random interior)
[1]	Mirage% 			(Objects/buildings appear/disappear depending on viewing angle)
[1]	Eclipse%			(The world becomes a very dark place)
[1]	Wanted1% 			(Get a 1 star wanted level)
[2]	Wanted2% 			(Get a 2 star wanted level)
[3]	Wanted3% 			(Get a 3 star wanted level)
[3]	Wanted4% 			(Get a 4 star wanted level)
[4]	Wanted5% 			(Get a 5 star wanted level)
[5]	Wanted6% 			(Get a 6 star wanted level)
[2]	BeamMeUpScotty%			(Gravity is negative)
[1]	ZeroGravity% 			(Gravity is reduced to zero)
[2]	QuarterGravity% 		(Gravity is reduced to a quarter of normal)
[1]	HalfGravity% 			(Gravity is reduced to half of normal)
[2]	DoubleGravity% 			(Gravity is increased to the double of normal)
[3]	QuadrupleGravity% 		(Gravity is increased to the quadruple of normal)
[3]	QuarterGameSpeed% 		(The game runs at quarter speed)
[2]	HalfGameSpeed% 			(The game runs at half speed)
[2]/[2]	DoubleGameSpeed% 		(The game runs at double speed)
[1]	Lag% 				(Alternate between 0.25x and 2x game speed)
[2]	AngryDrivers% 			(All random vehicles are angry drivers and car collisions are more extreme)
[3]	Polaris% 			(Disables pathfinding for pedestrians)
[2]	GhostTown%			(No random vehicle and pedestrian spawns)
[2]	NoRight% 			(Disable right turns)
[3]	HighDPI%			(The mouse becomes 10x more sensitive)
[3]	LowDPI%				(The mouse becomes 10x less sensitive)
[1]	RainbowCar% 			(Cycle through all the possible car colours)
[2]	ImTheInvisibleDriver% 		(Tommy and his car become invisible)
[3]	AstralProjection%		(Tommy is separated from his body)
[1]/[2]	RandomFall% 			(Tommy falls down)
[1]	LetsTakeABreak% 		(Tommy is uncontrollable for a shot period of time)
[1]	PhoneCall% 			(Tommy thinks he's getting a call)
[4]	FrameLimiter15% 		(Set frame limiter to 15 fps)
[4]	FrameLimiter60% 		(Set frame limiter to 60 fps)
[1]	SuddenCarDeath% 		(Set your car's health to just above burning)
[1]	PitStop%			(Restores your car to full health at the cost of all speed)
[2]	ZeroDrawDistance% 		(Draw distance is set to 0)
[2]	EighthDrawDistance% 		(Draw distance is set to an eighth of the normal value)
[1]	QuarterDrawDistance% 		(Draw distance is set to a quarter of the normal value)
[2]	HalfDrawDistance% 		(Draw distance is set to half the normal value)
[2]	DoubleDrawDistance% 		(Draw distance is set to double the normal value)
[2]	NoBounce%			(Cars have much higher suspension damping)
[1]	Bounce%				(Cars have very limited suspension damping)
[2]	BouncyBounce%			(Cars have nearly zero suspension damping)
[4]	Home%				(Teleport to the Ocean View Hotel)
[3]	Rave%				(Teleport to the Malibu Club)
[5]	Pacifist%			(None of your weapons do damage)

How timed effects work:
Every timed effect has a difficulty and weight as shown in the list above ([Difficulty]/[Weight]). Higher difficulty tier effects have a reduced chance to activate.
For every timed effect, there's a definition when it can or cannot trigger (in which missions, not on a mission, while on foot/in a certain vehicle etc)
Categories are used to group certain effects together. One effect per category is chosen per loop, so similar effects are unlikely to follow eachother.
Effects that are chosen but then skipped for whatever reason will still count towards the loop completion.

When a new effect has to be picked, the program will calculate a (pseudo-random) number based on the seed. That number is linked to an effect. Every effect has [Weight] numbers linked to it.
Then the program checks if the category the effect belongs to has not been activated yet in the current loop and if the effect is able to activate.
Another (pseudo-random) number is calculated based on the seed is picked from the range of 1 to [Difficulty]. If that is not equal to 1 the effect is skipped.



Issues:
Might not function properly if you first run one version of Vice City while Chaos% is running, then switch to a different version without restarting Chaos% (e.g. first the retail version then the steam version).
After running the updater, the tray icon of the old version will not disappear automatically.
The game can be more unstable because of Chaos% at times. Continuously working on this.
