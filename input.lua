gKeyPressed = {};

-- This function triggers when pressing a key.
function love.keypressed( key, unicode ) 
	gKeyPressed[key] = true
	
	if not gDialog then
		if gMenu then
			if key == "left"	then MenuLeft(gMenu); end
			if key == "right"	then MenuRight(gMenu); end
			if key == "up"		then MenuUp(gMenu); end
			if key == "down"	then MenuDown(gMenu); end
			if key == "return"	then MenuSelect(gMenu); end
			if key == "escape"	then MenuEscape(gMenu); end
		else
		
			if gLevelPrepared then
				if gPaused then
					if key == "escape" then
						gMenu = NewMenu("Edit");
				elseif key == "f1" then
						gMenu = NewMenu("Help");
				elseif key == "f2" then gEditMode = "Bullet"; gAlphaPatternType = 600;
				elseif key == "f3" then gEditMode = "Note"; gAlphaPatternType = 600;
				elseif key == "f4" then gEditMode = "Field"; gAlphaPatternType = 600;
				elseif key == "f12" then
						gPatternSelected = nil;
						if gShowPatterns then gShowPatterns = false;
						else gShowPatterns = true; end
				elseif key == "left" then
						gEditValues.curNotation = gEditValues.curNotation - 1;
						if gEditValues.curNotation < 1 then gEditValues.curNotation = 1; end
				elseif key == "right" then
						gEditValues.curNotation = gEditValues.curNotation + 1;
						if gEditValues.curNotation > #gEditValues.notation then gEditValues.curNotation = #gEditValues.notation; end
				elseif key == "up" then
						gEditValues.curBulletType = gEditValues.curBulletType - 1;
						if gEditValues.curBulletType < 1 then gEditValues.curBulletType = 1; end
				elseif key == "down" then
						gEditValues.curBulletType = gEditValues.curBulletType + 1;
						if gEditValues.curBulletType > #gMouse.bullets then gEditValues.curBulletType = #gMouse.bullets; end
				elseif key == "p" then
						PlayLevel();
					end
				
				else
					if key == "escape" then StopLevel(); end
				end
			end
			
			
			
			if gTrans.t == 0 then -- let transitions finish, this takes priority over everything
			end
			
			--if key == "z" then end
		end
	else
		KeyTyped(gDialog,key)
	end
	
end


-- This function triggers when letting go of a key.
function love.keyreleased( key )
	gKeyPressed[key] = nil
	
	if gTrans.t == 0 then
	
	--if key == "z" then end
	
	end
end

-- This function triggers when holding a key.
function HeldKey(p)
	
	if gTrans.t == 0 then -- let transitions finish, this takes priority over everything
		
		if gCurScreen == "Gameplay" and gLevelPrepared then
			if not gPaused then
				-- player ship movement
				if gPlayer then
					if (gKeyPressed.left)	then	gPlayer.x = gPlayer.x - 6; end
					if (gKeyPressed.right)	then	gPlayer.x = gPlayer.x + 6; end
					if (gKeyPressed.up) 	then	gPlayer.y = gPlayer.y - 6; end
					if (gKeyPressed.down) 	then	gPlayer.y = gPlayer.y + 6; end
				end
			end
			
			if gPlayer then
				if gPlayer.x - 20 < 0 then gPlayer.x = 20; end
				if gPlayer.x + 20 > SCREENW then gPlayer.x = SCREENW - 20; end
				if gPlayer.y - 20 < 0 then gPlayer.y = 20; end
				if gPlayer.y + 20 > SCREENH then gPlayer.y = SCREENH - 20; end
			end
		end
	
	end
	
end
