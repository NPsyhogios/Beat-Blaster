--[[ functions defined in this .lua file:
DiscardMenu
MenuDown
MenuEscape
MenuLeft
MenuRight
MenuSelect
MenuUp
NewMenu
]]

function NewMenu(s)

	-- Menus are created from left to right, then top to bottom.

	local t;
	local dir = 'menu/'..s..'/';
	local g = love.graphics;
	
	
	if s == "Main"  or s == "Edit" or s == "DeleteBulletPattern" then
		t = {
			name = s,
			numrows = 2,
			numcolumns = 1,
			cursor = g.newImage('img/cursor.png'),
			x = {{270},{270}},
			y = {{SCREENH/2-50},{SCREENH/2-0}},
			width = {{0},{0}},
			height = {{0},{0}},
			action = {{0},{0}},
			selectable = {{true},{true}},
			horizwrap = false,
			vertwrap = false,
			
			pos = {1,1}
		};
	
elseif s == "Load" then -- from Main
		t = {
			name = s,
			numrows = #gEditValues.folders,
			numcolumns = 1,
			cursor = g.newImage('img/cursor.png'),
			x = {{270},{270}},
			y = {{SCREENH/2-50},{SCREENH/2-0}},
			width = {{0},{0}},
			height = {{0},{0}},
			action = {{0},{0}},
			selectable = {{true},{true}},
			horizwrap = false,
			vertwrap = false,
			
			pos = {1,2}
		};
		
elseif s == "Difficulty" then
		t = {
			name = s,
			numrows = 3,
			numcolumns = 1,
			cursor = g.newImage('img/cursor.png'),
			x = {{270},{270},{270}},
			y = {{SCREENH/2-66},{SCREENH/2-16},{SCREENH/2+34}},
			width = {{0},{0}},
			height = {{0},{0}},
			action = {{0},{0}},
			selectable = {{true},{true}},
			horizwrap = false,
			vertwrap = false,
			escape = true,
			
			pos = {1,1}
		};
		
elseif s == "Help" then
		
		t = {
			name = s,
			numrows = 1,
			numcolumns = 1,
			x = {{-999}},
			y = {{-999}},
			width = {{0}},
			height = {{0}},
			action = {{0}},
			selectable = {{true}},
			horizwrap = false,
			vertwrap = false,
			escape = true,
			
			pos = {1,1}
		};
		
elseif s == "DeleteQueue" then
		t = {
			name = s,
			numrows = #gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue,
			numcolumns = 1,
			cursor = g.newImage('img/cursor.png'),
			x = {{270},{270}},
			y = {{SCREENH/2-50},{SCREENH/2-0}},
			width = {{0},{0}},
			height = {{0},{0}},
			action = {{0},{0}},
			selectable = {{true},{true}},
			horizwrap = false,
			vertwrap = false,
			
			pos = {1,1}
		};

elseif s == "EditQueue" then
		t = {
			name = s,
			numrows = #gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue,
			numcolumns = 1,
			cursor = g.newImage('img/cursor.png'),
			x = {{270},{270}},
			y = {{SCREENH/2-50},{SCREENH/2-0}},
			width = {{0},{0}},
			height = {{0},{0}},
			action = {{0},{0}},
			selectable = {{true},{true}},
			horizwrap = false,
			vertwrap = false,
			
			pos = {1,1}
		};
	
	else
		t = nil;
		Trace("Invalid menu name");
	end
	
	return t
end

function DiscardMenu()
	gMenu = nil;
end


function MenuLeft(m)
	if m.pos[1] == 1 then return; end
	m.pos[1] = m.pos[1] - 1;
end

function MenuDown(m)
	if m.pos[2] == m.numrows then return; end
	m.pos[2] = m.pos[2] + 1;
end

function MenuUp(m)
	if m.pos[2] == 1 then return; end
	m.pos[2] = m.pos[2] - 1;
end

function MenuRight(m)
	if m.pos[1] == m.numcolumns then return; end
	m.pos[1] = m.pos[1] + 1;
end

function MenuSelect(m)
	
	if m.name == "Main" then
		if m.pos[2] == 1 then
			DiscardMenu();
			gMenu = NewMenu("Load");
	elseif m.pos[2] == 2 then
			DiscardMenu();
			gLog:close();
			os.exit(0);
		end

elseif m.name == "Load" then
		gEditValues.name = gEditValues.folders[m.pos[2]];
		DiscardMenu();
		gMenu = NewMenu("Difficulty");
	
elseif m.name == "Difficulty" then
		local diff = {"easy","medium","hard"};
		gEditValues.difficulty = diff[m.pos[2]];
		PrepareLevel(gEditValues.name,gEditValues.difficulty);
		MakeTempFile(gEditValues.name,"tempbullets.lua");
		SortPatterns(gEditValues.difficulty);
		DiscardMenu();
	
elseif m.name == "Edit" then
		if m.pos[2] == 1 then
			SaveBulletFile(gEditValues.name);
			DiscardMenu();
	elseif m.pos[2] == 2 then	-- TODO: Check if all changes are saved. If not, go to "SavePrompt" menu.
			DiscardMenu();
			DeleteTempBulletFile(gEditValues.name);
			gLevelData = nil;
			gBulletData = nil;
			gLevelStats = nil;
			gPlayer = nil;
			for i,v in ipairs(gMouse.bullets) do
				RemoveSprite(gMouse.bullets[i])
			end
			gMouse.bullets = nil;
			gLevelPrepared = false;
			DiscardMenu();
			InitializeEditValues();
			gPatternSelected = nil;
			gPatternPos = 0;
			gTempBulletData = nil;
			gShowPatterns = false;
			gMenu = NewMenu("Main");
		end
		
elseif m.name == "DeleteBulletPattern" then
		if m.pos[2] == 1 then
			DeleteBulletPattern(gEditValues.name,gEditValues.difficulty,gEditValues.origindex[gPatternSelected][1]);
			table.remove(gTempBulletData[gEditValues.difficulty].bulletpatterns,gEditValues.origindex[gPatternSelected][1]);
			gPatternSelected = nil;
			SortPatterns(gEditValues.difficulty);
			DiscardMenu();
	elseif m.pos[2] == 2 then
			DiscardMenu();
		end
	
elseif m.name == "DeleteQueue" then
		DiscardMenu();
		
elseif m.name == "EditQueue" then
		gDialog = NewDialog("BulletQueue");
		FillDialogValues(gDialog,m.pos[2]);
		DiscardMenu();
	
elseif m.name == "Help" then
		DiscardMenu();
	end
	
	
	
	
	
end

function MenuEscape(m)
	if m.name == "Load" then
		DiscardMenu();
		gMenu = NewMenu("Main");
elseif m.name == "Difficulty" then
		DiscardMenu();
		gMenu = NewMenu("Load");
elseif m.name == "Edit" then
		DiscardMenu();
elseif m.name == "Help" then
		DiscardMenu();
elseif m.name == "DeleteBulletPattern" then
		DiscardMenu();
elseif m.name == "DeleteQueue" then
		DiscardMenu();
elseif m.name == "EditQueue" then
		DiscardMenu();
	end
	
	
end
