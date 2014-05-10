--[[ functions defined in this .lua file:
CalculateNotation
CancelBullets
ChangeAttributes
CollisionCheck
FireBullet
GetAngleToPlayer
InitializePatterns
LoadLevelData
LoadBulletData
UpdateBullets



]]

function LoadLevelData(path)
	leveldata = love.filesystem.load('level/'..path..'/data.lua')();
	return leveldata;
end

function LoadBulletData(path)
	bulletdata = love.filesystem.load('level/'..path..'/bullets.lua')();
	return bulletdata;
end



function GetAngleToPlayer(bullet)
	local angle;
	-- This function calculates the angle from the boss to the player.
	-- Angle starts at directly right (0) and circles around clockwise.
	-- 360 is also directly right.
	
	--if not comp then comp = 0; end
	local xdiff = bullet.x - gPlayer.x;
	local ydiff = bullet.y - gPlayer.y;
	angle = (math.atan2(ydiff,xdiff) * (180 / math.pi) - 180);
	
	return angle;
end



function UpdateBullets(difficulty)
	for i,v in ipairs(gBulletData[difficulty].bulletpatterns) do
		if not v.fired and not v.active then			-- First check: see if the bullet has been fired and if it is active on screen.
			if v.start <= gLevelData.song:tell() then	-- Second check: see if the bullet start time is greater then current song time
				if v.inLoop then
					FireBullet(gBulletData[difficulty].bulletpatterns[i]);
			elseif gLevelStats.loops == 0 then
					FireBullet(gBulletData[difficulty].bulletpatterns[i]);
				end
			end
		end
		
		if v.active then
			
			-- update the velocity
			gBulletData[difficulty].bulletpatterns[i].xvel = gBulletData[difficulty].bulletpatterns[i].xvel + gBulletData[difficulty].bulletpatterns[i].xaccel;
			gBulletData[difficulty].bulletpatterns[i].yvel = gBulletData[difficulty].bulletpatterns[i].yvel + gBulletData[difficulty].bulletpatterns[i].yaccel;
			-- update the position
			gBulletData[difficulty].bulletpatterns[i].x = gBulletData[difficulty].bulletpatterns[i].x + gBulletData[difficulty].bulletpatterns[i].xvel;
			gBulletData[difficulty].bulletpatterns[i].y = gBulletData[difficulty].bulletpatterns[i].y + gBulletData[difficulty].bulletpatterns[i].yvel;
			-- update angle for drawing
			gBulletData[difficulty].bulletpatterns[i].angle = math.atan2(v.yvel,v.xvel)
			
			if v.queue then
				if v.qindex <= #v.queue then	-- check for queue times and apply attribute changes accordingly
					local newTime = v.fireTime;
					for j = 1,v.qindex do
						newTime = newTime + v.queue[j][1](gBulletData[difficulty].bulletpatterns[i].iter);
					end
					if newTime < gGameTime then
						ChangeAttributes(gBulletData[difficulty].bulletpatterns[i],v.queue[v.qindex][2]);
						gBulletData[difficulty].bulletpatterns[i].qindex = gBulletData[difficulty].bulletpatterns[i].qindex + 1;
					end
				end
			end
			
			if gBulletData[difficulty].bulletpatterns[i].x + gBulletData[difficulty].bulletpatterns[i].bullet.sprite.tilewidth/2 < 0 or
				gBulletData[difficulty].bulletpatterns[i].x - gBulletData[difficulty].bulletpatterns[i].bullet.sprite.tilewidth/2 > SCREENW or
				gBulletData[difficulty].bulletpatterns[i].y + gBulletData[difficulty].bulletpatterns[i].bullet.sprite.tileheight/2 < 0 or
				gBulletData[difficulty].bulletpatterns[i].y - gBulletData[difficulty].bulletpatterns[i].bullet.sprite.tileheight/2 > SCREENH then
				
				gBulletData[difficulty].bulletpatterns[i].active = false;
				gBulletData[difficulty].bulletpatterns[i].qindex = 1;
			end
		end
	end
	
	

end

function FireBullet(bullet)
	local t = {"x","y","angle","speed","xaccel","yaccel"};
	CalculateNotation(bullet.BPM);
	for i,v in ipairs(t) do
		if type(bullet.attributes[i]) == "function" then
			bullet[v] = bullet.attributes[i](bullet.iter,bullet);
			if v == "speed" then
				bullet.angle = math.rad(bullet.angle);
				bullet.xvel = math.cos(bullet.angle) * bullet.speed;
				bullet.yvel = math.sin(bullet.angle) * bullet.speed;
			end
		end
	end
	
	bullet.active = true;
	bullet.fired = true;
	bullet.fireTime = gGameTime;
end

-- The main function to change all bullet attributes at once.
function ChangeAttributes(bullet,attributes)
		if attributes[1](bullet.iter,bullet) then bullet.x = attributes[1](bullet.iter,bullet); end
		if attributes[2](bullet.iter,bullet) then bullet.y = attributes[2](bullet.iter,bullet); end
		
		if attributes[3](bullet.iter,bullet) then
			bullet.angle = math.rad(attributes[3](bullet.iter,bullet));
			bullet.xvel = math.cos(bullet.angle) * bullet.speed;
			bullet.yvel = math.sin(bullet.angle) * bullet.speed;
		end
		
		if attributes[4](bullet.iter,bullet) then 
			bullet.xvel = math.cos(bullet.angle) * attributes[4](bullet.iter,bullet);
			bullet.yvel = math.sin(bullet.angle) * attributes[4](bullet.iter,bullet);
		end
		
		if attributes[5](bullet.iter,bullet) then bullet.xaccel = attributes[5](bullet.iter,bullet); end
		if attributes[6](bullet.iter,bullet) then bullet.yaccel = attributes[6](bullet.iter,bullet); end
end

function CancelBullets()
	-- This will destroy all bullets.
	for i,v in ipairs(gBulletData[gEditValues.difficulty].bulletpatterns) do
		gBulletData[gEditValues.difficulty].bulletpatterns[i].active = false;
	end
end

function CollisionCheck(difficulty)
	-- if gPlayer.invuln == 0 then
		for i,v in ipairs(gBulletData[difficulty].bulletpatterns) do
			if v.active then
				if gPlayer.x + gPlayer.width/2 > v.x - v.bullet.width and gPlayer.x - gPlayer.width/2 < v.x + v.bullet.width and -- x axis check
					gPlayer.y + gPlayer.height/2 > v.y - v.bullet.height and gPlayer.y - gPlayer.height/2 < v.y + v.bullet.height then -- y axis check
					--os.exit(0);
					--CancelBullets();
					--break;
				end
			end
		end
	--end
	-- Only track active bullets (to save processing power) to see if hitting the player or not
end

function CalculateNotation(BPM)
	-- This function stores values in these variable notations to make it easier for time calculation.
	_Whole = 240/BPM;
	_Half = _Whole/2;
	_4th = _Whole/4;
	_8th = _Whole/8;
	_12th = _Whole/12;
	_16th = _Whole/16;
	_24th = _Whole/24;
	_32nd = _Whole/32;
	_48th = _Whole/48;
	_64th = _Whole/64;
end


-- This function is used to extract tables out of a table and add then to the main pattern table.
function ExtractPatterns(difficulty)
	local temptable = {};
	
	-- reverse iteration, populate temptable with pseudo-for loop and remove extraction table from pattern table
	for i = #(gBulletData[difficulty].bulletpatterns), 1, -1 do
		for j=0,gBulletData[difficulty].bulletpatterns[i].iter-1 do
			local t = deepcopy(gBulletData[difficulty].bulletpatterns[i].tbl);
			t.iter = j; -- store the iteration variable
			if type(t.add) == "function" then
				t.start = t.start + t.add(j);
				--Trace("Start function value evaluated");
			end
			
			t.BPM = gLevelData.BPM;
			if gLevelData.BPMchanges then
				for k,w in ipairs(gLevelData.BPMchanges) do
					if t.start >= w[1] then
						t.BPM = w[2];
					else break; end
				end
			end
			
			table.insert(temptable,t);
		end
		table.remove(gBulletData[difficulty].bulletpatterns,i);
	end
	
	-- insert extracted pseudo-for loop tables into the main pattern table
	for i,v in ipairs(temptable) do
		table.insert(gBulletData[difficulty].bulletpatterns,v)
	end
end

-- This function will give starting attributes to all bullets.
function InitializePatterns(difficulty)
	for i,v in ipairs(gBulletData[difficulty].bulletpatterns) do
	
		if gLevelData.bullettype[gBulletData[difficulty].bulletpatterns[i].btype] then
			gBulletData[difficulty].bulletpatterns[i].bullet = gLevelData.bullettype[gBulletData[difficulty].bulletpatterns[i].btype]; -- Initialize the sprite
		else
			gBulletData[difficulty].bulletpatterns[i].bullet = gLevelData.bullettype[gLevelData.bullettype.default];
			Trace('Warning: Default bullet type used in '..gEditValues.name..'/'..gEditValues.difficulty..', index'..i)
		end
		
		gBulletData[difficulty].bulletpatterns[i].fired = false;
		gBulletData[difficulty].bulletpatterns[i].active = false;
		gBulletData[difficulty].bulletpatterns[i].fireTime = 0;
		
		if gBulletData[difficulty].bulletpatterns[i].start >= gLevelData.loopstart then
			gBulletData[difficulty].bulletpatterns[i].inLoop = true;
		else
			gBulletData[difficulty].bulletpatterns[i].inLoop = false;
		end
		
		gBulletData[difficulty].bulletpatterns[i].qindex = 1;		-- initialize queue index
		gBulletData[difficulty].bulletpatterns[i].fireTime = 0;		-- This variable records when the shot is fired, in game time.

	end
end

-- Call this EVERY time a new pattern is added or deleted.
function SortPatterns(difficulty)
	gEditValues.origindex = {};
	
	if #gTempBulletData[difficulty].bulletpatterns >= 1 then
		for i,v in ipairs(gTempBulletData[difficulty].bulletpatterns) do
			table.insert(gEditValues.origindex,{})
			table.insert(gEditValues.origindex[#gEditValues.origindex],i)	-- store original index
			table.insert(gEditValues.origindex[#gEditValues.origindex],v.tbl.start);
		end
		table.sort(gEditValues.origindex, function(a,b) return a[2] < b[2] end);
	end
end



function InitializeLevelStats(l,d)
	gLevelStats = nil;
	gLevelStats = {
		loops = 0,
		score = 0,
		bossLife = gLevelData.health,	-- The amount of health the boss has remaining
		playerLife = 3,					-- The number of lives a player has remaining.
		curCombo = 0,					-- The current number of notes hit in a row without missing.
		maxCombo = 0,
		difficulty = d,
		level = l
	};
end

function InitializeCharacter()
	local g = love.graphics;
		gPlayer = {

		-- ship image --
		img = g.newImage("level/ship.png");
		
		-- coordinates and dimensions --
		x = SCREENW/2,
		y = SCREENH-100,
		width = 2,
		height = 2,
		
		-- gameplay --
		state = "Normal",
		lives = 3, -- number of lives the player has
		invuln = 0,
		
		};
end



-- This function calls a few other functions necessary to completely load a level.
function PrepareLevel(level,difficulty)
	
	gLevelData = nil;
	gLevelData = LoadLevelData(level);		-- This loads the table with the main level data.
	gBulletData = nil;
	gBulletData = LoadBulletData(level);	-- This loads the table with the bullet data.
	gTempBulletData = LoadBulletData(level);	-- An extra copy is loaded to add things from the editor.
	InitializeLevelStats(level,difficulty);
	CalculateNotation(gLevelData.BPM);
	InitializeCharacter();
	InitializeCursorBullets();
	
	gLevelPrepared = true;
	
end

function InitializeCursorBullets()
	gMouse.bullets = {};
	for i,v in ipairs(gLevelData.bullettype) do
		--local t = deepcopy(gLevelData.bullettype[i].sprite);
		--table.insert(gMouse.bullets,t);
		table.insert(gMouse.bullets,gLevelData.bullettype[i].sprite)
	end
end

function PlayLevel()
	gBulletData = deepcopy(gTempBulletData);
	ExtractPatterns(gEditValues.difficulty);							-- This extracts pseudo-for loop patterns from within the bullet data.
	InitializePatterns(gEditValues.difficulty);							-- This gives all bullets their starting attributes.
	
	for i,v in ipairs(gBulletData[gEditValues.difficulty].bulletpatterns) do
		if v.start < gEditValues.curSecond then
			gBulletData[gEditValues.difficulty].bulletpatterns[i].fired = true;
		end
	end
	
	love.audio.play(gLevelData.song);
	gLevelData.song:seek(gEditValues.curSecond);
	gPaused = false;
end

function StopLevel()
	gBulletData = nil;
	StopLevelMusic();
	gPlayer.x = SCREENW/2;
	gPlayer.y = SCREENH-100;
	gPaused = true;
end

function InitializeEditValues()
	gEditValues = nil;
	gEditValues = {
		folders = nil,
		name = nil,
		difficulty = nil,
		curSecond = 0,
		curNotation = 1,
		notation = {"Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"},
		curBulletType = 1
	};
	GetLevelFolders();
end





function StoreAttributes(d,temp)
	-- We will need to concatenate gTempPatternText thruoghout this function.
	local s,f;	-- string and function variables used throughout the storing process
	
	-- Safety measure against empty strings and breaking the functions.
	for i,v in pairs(d.textbox) do
		if d.textbox[i].text == "" then d.textbox[i].text = "0"; end
	end
	
	-- BASIC ATTRIBUTES --
	temp.iter = tonumber(d.textbox.bullets.text);
	gTempPatternText = gTempPatternText..'{iter = '..d.textbox.bullets.text..', tbl = {btype = '..gEditValues.curBulletType..', start = '..d.textbox.startbase.text..', add = ';
	temp.tbl = {};
	temp.tbl.btype = gEditValues.curBulletType;
	temp.tbl.start = tonumber(d.textbox.startbase.text);
	
	-- START AND ADD ATTRIBUTES --
	s = d.dropmenu.start.text
	f = "return function(i) return i*";
	if s == "Custom" then f = f..d.textbox.startincrement.text..' end';
	else f = f..'_'..s..' end'; end
	gTempPatternText = gTempPatternText..string.sub(f,8)..', attributes = {';
	f = load(f);
	temp.tbl.add = f();
	s = ""; f = "";
	
	-- ATTRIBUTES --
	temp.tbl.attributes = {};
	local t = {"x","y","angle","speed","xaccel","yaccel"}
	for i,v in ipairs(t) do
		s = d.dropmenu[v].text;
			f = "return function(i,bullet) return ("
		if s == "Increment" then
			f = f..d.textbox[v.."base"].text.." + i*"..d.textbox[v..string.lower(s)].text;
	elseif s == "Variance" then
			f = f..d.textbox[v.."base"].text.." + math."
			if d.dropmenu[v.."variance"].text == "Sine" then
				f = f.."sin";
			else
				f = f.."cos";
			end
			f = f.."(((2*math.pi)/";
			if d.dropmenu[v.."variancenotation"].text == "Custom" then
				f = f..d.textbox[v.."variancespeed"].text;
			else
				f = f.."_"..d.dropmenu[v.."variancenotation"].text;
			end
			f = f..")*("..d.textbox.startbase.text.."+i*"
			if d.dropmenu.start.text == "Custom" then f = f..d.textbox.startincrement.text;
			else f = f..'_'..d.dropmenu.start.text; end
			f = f.."))*"..d.textbox[v.."variance"].text;
	elseif s == "Random" then
			f = f.."(math.random()*(("..d.textbox[v.."randomupper"].text..")-("..d.textbox[v.."randomlower"].text..")))+("..d.textbox[v.."randomlower"].text..")";
		end
		
		f = f..")"		--	entire main function is now closed off
		s = AddSpecialAttribute(f,v,temp,d)
		f = f..s;
		f = f.." end";	-- Finalize the function
		
		gTempPatternText = gTempPatternText..string.sub(f,8)..', ';
		Trace("Function: "..f);
		f = load(f);
		table.insert(temp.tbl.attributes,f());
	end
	gTempPatternText = string.sub(gTempPatternText,1,-3) -- Get rid of the extra comma
	gTempPatternText = gTempPatternText..'}, ';
	
end

function AddSpecialAttribute(f,v,temp,d)
	local s = "";
	
	if v == "x" or v == "y" then
		if d.dropmenu[v.."origin"].text ~= "Screen" then
			s = " + g"..d.dropmenu[v.."origin"].text.."."..v;
		end
elseif v == "angle" then
		if d.dropmenu.angletype.text == "Player" then
			s = " + GetAngleToPlayer(bullet)";
		end
elseif v == "xaccel" or v == "yaccel" then
		if d.dropmenu[v.."base"].text == "Bullet" then
			s = " * bullet."..string.sub(v,1,1).."vel";
		end
	end
		
	return s
end

function StoreRequirements(d,temp)
	-- Safety measure against empty strings and breaking the functions.
	for i,v in pairs(d.textbox) do
		if d.textbox[i].text == "" then d.textbox[i].text = "0"; end
	end
	
	local f;
	
	-- set loop requirements
	f = 'return function(l) return ';
	if d.dropmenu.loopreq.text == "(no condition)" then 
		f = f..'true';
elseif d.dropmenu.loopreq.text == "Less than or equal to" then
		f = f..'l <= '..d.textbox.loopless.text;
elseif d.dropmenu.loopreq.text == "Greater than or equal to" then
		f = f..'l >= '..d.textbox.loopgreater.text;
elseif d.dropmenu.loopreq.text == "Exactly" then
		f = f..'l == '..d.textbox.loopequal.text;
elseif d.dropmenu.loopreq.text == "Every" then	
		f = f..'math.max('..d.textbox.loopstart.text..'-l,0)+math.mod(l,'..d.textbox.loopmod.text..') == 0';
	end
	f = f..'; end'
	
	gTempPatternText = gTempPatternText..'loop = '..string.sub(f,8)..', ';
	Trace("Function: "..f);
	f = load(f);
	temp.loop = f();
	
	-- set health requirements
	f = 'return function(h) return ';
	if d.dropmenu.healthreq.text == "(no condition)" then
		f = f..'true';
elseif d.dropmenu.healthreq.text == "Less than or equal to" then
		f = f..'h <= '..d.textbox.healthless.text;
elseif d.dropmenu.healthreq.text == "Greater than or equal to" then
		f = f..'h >= '..d.textbox.healthgreater.text;
elseif d.dropmenu.healthreq.text == "Between" then
		f = f..d.textbox.healthlower.text..' <= h and h <= '..d.textbox.healthupper.text;
	end
	f = f..'; end'
		
	gTempPatternText = gTempPatternText..'health = '..string.sub(f,8)..', ';
	Trace("Function: "..f);
	f = load(f);
	temp.health = f();
end





function StoreQueue(d,temp) -- next step!
	local s,f;
	
	-- Safety measure against empty strings and breaking the functions.
	for i,v in pairs(d.textbox) do
		if d.textbox[i].text == "" then d.textbox[i].text = "0"; end
	end
	
	table.insert(temp.tbl.queue,{});	-- prepare an empty table at the end of the queue to fill
	
	f = "return function(i) return "
	f = f..d.textbox.queuebase.text;
	
	if d.dropmenu.sign.text == "Add" then
		f = f..' + ';
	else
		f = f..' - ';
	end
	
	f = f..'(i*';
	if d.dropmenu.queuediff.text == "Custom" then
		f = f..d.textbox.queuediff.text;
	else
		f = f..'_'..d.dropmenu.queuediff.text;
	end
	f = f..') end';
	
	gTempPatternText = gTempPatternText..'{'..string.sub(f,8)..', {';
	Trace("Function: "..f);
	f = load(f);
	table.insert(temp.tbl.queue[#temp.tbl.queue],f());
	table.insert(temp.tbl.queue[#temp.tbl.queue],{});
	
	local t = {"x","y","angle","speed","xaccel","yaccel"}
	for i,v in ipairs(t) do
		s = d.dropmenu[v].text;
			f = "return function(i,bullet) return ("
		if s == "(no change)" then
			f = f..'nil';
	elseif s == "Increment" then
			f = f..d.textbox[v.."base"].text.." + i*"..d.textbox[v..string.lower(s)].text;
	elseif s == "Variance" then
			f = f..d.textbox[v.."base"].text.." + math."
			if d.dropmenu[v.."variance"].text == "Sine" then
				f = f.."sin";
			else
				f = f.."cos";
			end
			f = f.."(((2*math.pi)/";
			if d.dropmenu[v.."variancenotation"].text == "Custom" then
				f = f..d.textbox[v.."variancespeed"].text;
			else
				f = f.."_"..d.dropmenu[v.."variancenotation"].text;
			end
			f = f..")*("..d.textbox.startbase.text.."+i*"
			if d.dropmenu.start.text == "Custom" then f = f..d.textbox.startincrement.text;
			else f = f..'_'..d.dropmenu.start.text; end
			f = f.."))*"..d.textbox[v.."variance"].text;
	elseif s == "Random" then
			f = f.."(math.random()*(("..d.textbox[v.."randomupper"].text..")-("..d.textbox[v.."randomlower"].text..")))+("..d.textbox[v.."randomlower"].text..")";
	elseif s == "Bullet" then
			-- provide code for changing bullet
		end
		
		f = f..")"		--	entire main function is now closed off
		if s ~= "(no change)" then s = AddSpecialAttribute(f,v,temp,d); f = f..s; end
		f = f.." end";	-- Finalize the function
		
		gTempPatternText = gTempPatternText..string.sub(f,8)..', ';
		Trace("Function: "..f);
		f = load(f);
		table.insert(temp.tbl.queue[#temp.tbl.queue][2],f());
	end
	gTempPatternText = string.sub(gTempPatternText,1,-3) -- Get rid of the extra comma
	gTempPatternText = gTempPatternText..'}},';
	
end





function FinalizePattern(temp,difficulty)
	gTempPatternText = string.sub(gTempPatternText,1,-3) -- Get rid of the extra comma and whitespace
	gTempPatternText = gTempPatternText..'}},';
	table.insert(gTempBulletData[difficulty].bulletpatterns,gTempPattern);
	AppendBulletPattern(gEditValues.name,gEditValues.difficulty,gTempPatternText);
	gTempPattern = {};
	gTempPatternText = nil;
end

function MakeTempFile(path,difficulty)

	local temp = io.open('Beat Blaster - Editor/level/'..path..'/tempbullets.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/bullets.lua') do
		temp:write(line,"\n");
	end
	
	temp:close();
	
end

--[[
	TODO: define shot types for bullets (does this need to be done?)
	
	IMPORTANT: Figure out a way to set up a sprite pool for the images.
	Pre-load a set amount of images such that images aren't loaded.
		SOLUTION: Load sprite bullets that cycle through their frames via gGameTime.
		These will be separate from the "Game" global sprite table.
			POSSIBLE DOWNSIDE: All bullets on screen of the same type will be
			forced to the same frame.
	
	Current shot types: Bullet
	
	Also, set up bullet patterns like a command queue. The commands go in this order:
	[start time] > [attribute change] > [duration] > repeat from [attribute change]...
	
	To make things easier on the level designer, some bullet patterns can be organized in a table.
	Once a level is loaded, the table is broken down into its components, take them out of the table and
	into the main bullet table. After that is done with all of the components, the bullet pattern indicies
	are arranged in order of when they are called (time-wise). This would be used for things like ring/spiral
	patterns, which use primarily the same attributes and differ through the iterator
	
	Still need to figure out a way to implement rank (making bullet patterns harder as time progresses)
	as well as resetting the table once the song loops.
	
	bullet attributes (including defaults) are:
	
	[atribute]	|	[default]	|	[description]
	x			|	-999		|	X coordinate of the bullet
	y			|	-999		|	Y coordinate of the bullet
	xvel		|	1			|	X velocity, add this value to x every update
	yvel		|	1			|	Y velocity, add this value to y every update
	xaccel		|	0			|	X acceleration, add this value to xvel every update
	yaccel		|	0			|	Y acceleration, add this value to yvel every update
	angle		|	0			|	angle of the bullet, 0 = right, 90 = down, 180 = left, 270 = up
	speed		|	1			|	speed of the bullet, used for velocity initialization
	reflect		|	false		|	If the bullet reflects off the left/right screen walls
	active		|	false		|	When a bullet is called, automatically set to true. When it goes off-screen, set to false.
	
	IMPORTANT NOTE: Once the bullet is completely off-screen, return it to its sprite pool and
	dismiss the rest of the command queue. Update the bullet positions per game update.
	To take care of the command queue, remove each element from the table as it is called.


]]
