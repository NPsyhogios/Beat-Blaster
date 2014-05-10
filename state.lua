-- This file serves as the state glossary for all things related to the state of the game. This includes current screen, character state, etc.

function ChangeFlag(f,b)
	gFlags[f] = b;
end

function ChangeScreen(s)
	gScreen = s;
end

--[[ Available screens:
		
]]

function ChangeCharacterState(s) return s; end

--[[ Available character states:
		Normal: Controls are normal
		Damaged: Character is currently being damaged. Upon being hit, velocity drops to 0 and they are stunned for approximately 0.5 seconds. No character controls will be responsive at this time (Pause menu and quick weapon switch are still available)
		Dead: Character is defeated. No controls will be available during this state.
		Inactive: Character is entering the level or exiting the level. No controls will be available during this state.
]]
