--[[ functions defined in this .lua file:
InitializeSprites
LoadSprite
Sprite
SpriteGameRoutine
SpriteGlobalRoutine
SpriteOnceRoutine
UpdateSpriteFrames

]]

function LoadSprite(str)
	
	local g = love.graphics;
	local file = io.open('Beat Blaster - Editor/'..str..'.sprite')
	local data = {
					img,				-- the reference image
					source,				-- metadata of the image
					stype,				-- The type of sprite (Global, Game, Once)
					rows = 1,			-- number of rows in the spritesheet
					columns = 1,		-- number of columns in the spritesheet
					x = 0,				-- x position of the sprite
					y = 0,				-- y position of the sprite
					hitwidth = 0,		-- width of the image's hitbox
					hitheight = 0,		-- height of the image's hitbox
					imgwidth,			-- width of the sprite
					imgheight,			-- height of the sprite
					tilewidth,			-- width of a frame
					tileheight,			-- height of a frame
					frames = {},		-- table of frames to use from the sheet's grid
					delays = {},		-- table of delays to time the animation
					cycle = 0,			-- how long one cycle takes, in seconds
					curframe = 1,		-- the current frame to draw
					animating = false,	-- only applicable if stype = Once. Set animate to true when
										-- calling the sprite, and once the frames have ended, set
										-- animate to false. Only draw "Once" sprites if they are currently being animated.
					quads = {}			-- the table of quads
				};
	
	if file then
		for line in file:lines() do
			local s,t;
			if string.find(line,"#FILE=") then
				t = string.sub(line,1,6);
				s = string.sub(line,7);
				data.img = love.graphics.newImage(s);
				data.source = love.graphics.newImage(s);
		elseif string.find(line,"#TYPE=") then
				t = string.sub(line,1,6);
				s = string.sub(line,7);
				data.stype = s; -- determine the type of the sprite between Global, Game, Once.
		elseif string.find(line,"#COLUMNS=") then
				t = string.sub(line,1,9);
				s = string.sub(line,10);
				data.columns = tonumber(s);
		elseif string.find(line,"#ROWS=") then
				t = string.sub(line,1,6);
				s = string.sub(line,7);
				data.rows = tonumber(s);
		elseif string.find(line,"#FRAMES=") then
				local i1,i2 = 1,1;
				t = string.sub(line,1,8);
				s = string.sub(line,9);
				while i1 <= string.len(s) do
					i2 = string.find(s,",",i1); -- delimiter for frame numbers
					if not i2 then -- end of line reached
						i2 = string.len(s);
						table.insert(data.frames,tonumber(string.sub(s,i1,i2))); -- insert last number
						break; -- escape the loop
					else
						table.insert(data.frames,tonumber(string.sub(s,i1,i2-1))); -- insert number
					end
					i1 = i2 + 1; -- advance to next section of string
				end
		elseif string.find(line,"#DELAYS=") then
				local i1,i2 = 1,1;
				t = string.sub(line,1,8);
				s = string.sub(line,9);
				while i1 <= string.len(s) do
					i2 = string.find(s,",",i1); -- delimiter for delay numbers
					if not i2 then -- end of line reached
						i2 = string.len(s);
						table.insert(data.delays,tonumber(string.sub(s,i1,i2))); -- insert last number
						break; -- escape the loop
					else
						table.insert(data.delays,tonumber(string.sub(s,i1,i2-1))); -- insert number
					end
					i1 = i2 + 1; -- advance to next section of string
				end
			end
		end
		Trace("Loaded "..'Beat Blaster/'..str..'.sprite');
		io.close(file);
	else
		Trace("WARNING: Could not load file "..'Beat Blaster/'..str..'.sprite');
	end
	
	
	
	data.imgwidth = data.source:getWidth();
	data.imgheight = data.source:getHeight();
	data.tilewidth = math.ceil(data.imgwidth/data.columns);
	data.tileheight = math.ceil(data.imgheight/data.rows);
	-- Store quads in the table to be referenced later
	for y = 0, data.imgheight-data.tileheight, data.tileheight do
		for x = 0, data.imgwidth-data.tilewidth, data.tilewidth do
			table.insert(data.quads, g.newQuad(x, y, data.tilewidth, data.tileheight, data.imgwidth, data.imgheight))
		end
	end
	
	for i,v in ipairs(data.delays) do
		data.cycle = data.cycle + v;	-- get the total amount of time for one sprite animation cycle
	end
	
	--EXAMPLE: {1,2,3,4} would become {0,2,5,9}
	for i=#data.delays,1,-1 do
		local sum = 0;
		for j = i,1,-1 do
			sum = sum + data.delays[j];
		end
		data.delays[i] = sum - data.delays[1];
	end
	
	if data.stype == "Global" or data.stype == "Game" or data.stype == "Once" then
		table.insert(gSprite[data.stype],data) -- Insert a reference of the sprite into the proper table
	else
		table.insert(gSprite.Global,data) -- Default to inserting the reference into the Global time table, provide a warning
		Trace("WARNING: Improper sprite type in "..'Beat Blaster/'..str..'.sprite');
	end
	
	return data;
	--end
	
end


-- This function updates the frame displays for the "Global" sprites.
function SpriteGlobalRoutine(s)
	for i,w in ipairs(s.delays) do
		local frame = i+1;
		if frame > #s.delays then frame = 1; end
		if w <= math.mod(gTime,s.cycle) then s.curframe = s.frames[frame]; end
	end
end

-- This function updates the frame displays for the "Game" sprites.
function SpriteGameRoutine(s) 
	for i,w in ipairs(s.delays) do
		local frame = i+1;
		if frame > #s.delays then frame = 1; end
		if w <= math.mod(gGameTime,s.cycle) then s.curframe = s.frames[frame]; end
	end
end

-- This function updates the frame displays for the "Once" sprites.
function SpriteOnceRoutine(s)
	if not s.animating then return; end

	for i,w in ipairs(s.delays) do
		local frame = i+1;
		if frame > #s.delays then frame = 1; s.animating = false; end
		if w <= math.mod(gGameTime,s.cycle) then s.curframe = s.frames[frame]; end
	end
end



function UpdateSpriteFrames()
	--Trace("Global length = "..#gSprite.Global);
	--Trace("Game length = "..#gSprite.Game);
	--Trace("Once length = "..#gSprite.Once);
	
	for i,v in pairs(gSprite.Global) do
		SpriteGlobalRoutine(gSprite.Global[i]);
		--CheckIfTable(v,"SpriteGlobalRoutine");
	end
	for i,v in pairs(gSprite.Game) do
		SpriteGameRoutine(gSprite.Game[i]);
		--CheckIfTable(v,"SpriteGameRoutine");
	end
	for i,v in pairs(gSprite.Once) do
		SpriteOnceRoutine(gSprite.Game[i]);
		--CheckIfTable(v,"SpriteOnceRoutine");
	end
	
	--[[
	if gLevelData and gLevelPrepared then
		for i,v in ipairs(gLevelData.bullettype) do
			for j,w in pairs(v.sprite.delays) do
				local frame = j+1;
				if frame > #v.sprite.delays then frame = 1; end
				if w <= math.mod(gGameTime,v.sprite.cycle) then v.sprite.curframe = v.sprite.frames[frame]; end
			end
		end
	end
	]]
end



function InitializeSprites()
	
	-- sprite heirarchy = [Global sprite table] > [Sprite type table] > [Screen] > [object]
	-- 
	
	--local screens = {"Company","Intro","StageSelect","Options","Gameplay","Results","GameOver","Credits"};
	-- possible additional screens = "Load","Save"
	
	gSprite = {
		Global = {},
		Game = {},
		Once = {}
	};
	
	--[[
	for i,v in pairs(gSprite) do
		for j,w in pairs(screens) do
			v[w] = {};
		end
	end
	]]
	
	
end

-- This function removes the sprite from the global table based on its memory address, to prevent a memory leak.
function RemoveSprite(s)
	if type(s) ~= "table" then return; end
	local key = string.sub(tostring(s),8);
	
	if s.stype == "Global" or s.stype == "Game" or s.stype == "Once" then
		for i,v in ipairs(gSprite[s.stype]) do
			if key == string.sub(tostring(v),8) then
				table.remove(gSprite[s.stype],i)
				break;
			end
		end
	else
		for i,v in ipairs(gSprite.Global) do
			if key == string.sub(tostring(v),8) then
				table.remove(gSprite[s.stype],i);
				break;
			end
		end
	end
end

function Sprite(s)
	-- shorthand for referencing a sprite
end
