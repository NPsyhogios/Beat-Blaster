--[[ functions defined in this .lua file:
DrawBackground
DrawDialog
DrawMenu
DrawScreenElements
DrawTransition
DrawUI
]]


-- main functions, sub functions are defined below
function DrawBackground()

end

function DrawScreenElements()
	if gCurScreen == "Gameplay" and gLevelPrepared then
		DrawCharacter();	-- Draw the player ship below the bullets
		if not gPaused then
			DrawBullets(gBulletData[gLevelStats.difficulty].bulletpatterns);
		end
	end
	
end

-- This will be the draw layer used to show the available patterns as well as being able
-- to click them and do various things such as delete and modify them.
function DrawUI()
	local g = love.graphics;
	
	g.setColor(255,255,255,math.min(gAlphaPatternType,255));
	g.print("Edit mode:"..gEditMode,5,SCREENH-30,0,2);
	g.setColor(255,255,255,255);
	
	if gShowPatterns then
		if gDialog or not gPaused then return; end
	else return; end
	
	bUp = false; bDown = false;
	
	g.setColor(32,32,32,255);
	g.rectangle("fill",SCREENW-300,0,300,SCREENH);
	g.setColor(255,255,255,255);
	
	local offset = gPatternPos * 40;
	
	-- BULLET EDITING MODE --
	if gEditMode == "Bullet" then
		if gTempBulletData and #gTempBulletData[gEditValues.difficulty].bulletpatterns >= 1 then
			for i,v in ipairs(gEditValues.origindex) do
				local y = i*40-offset+40;
				Trace(tostring(v[1]));
				if y >= 50 and y <= SCREENH-100 then
					if gPatternSelected == i then g.setColor(0,0,64,255); else g.setColor(16,16,16,255); end
					g.rectangle("fill",SCREENW-295,y,290,35);
					g.setColor(255,255,255,255);
					g.print("Start: "..gTempBulletData[gEditValues.difficulty].bulletpatterns[v[1]].tbl.start..", No. of Bullets: "..gTempBulletData[gEditValues.difficulty].bulletpatterns[v[1]].iter,SCREENW-294,y+1);
					g.print("Bullet type:",SCREENW-294,y+18);
					g.draw(gMouse.bullets[gTempBulletData[gEditValues.difficulty].bulletpatterns[v[1]].tbl.btype].img,gMouse.bullets[gTempBulletData[gEditValues.difficulty].bulletpatterns[v[1]].tbl.btype].quads[gMouse.bullets[gTempBulletData[gEditValues.difficulty].bulletpatterns[v[1]].tbl.btype].curframe],SCREENW-210,y+18,0,1/gMouse.bullets[gTempBulletData[gEditValues.difficulty].bulletpatterns[v[1]].tbl.btype].tilewidth*16,1/gMouse.bullets[gTempBulletData[gEditValues.difficulty].bulletpatterns[v[1]].tbl.btype].tileheight*16);
					-- Possibly sort by start time for just this display so user can navigate easier?
						-- Will need an "original index" number if this route is chosen so proper pattern is edited.
				end
				
				if not bUp then if y < 50 then bUp = true; end end
				if not bDown then if y > SCREENH-100 then bDown = true; end end
			end
			if bUp then g.draw(_up,SCREENW-150-32,10); end
			if bDown then g.draw(_down,SCREENW-150-32,SCREENH-70); end
		end
		
		if gPatternSelected then
			local flag = false;
			if gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue and #gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue > 0 then
				flag = true;
			end
			for i,v in pairs(gBulletPatternButtons) do
				if i ~= "deletequeue" and i ~= "editqueue" then
					g.draw(v.img,v.x,v.y);
				else
					if flag then
						g.draw(v.img,v.x,v.y);
					end
				end
			end
		end
	end
	-- END BULLET EDITING MODE --
	
end

function DrawDialog(d)
	if not gDialog then return; end
	local g = love.graphics;
	
	
-------------------------
-- BULLET REQUIREMENTS --		
-------------------------

	if d.name == "BulletRequirements" then
		local expandedMenu = nil;
	
		g.draw(d.background,SCREENW/2,SCREENH/2,0,1,1,d.background:getWidth()/2,d.background:getHeight()/2);
		for i,v in pairs(d.choice) do
			if v.visible then
				g.draw(v.img,v.x,v.y,0,1,1,v.img:getWidth()/2,v.img:getHeight()/2);
			end
		end
		
		for i,v in pairs(d.textbox) do
			if v.visible then
				g.setColor(64,0,0,255);
				if v.hasFocus then g.setColor(0,64,0,255); end
				g.rectangle("fill",v.x,v.y,v.width,20);
				g.setColor(255,255,255,255);
				g.print(v.text,v.x,v.y,0,1.25,1.25);
			end
		end
			
		-- Information Text
		g.print(d.title,SCREENW/2-270,SCREENH/2-85,0,2,2);
		g.print("Loop condition is:",SCREENW/2-340,SCREENH/2-50,0,1.5,1.5);
		g.print("Boss life conditon is:",SCREENW/2-340,SCREENH/2-25,0,1.5,1.5);
		
		if d.dropmenu.loopreq.text == "Every" then
			g.print("loops starting at",SCREENW/2+137,SCREENH/2-48,0,1.35,1.35);
		end
		if d.dropmenu.healthreq.text == "Between" then
			g.print("and",SCREENW/2+155,SCREENH/2-23,0,1.3,1.3);
		end
		
		-- draw the dropdown menus last (on top)
		for i,v in pairs(d.dropmenu) do
			if v.visible then
				g.setColor(0,0,255,255);
				g.rectangle("fill",v.x,v.y,v.width,20);
				g.setColor(255,255,255,255);
				g.print(v.options[v.curOption],v.x,v.y,0,1.25,1.25);
				if v.expanded then expandedMenu = i; end
			end
		end
		
		if expandedMenu then
		-- draw the expanded dropmenu last so it it drawn above the other dropmenus
			local flag = false;
			for i,v in ipairs(d.dropmenu[expandedMenu].options) do
				if gMouse.x > d.dropmenu[expandedMenu].x and gMouse.x < d.dropmenu[expandedMenu].x + d.dropmenu[expandedMenu].width and
				gMouse.y > d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset and gMouse.y <= d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset+20 then
					flag = true;
					g.setColor(0,0,255,255);
				else g.setColor(0,0,0,255); end
				g.rectangle("fill",d.dropmenu[expandedMenu].x,d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset,d.dropmenu[expandedMenu].width,20);
				g.setColor(255,255,255,255);
				g.print(v,d.dropmenu[expandedMenu].x,d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset,0,1.25,1.25);
			end
			
			if flag and gHelpMenu then
				local s = "";
				local length = 1
				local offset = 0;
				if expandedMenu == "loopreq" then
					s = "Set the loop conditions (number of times the song has\nrepeated) under which the bullet pattern will occur.\nSelect 'no condition' to always fire the pattern.";
					length = 50;
			elseif expandedMenu == "healthreq" then
					s = "Set the boss health conditions (the boss's current\nhealth) under which the bullet pattern will occur.\nSelect 'no condition' to always fire the pattern.";
					length = 50;
				end
				if gMouse.x + font:getWidth(s) > SCREENW then offset = font:getWidth(s)*-1; end
				g.setColor(0,0,0,255);
				g.rectangle("fill",gMouse.x+offset,gMouse.y-length,font:getWidth(s),length);
				g.setColor(255,255,255,255);
				g.print(s,gMouse.x+offset,gMouse.y-length,0,1,1);
			end
		end
	

-----------------------
-- BULLET ATTRIBUTES --		
-----------------------
elseif d.name == "BulletAttributes" then
		local expandedMenu = nil;
		
		g.draw(d.background,SCREENW/2,SCREENH/2,0,1,1,d.background:getWidth()/2,d.background:getHeight()/2-15);
		for i,v in pairs(d.choice) do
			if v.visible then
				g.draw(v.img,v.x,v.y,0,1,1,v.img:getWidth()/2,v.img:getHeight()/2);
			end
		end
		
		for i,v in pairs(d.textbox) do
			if v.visible then
				g.setColor(64,0,0,255);
				if v.hasFocus then g.setColor(0,128,0,255); end
				g.rectangle("fill",v.x,v.y,v.width,20);
				g.setColor(255,255,255,255);
				g.print(v.text,v.x,v.y,0,1.25,1.25);
			end
		end
			
		-- Information Text --
		g.print(d.title,					SCREENW/2-150,SCREENH/2-285,0,2,2);
		g.print("Start:               Increment:                               Bullets:",SCREENW/2-235-30,SCREENH/2-245,0,1.25,1.25);
		g.print("X:",			SCREENW/2-235,SCREENH/2-195,0,1.25,1.25);
		g.print("Coord. Origin:",			SCREENW/2-235-30,SCREENH/2-195+25,0,1.25,1.25);
		g.print("Y:",			SCREENW/2-235,SCREENH/2-120,0,1.25,1.25);
		g.print("Coord. Origin:",			SCREENW/2-235-30,SCREENH/2-120+25,0,1.25,1.25);
		g.print("Angle:",		SCREENW/2-235-35,SCREENH/2-45,0,1.25,1.25);
		g.print("Origin of angle:",		SCREENW/2-235-35,SCREENH/2-20,0,1.25,1.25);
		g.print("Speed:",		SCREENW/2-235-45,SCREENH/2+30,0,1.25,1.25);
		g.print("X Accel:",	SCREENW/2-235-50,SCREENH/2+105,0,1.25,1.25);
		g.print("Base Velocity:",	SCREENW/2-235-50,SCREENH/2+105+25,0,1.25,1.25);
		g.print("Y Accel:",	SCREENW/2-235-50,SCREENH/2+180,0,1.25,1.25);
		g.print("Base Velocity:",	SCREENW/2-235-50,SCREENH/2+180+25,0,1.25,1.25);
		
		local t = {"x","y","angle","speed","xaccel","yaccel"}
		for i,v in ipairs(t) do
			if d.dropmenu[v].text == "Variance" then
				g.print("Var. Speed:",SCREENW/2+30,SCREENH/2-195+((i-1)*75),0,1.25,1.25);
				g.print("Wave Type:",SCREENW/2+30,SCREENH/2-170+((i-1)*75),0,1.25,1.25);
		elseif d.dropmenu[v].text == "Random" then
				g.print("to",SCREENW/2+30,SCREENH/2-195+((i-1)*75),0,1.25,1.25);
			end
		end
		
		-- Line separators --
		g.rectangle("fill",SCREENW/2-285,SCREENH/2-198,570,1);
		for i=1,6 do
			g.rectangle("fill",SCREENW/2-285,SCREENH/2-198+i*75,570,1);
		end
		
		-- draw the dropdown menus last (on top)
		for i,v in pairs(d.dropmenu) do
			if v.visible then
				g.setColor(0,0,255,255);
				g.rectangle("fill",v.x,v.y,v.width,20);
				g.setColor(255,255,255,255);
				g.print(v.options[v.curOption],v.x,v.y,0,1.25,1.25);
				if v.expanded then expandedMenu = i; end
			end
		end
		
		if expandedMenu then
		-- draw the expanded dropmenu last so it it drawn above the other dropmenus
			local flag = false;
			for i,v in ipairs(d.dropmenu[expandedMenu].options) do
				if gMouse.x > d.dropmenu[expandedMenu].x and gMouse.x < d.dropmenu[expandedMenu].x + d.dropmenu[expandedMenu].width and
				gMouse.y > d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset and gMouse.y <= d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset+20 then
					flag = true;
					g.setColor(0,0,255,255);
				else g.setColor(0,0,0,255); end
				g.rectangle("fill",d.dropmenu[expandedMenu].x,d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset,d.dropmenu[expandedMenu].width,20);
				g.setColor(255,255,255,255);
				g.print(v,d.dropmenu[expandedMenu].x,d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset,0,1.25,1.25);
			end
			if flag and gHelpMenu then
				local t = {"x","y","angle","speed","xaccel","yaccel"};
				local s = "";
				local length = 1
				local offset = 0;
				for i,v in ipairs(t) do
					if expandedMenu == v then
						s = "Increment: Increases base value by this amount per bullet.\nVariance: Amount allowed to deviate from base/2.\nRandom: Ignores base value and takes lower and upper bounds.";
						length = 50;
				elseif expandedMenu == v.."origin" then
						s = "The base X/Y coordinates are added to the origin.\nScreen: 0,0 (top-left).\nBoss: enemy coordinates.\nPlayer: Player ship coordinates";
						length = 67;
				elseif expandedMenu == v.."variancenotation" or expandedMenu == "start" then
						s = "Custom: Increases base value by this amount per bullet.\nNotations increase base value by this notation per\nbullet according to the current BPM.";
						length = 50;
				elseif expandedMenu == v.."variance" or expandedMenu == "start" then
						s = "Choose the style of your wave.";
						length = 16;
				elseif expandedMenu == "angletype" then
						s = "Right: Default, 0 starting facing directly right, going clockwise\nuntil it hits 360 to make a full circle.\nPlayer: Angle is bullet to player plus base value.";
						length = 50;
				elseif expandedMenu == v.."base" then
						s = "Normal: Base value is multiplied by 1.\nBullet:Base value is multiplied by the velocity\nof the bullet (determined by angle).";
						length = 50;
					end
				end
				if gMouse.x + font:getWidth(s) > SCREENW then offset = font:getWidth(s)*-1; end
				g.setColor(0,0,0,255);
				g.rectangle("fill",gMouse.x+offset,gMouse.y-length,font:getWidth(s),length);
				g.setColor(255,255,255,255);
				g.print(s,gMouse.x+offset,gMouse.y-length,0,1,1);
			end
		end
		
		
------------------
-- BULLET QUEUE --		
------------------

elseif d.name == "BulletQueue" then
		local expandedMenu = nil;
		
		g.draw(d.background,SCREENW/2,SCREENH/2,0,1,1,d.background:getWidth()/2,d.background:getHeight()/2-15);
		for i,v in pairs(d.choice) do
			if v.visible then
				g.draw(v.img,v.x,v.y,0,1,1,v.img:getWidth()/2,v.img:getHeight()/2);
			end
		end
		
		for i,v in pairs(d.textbox) do
			if v.visible then
				g.setColor(64,0,0,255);
				if v.hasFocus then g.setColor(0,128,0,255); end
				g.rectangle("fill",v.x,v.y,v.width,20);
				g.setColor(255,255,255,255);
				g.print(v.text,v.x,v.y,0,1.25,1.25);
			end
		end
			
		-- Information Text
		g.print(d.title,					SCREENW/2-160,SCREENH/2-285,0,2,2);
		g.print("Execute queue               seconds after previous instruction",SCREENW/2-235-50,SCREENH/2-245,0,1.25,1.25);
		g.print("Time difference per bullet:",SCREENW/2-235-50,SCREENH/2-220,0,1.25,1.25);
		g.print("X:",			SCREENW/2-235,SCREENH/2-195,0,1.25,1.25);
		g.print("Coord. Origin:",			SCREENW/2-235-30,SCREENH/2-195+25,0,1.25,1.25);
		g.print("Y:",			SCREENW/2-235,SCREENH/2-120,0,1.25,1.25);
		g.print("Coord. Origin:",			SCREENW/2-235-30,SCREENH/2-120+25,0,1.25,1.25);
		g.print("Angle:",		SCREENW/2-235-35,SCREENH/2-45,0,1.25,1.25);
		g.print("Origin of angle:",		SCREENW/2-235-35,SCREENH/2-20,0,1.25,1.25);
		g.print("Speed:",		SCREENW/2-235-45,SCREENH/2+30,0,1.25,1.25);
		g.print("X Accel:",	SCREENW/2-235-50,SCREENH/2+105,0,1.25,1.25);
		g.print("Base Velocity:",	SCREENW/2-235-50,SCREENH/2+105+25,0,1.25,1.25);
		g.print("Y Accel:",	SCREENW/2-235-50,SCREENH/2+180,0,1.25,1.25);
		g.print("Base Velocity:",	SCREENW/2-235-50,SCREENH/2+180+25,0,1.25,1.25);
		
		local t = {"x","y","angle","speed","xaccel","yaccel"}
		for i,v in ipairs(t) do
			if d.dropmenu[v].text == "Variance" then
				g.print("Var. Speed:",SCREENW/2+30,SCREENH/2-195+((i-1)*75),0,1.25,1.25);
				g.print("Wave Type:",SCREENW/2+30,SCREENH/2-170+((i-1)*75),0,1.25,1.25);
		elseif d.dropmenu[v].text == "Random" then
				g.print("to",SCREENW/2+30,SCREENH/2-195+((i-1)*75),0,1.25,1.25);
			end
		end
		
		g.rectangle("fill",SCREENW/2-285,SCREENH/2-198,570,1);
		for i=1,6 do
			g.rectangle("fill",SCREENW/2-285,SCREENH/2-198+i*75,570,1);
		end
		
		-- draw the dropdown menus last (on top)
		for i,v in pairs(d.dropmenu) do
			if v.visible then
				g.setColor(0,0,255,255);
				g.rectangle("fill",v.x,v.y,v.width,20);
				g.setColor(255,255,255,255);
				g.print(v.options[v.curOption],v.x,v.y,0,1.25,1.25);
				if v.expanded then expandedMenu = i; end
			end
		end
		
		
		if expandedMenu then
		-- draw the expanded dropmenu last so it it drawn above the other dropmenus
			local flag = false;
			for i,v in ipairs(d.dropmenu[expandedMenu].options) do
				if gMouse.x > d.dropmenu[expandedMenu].x and gMouse.x < d.dropmenu[expandedMenu].x + d.dropmenu[expandedMenu].width and
				gMouse.y > d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset and gMouse.y <= d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset+20 then
					flag = true;
					g.setColor(0,0,255,255);
				else g.setColor(0,0,0,255); end
				g.rectangle("fill",d.dropmenu[expandedMenu].x,d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset,d.dropmenu[expandedMenu].width,20);
				g.setColor(255,255,255,255);
				g.print(v,d.dropmenu[expandedMenu].x,d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset,0,1.25,1.25);
			end
			if flag and gHelpMenu then
				local t = {"x","y","angle","speed","xaccel","yaccel"};
				local s = "";
				local length = 1
				local offset = 0;
				for i,v in ipairs(t) do
					if expandedMenu == v then
						s = "Increment: Increases base value by this amount per bullet.\nVariance: Amount allowed to deviate from base/2.\nRandom: Ignores base value and takes lower and upper bounds.";
						length = 50;
				elseif expandedMenu == v.."origin" then
						s = "The base X/Y coordinates are added to the origin.\nScreen: 0,0 (top-left).\nBoss: enemy coordinates.\nPlayer: Player ship coordinates";
						length = 67;
				elseif expandedMenu == v.."variancenotation" or expandedMenu == "start" then
						s = "Custom: Increases base value by this amount per bullet.\nNotations increase base value by this notation per\nbullet according to the current BPM.";
						length = 50;
				elseif expandedMenu == v.."variance" or expandedMenu == "start" then
						s = "Choose the style of your wave.";
						length = 16;
				elseif expandedMenu == "angletype" then
						s = "Right: Default, 0 starting facing directly right, going clockwise\nuntil it hits 360 to make a full circle.\nPlayer: Angle is bullet to player plus base value.";
						length = 50;
				elseif expandedMenu == v.."base" then
						s = "Normal: Base value is multiplied by 1.\nBullet:Base value is multiplied by the velocity\nof the bullet (determined by angle).";
						length = 50;
					end
				end
				if expandedMenu == "queuediff" then
					s = "This will be the difference in which the queues\nhappen per bullet. Keep the original bullet start\ntimes in mind when determining this.";
					length = 50;
				end
				if expandedMenu == "sign" then
					s = "Add or subtract this much time per bullet to the base queue time.\nIf 'Custom' and the value is zero, this does not matter. Be careful\nnot to accidentally go below zero when subtracting.";
					length = 50;
				end
				
				if gMouse.x + font:getWidth(s) > SCREENW then offset = font:getWidth(s)*-1; end
				g.setColor(0,0,0,255);
				g.rectangle("fill",gMouse.x+offset,gMouse.y-length,font:getWidth(s),length);
				g.setColor(255,255,255,255);
				g.print(s,gMouse.x+offset,gMouse.y-length,0,1,1);
			end
		end
	end

end

function DrawMenu(m)
	-- TODO: draw cursor and add support for animated menu options
	if not m then return; end
	
	local g = love.graphics;
	
	if m.name == "Main" then
		g.draw(m.cursor,m.x[m.pos[2]][m.pos[1]],m.y[m.pos[2]][m.pos[1]]);
		g.print("Load Level",340,m.y[1][1]+16,0,2);
		g.print("Exit",340,m.y[2][1]+16,0,2);
		
elseif m.name == "Load" or m.name == "DeleteQueue" or m.name == "EditQueue" then
		local offset = m.pos[2] * 40;
		g.setColor(0,0,0,200);
		g.rectangle("fill",camera.x,camera.y,SCREENW,SCREENH);
		g.setColor(255,255,255,255);
		local addx = 0;
		if m.name == "DeleteQueue" or m.name == "EditQueue" then
			addx = 300;
			g.print('Which queue?',100,SCREENH/2-20,0,2)
		end
		local up, down;
		for i = 1, m.numrows do
			g.draw(m.cursor,50+addx,SCREENH/2-32);
			
			local y = SCREENH/2+i*40-offset-13;
			if y >= 50 and y <= SCREENH-150 then
				local s = gEditValues.folders[i];
				local cutoff = false;
				
				if m.name == "Load" then
					while font:getWidth(s) > 300 do
						s = string.sub(s,1,string.len(s)-1);
						cutoff = true;
					end
				end
				
				if cutoff then s = s..'...'; end
				if m.name == "Load" then
					g.print(s,120+addx,y,0,2)
				else
					g.print(i,120+addx,y,0,2);
				end
			else
				if y < 50 then up = true; end
				if y > SCREENH-150 then down = true; end
			end
		end
		if up then g.draw(_up,110+addx,10); end
		if down then g.draw(_down,110+addx,SCREENH-110); end
	
elseif m.name == "Difficulty" then
		g.draw(m.cursor,m.x[m.pos[2]][m.pos[1]],m.y[m.pos[2]][m.pos[1]]);
		g.print("Easy",340,SCREENH/2-50,0,2);
		g.print("Medium",340,SCREENH/2,0,2);
		g.print("Hard",340,SCREENH/2+50,0,2);
	
elseif m.name == "Edit" then
		g.setColor(0,0,0,128);
		g.rectangle("fill",camera.x,camera.y,SCREENW,SCREENH);
		g.setColor(255,255,255,255);
		g.draw(m.cursor,m.x[m.pos[2]][m.pos[1]],m.y[m.pos[2]][m.pos[1]]);
		g.print("Save",340,m.y[1][1]+16,0,2);
		g.print("Exit",340,m.y[2][1]+16,0,2);

elseif m.name == "DeleteBulletPattern" then
		g.setColor(0,0,0,128);
		g.rectangle("fill",camera.x,camera.y,SCREENW,SCREENH);
		g.setColor(255,255,255,255);
		g.draw(m.cursor,m.x[m.pos[2]][m.pos[1]],m.y[m.pos[2]][m.pos[1]]);
		g.print("Are you sure?",270,SCREENH/2-100,0,2);
		g.print("Yes",340,m.y[1][1]+16,0,2);
		g.print("No",340,m.y[2][1]+16,0,2);
		
elseif m.name == "Help" then
		g.setColor(0,0,0,128);
		g.rectangle("fill",camera.x,camera.y,SCREENW,SCREENH);
		g.setColor(255,255,255,255);
		g.print("F2/F3/F4: Change editing mode\nF12: Toggle pattern edit tab\nLeft/Right arrow keys: Change notation\nUp/Down arrow keys: Change bullet type\nMouse wheel up/down: Change song position\nLeft click: Add a bullet pattern",50,50,0,1.5,1.5);
	
	end

end

function DrawTransition()

end

function DrawMouse()
	if gLevelPrepared and gPaused and not gDialog then
		if not gShowPatterns or gMouse.x < SCREENW-300 then
			love.graphics.draw(gMouse.bullets[gEditValues.curBulletType].img,gMouse.bullets[gEditValues.curBulletType].quads[gMouse.bullets[gEditValues.curBulletType].curframe],gMouse.x,gMouse.y,0,1,1,gMouse.bullets[gEditValues.curBulletType].tilewidth/2,gMouse.bullets[gEditValues.curBulletType].tileheight/2)
		end
	end
end

function DrawDebugText()
	local g = love.graphics;
	
	if gLevelPrepared and not gMenu and not gDialog then
		local BPM = gLevelData.BPM;
		CalculateNotation(BPM);
		
		if gLevelData.BPMchanges then
			local cursec;
			if gPaused then cursec = gEditValues.curSecond; else cursec = gLevelData.song:tell(); end
			for i,v in ipairs(gLevelData.BPMchanges) do
				if cursec > v[1] then
					BPM = v[2];
					CalculateNotation(BPM);
				else break; end
			end
		end
		g.print('Song Name: '..gLevelData.name,camera.x+5,camera.y+5);
		g.print('Song Artist: '..gLevelData.artist,camera.x+5,camera.y+20);
		
		if gPaused then
			g.print('Current song time: '..string.format('%1.3f',gEditValues.curSecond),camera.x+5,camera.y+35);
		else
			g.print('Current song time: '..string.format('%1.3f',gLevelData.song:tell()),camera.x+5,camera.y+35);
		end
		
		g.print('Loops: '..gLevelStats.loops,camera.x+5,camera.y+50);
		g.print('FPS: '..love.timer.getFPS(),camera.x+5,camera.y+65);
		g.print('Active bullets: '..gActiveBullets,camera.x+5,camera.y+80);
		g.print('Current notation: '..gEditValues.notation[gEditValues.curNotation],camera.x+5,camera.y+95);
		g.print('BPM: '..Round(BPM * gLevelData.song:getPitch()),camera.x+5,camera.y+110);
		g.print('Song Speed: '..Round(gLevelData.song:getPitch()*100)..'%',camera.x+5,camera.y+125);
		g.print('Mouse X: '..gMouse.x,camera.x+5,camera.y+140);
		g.print('Mouse Y: '..gMouse.y,camera.x+5,camera.y+155);
		g.print('Current bullet type: '..gLevelData.bullettype[gEditValues.curBulletType].name,camera.x+5,camera.y+170);
		g.print('Current edit mode: '..gEditMode,camera.x+5,camera.y+185);
		
	end
	--g.print('Game Time: '..gGameTime,camera.x+5,camera.y+95);
	--g.print('Global Time: '..gTime,camera.x+5,camera.y+110);
	
end




-- sub functions
function DrawBullets(bullets)
	gActiveBullets = 0;
	local g = love.graphics;
	for i,v in ipairs(bullets) do
		if v.active then
			gActiveBullets = gActiveBullets + 1;
			g.draw(v.bullet.sprite.img,v.bullet.sprite.quads[v.bullet.sprite.curframe],v.x,v.y,v.angle,1,1,v.bullet.sprite.tilewidth/2,v.bullet.sprite.tileheight/2)
		end
	end
end

function DrawCharacter()
	local g = love.graphics;
	if gPlayer then g.draw(gPlayer.img,gPlayer.x,gPlayer.y,0,1,1,16,16); end
end
