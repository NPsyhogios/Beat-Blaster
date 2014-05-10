-- This file handles all of the sound functions in the game.
--[[ functions defined in this .lua file:
	InitializeSoundEffects
	LoopSound
	PlaySound
	StopSound
]]

function PlaySound(g,s)
	love.audio.stop(gSound[g][s].sound);
	love.audio.play(gSound[g][s].sound);
end

function LoopSound(g,s)
	love.audio.stop(gSound[g][s].sound);
	love.audio.play(gSound[g][s].sound);
end

function StopSound(g,s)
	love.audio.stop(gSound[g][s].sound);
end

--[[ SOUND NAME GLOSSARY
	



]]

function InitializeSoundEffects()
	gSound = {
	
		-- enemy sound effects --
		enemy = {
			
			bossdamage = {
				sound = love.audio.newSource("sound/enemy/bossdamage.ogg"),
			},
			
			damage = {
				sound = love.audio.newSource("sound/enemy/damage.ogg"),
			},
			
			death = {
				sound = love.audio.newSource("sound/enemy/death.ogg"),
			},
			
			reflect = {
				sound = love.audio.newSource("sound/enemy/reflect.ogg"),
			},
			
		},
		
		-- player sound effects --
		player = {
			
			charge = {
				sound = love.audio.newSource("sound/player/charge.ogg"),
				loop = true,
				loopstart = 1.000,
				loopend = 5.000
			},
			
			damage =		{ sound = love.audio.newSource("sound/player/damage.ogg") },
			death =			{ sound = love.audio.newSource("sound/player/death.ogg") },
			extralife =		{ sound = love.audio.newSource("sound/player/extralife.ogg") },
			jump =			{ sound = love.audio.newSource("sound/player/jump.ogg") },
			land =			{ sound = love.audio.newSource("sound/player/land.ogg") },
			levelenter =	{ sound = love.audio.newSource("sound/player/levelenter.ogg") },
			levelexit =		{ sound = love.audio.newSource("sound/player/levelexit.ogg") },
			refill =		{ sound = love.audio.newSource("sound/player/refill.ogg") },
			tankfill =		{ sound = love.audio.newSource("sound/player/tankfill.ogg") },
			tankfull =		{ sound = love.audio.newSource("sound/player/tankfull.ogg") },
			water =			{ sound = love.audio.newSource("sound/player/water.ogg") }
			
		},
		
		weapon = {
			normal1 =		{ sound = love.audio.newSource("sound/weapon/normal1.ogg") },
			normal2 =		{ sound = love.audio.newSource("sound/weapon/normal2.ogg") },
			normal3 =		{ sound = love.audio.newSource("sound/weapon/normal3.ogg") },
			normal4 =		{ sound = love.audio.newSource("sound/weapon/normal4.ogg") }
		},
		
		-- stage sound effects --
		stage = {
			
			bossdoorclose =	{ sound = love.audio.newSource("sound/stage/bossdoorclose.ogg") },
			bossdooropen =	{ sound = love.audio.newSource("sound/stage/bossdooropen.ogg") },
			capsuleintro =	{ sound = love.audio.newSource("sound/stage/capsuleintro.ogg") },
			keyitem =		{ sound = love.audio.newSource("sound/stage/keyitem.ogg") }
			
		},
		
		-- system sound effects --
		system = {
		
			beep = {
				sound = love.audio.newSource("sound/system/beep.ogg"),
			},
			
			invalid = {
				sound = love.audio.newSource("sound/system/invalid.ogg"),
			},
			
			menumove = {
				sound = love.audio.newSource("sound/system/menumove.ogg"),
			},
			
			menuselect = {
				sound = love.audio.newSource("sound/system/menuselect.ogg"),
			},
			
			text = {
				sound = love.audio.newSource("sound/system/text.ogg"),
			},
			
		}
		
		
	};
end
