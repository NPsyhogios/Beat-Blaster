--[[ functions defined in this .lua file:
CheckIfTable
deepcopy
Trace
]]

-- ADDITIONAL LUA FILES --
	love.filesystem.load("camera.lua")()
	love.filesystem.load("draw.lua")()
	love.filesystem.load("ui.lua")()
	love.filesystem.load("file.lua")()
	love.filesystem.load("input.lua")()
	love.filesystem.load("level.lua")()
	love.filesystem.load("mouse.lua")()
	love.filesystem.load("sprite.lua")()
	love.filesystem.load("state.lua")()
	
	love.filesystem.load("dialog/dialog.lua")()
	love.filesystem.load("menu/menu.lua")()
	love.filesystem.load("music/music.lua")()
	love.filesystem.load("sound/sound.lua")()
	love.filesystem.load("transition/transition.lua")()
--------------------------

-- GLOBAL VARIABLE INITIALIZATION --

	gHelpMenu = true;

	gGameTime = 0;	-- timer used for sprites
	gTime = 0; 		-- global timer used for sprites and movement
	gUpdate = 0;
	
	gCurScreen = "Gameplay";
	gMenu = nil;
	gDialog = nil;	-- dialog boxes for entering info for the level and its patterns
	gEditValues = nil;
	gEditMode = "Bullet";
	gEditing = false;
	gShowPatterns = false;
	gPatternPos = 0;
	gPatternSelected = nil;
	gAlphaPatternType = 0;
	bUp = false;
	bDown = false;
	
	_up = love.graphics.newImage('img/up.png');
	_down = love.graphics.newImage('img/down.png');
	
	gMouse = {x = 0, y = 0, bullets = nil }; -- mouse variable, contains position and whether mouse buttons have been pressed
	
	-- level variables --
	gLevelData = nil;
	gBulletData = nil;
	gTempBulletData = nil;
	gLevelStats = nil;
	gLevelPrepared = false;
	gActiveBullets = 0;
	gPlayer = nil;
	
	gTempPattern = {};
	gTempPatternText = nil;
	
	gPaused = true;
	gPauseAction = true;	-- Action to take when the pause state changes
	gInTransition = false;
	gCountdownTime = 0;
	gInCountdown = false;
	
	font = love.graphics.newFont(14);
	love.graphics.setFont(font);
	
	-- notation variables --
	_Whole = 0;
	_Half = 0;
	_4th = 0;
	_8th = 0;
	_12th = 0;
	_16th = 0;
	_24th = 0;
	_32nd = 0;
	_48th = 0;
	_64th = 0;

	-- music variables --
	gMusic = {};
	-- sound variables --
	gSound = {};
	
	-- window variables --
	SCREENW = love.window.getWidth();
	SCREENH = love.window.getHeight();
------------------------------------

function love.load()
	gBulletPatternButtons = {
		copy =				{img = love.graphics.newImage('img/copy.png'),				x = SCREENW-285, y = SCREENH-75};
		delete =			{img = love.graphics.newImage('img/delete.png'),			x = SCREENW-285, y = SCREENH-50};
		deletequeue =		{img = love.graphics.newImage('img/deletequeue.png'),		x = SCREENW-285, y = SCREENH-25};
		editattributes =	{img = love.graphics.newImage('img/editattributes.png'),	x = SCREENW-116, y = SCREENH-50};
		editqueue =			{img = love.graphics.newImage('img/editqueue.png'),			x = SCREENW-116, y = SCREENH-25};
		editrequirements =	{img = love.graphics.newImage('img/editrequirements.png'),	x = SCREENW-116, y = SCREENH-75};
	};

	gLog = io.open("log.txt","w+");
	
	gMenu = NewMenu("Main");
	
	InitializeSoundtrack();
	InitializeSoundEffects();
	InitializeTransitions();
	InitializeSprites();
	InitializeEditValues();
	
end

function love.update( dt )
	gUpdate = gUpdate + dt;
	gFPS = dt;
	gTime = gTime + dt;
	gGameTime = gGameTime + dt;
	
	if gUpdate <= 1/60 then return;
	else gUpdate = 0; end
	
	
	--if not gPaused and not gInTransition then
	--end
	
	if gAlphaPatternType > 0 then
		gAlphaPatternType = gAlphaPatternType - 5;
	end
	UpdateTransition();
	UpdateMouseCoordinates();
	
	--camera:setPosition(0,0);
	
	UpdateSpriteFrames();
	--UpdateMouseCursor();
	
	
	if gCurScreen == "Gameplay" then
		--PauseLevelMusic();
		if gLevelPrepared and not gPaused then 
			if gLevelData.song then LoopLevelMusic(); end
			if gMusic.curSong then LoopMusic(); end
			UpdateBullets(gLevelStats.difficulty);
			CollisionCheck(gLevelStats.difficulty);
		end
	end
	
	if gInCountdown then CheckCountdown(); end
	
	HeldKey();
end

function love.draw()
	camera.set();

	-- Background and map
	love.graphics.setBackgroundColor(0x00,0x00,0x00)
	
	DrawBackground();		-- The background imagery
	DrawScreenElements();	-- Sprites like the player avatar, the enemy, and the bullets
	DrawUI();				-- User Interface elements like score, enemy health, notefield.
	DrawDialog(gDialog);	-- Dialog boxes that let the user enter various information, or display important information.
	DrawMenu(gMenu);		-- Menu elements like cursor, and the options
	DrawTransition();		-- Screen transitions that cover visible image assets changing
	DrawMouse();
	
	-- temporary layer
	DrawDebugText();

	camera.unset();
	
end



function Trace(s)
	local f = gTime;
	local minute,second = 0,0;
	while f >= 1 do
		f = f - 1;
		second = second + 1;
		while second >= 60 do
			second = second - 60;
			minute = minute + 1;
		end
	end
	
	if second < 10 then second = tostring('0'..second); end
	f = math.floor(f*1000);
	if f < 100 then if f < 10 then f = tostring('00'..f); else f = tostring('0'..f); end end
	
	local t = tostring(minute..':'..second..'.'..f..': ')
	
	
	gLog:write(t,s,"\n");
end



--[[	This function helps determine whether or not the variable in question (the first parameter) is a table or not.
		The second parameter is the name of a function. If it is a table, then that table's elements are broken down and checked.
		If not, then the function originally passed as the second parameter executes, using the variable as the argument.]]
function CheckIfTable(t,fun)
	for i,v in pairs(t) do
		if type(v) == "table" then
			CheckIfTable(v,fun);
		else
			_G[fun](v);
		end
	end
end

-- This function fully copies a table to a variable without it being simply a reference.
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GetLevelFolders()
	
	local lfs = love.filesystem;
	gEditValues.folders = lfs.getDirectoryItems("level");
	for i = #gEditValues.folders, 1, -1 do
		if not lfs.isDirectory('level/'..gEditValues.folders[i]) then
			table.remove(gEditValues.folders,i)
		end
	end
	
	table.sort(gEditValues.folders,function(a,b) 
		  s1 = a:gsub("_","-"):lower() 
		  s2 = b:gsub("_","-"):lower() 
		  return s1 < s2 
	end)
	
	for i = #gEditValues.folders, 1, -1 do
		Trace(gEditValues.folders[i]);
	end
end

function Round(num)
	return math.floor(num + 0.5)
end
