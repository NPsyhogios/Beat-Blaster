function UpdateMouseCoordinates()
	local m = love.mouse;
	gMouse.x, gMouse.y = m.getPosition();
	
	if gLevelPrepared and not gDialog and (not gShowPatterns or gMouse.x < SCREENW-300) then
		if love.mouse.isVisible() then
		love.mouse.setVisible(false); end
	else
		if not love.mouse.isVisible() then
		love.mouse.setVisible(true); end
	end
end

function love.mousepressed(x,y,button)
--[[ MOUSE BUTTON GLOSSARY
l = Left Mouse Button.
m = Middle Mouse Button.
r = Right Mouse Button.
wd = Mouse Wheel Down.
wu = Mouse Wheel Up.
x1 = Mouse X1 (also known as button 4).
x2 = Mouse X2 (also known as button 5).]]

	if gDialog then
		if button == "l" then
			DropMenuClicked(gDialog);
		end
elseif gLevelPrepared then
		if not gMenu then
			if gPaused then
				if button == "wd" then
					gEditValues.curSecond = gEditValues.curSecond - _G['_'..gEditValues.notation[gEditValues.curNotation]]
					if gEditValues.curSecond < 0 then gEditValues.curSecond = 0; end
			elseif button == "wu" then
					gEditValues.curSecond = gEditValues.curSecond + _G['_'..gEditValues.notation[gEditValues.curNotation]]
					if gEditValues.curSecond > gLevelData.loopend then gEditValues.curSecond = gLevelData.loopend; end
				end
				
				if button == "l" then
					if not gShowPatterns or gMouse.x < SCREENW-300 then
						if gEditMode == "Bullet" then
							gDialog = NewDialog("BulletAttributes");
							--gDialog = NewDialog("BulletRequirements");
							--gDialog = NewDialog("BulletQueue");
					elseif gEditMode == "Note" then
					elseif gEditMode == "Field" then
						end
					else
						-- Perform coordinate check with the boxes here, to select a pattern.
						
						if gEditMode == "Bullet" then
							if bUp and gMouse.x >= SCREENW-182 and gMouse.x <= SCREENW-182+_up:getWidth() and gMouse.y >= 10 and gMouse.y <= 10+_up:getHeight() then
								gPatternPos = gPatternPos - 1;
							elseif bDown and gMouse.x >= SCREENW-182 and gMouse.x <= SCREENW-182+_down:getWidth() and gMouse.y >= SCREENH-70 and gMouse.y <= SCREENH-70+_down:getWidth() then
								gPatternPos = gPatternPos + 1;
							else
								local flag = false;
								for i,v in ipairs(gTempBulletData[gEditValues.difficulty].bulletpatterns) do
									if i >= gPatternPos + 1 and i <= gPatternPos + 11 then	-- check if the box is visible
										if gMouse.x > SCREENW-295 and gMouse.x < SCREENW-5 and gMouse.y > i*40-gPatternPos*40+40 and gMouse.y < i*40-gPatternPos*40+75 then
											gPatternSelected = i;
											flag = true;
										end
									end
								end
								if not flag and gPatternSelected then
									local s = nil;
									for i,v in pairs(gBulletPatternButtons) do
										if gMouse.x > v.x and gMouse.x < v.x + v.img:getWidth() and gMouse.y > v.y and gMouse.y < v.y + v.img:getHeight() then
											s = i; break;
										end
									end
									if s then
										if s == "copy" then
											CopyBulletPattern(gEditValues.name,gEditValues.difficulty,gEditValues.origindex[gPatternSelected][1]);
											table.insert(gTempBulletData[gEditValues.difficulty].bulletpatterns,gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]]);
											SortPatterns(gEditValues.difficulty);
										elseif s == "delete" then
											gMenu = NewMenu("DeleteBulletPattern");
										elseif s == "deletequeue" then
											if gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue and #gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue > 0 then
												gMenu = NewMenu("DeleteQueue");
											end
										elseif s == "editattributes" then
											gEditing = true;
											gDialog = NewDialog("BulletAttributes");
										elseif s == "editqueue" then
											if gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue and #gTempBulletData[gEditValues.difficulty].bulletpatterns[gEditValues.origindex[gPatternSelected][1]].tbl.queue > 0 then
												gEditing = true;
												gMenu = NewMenu("EditQueue");
											end
										elseif s == "editrequirements" then
											gEditing = true;
											gDialog = NewDialog("BulletRequirements");
										end
									end
								end
							end
					elseif gEditMode == "Note" then
					elseif gEditMode == "Field" then
						end
					end
				end
			else
				if button == "wd" then
					gLevelData.song:setPitch( gLevelData.song:getPitch() - 0.01 ) 
			elseif button == "wu" then
					gLevelData.song:setPitch( gLevelData.song:getPitch() + 0.01 ) 
				end
			end
		end
	end
		
	
end
