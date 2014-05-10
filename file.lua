-- This file provides functions to let the user save their patterns after making them in the editor.

function SaveBulletFile(path)
	local orig = io.open('Beat Blaster - Editor/level/'..path..'/bullets.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/tempbullets.lua') do
		orig:write(line,"\n");
	end
	
	orig:close();
	Trace("Save successful");
end

function DeleteTempBulletFile(path)
	os.remove('Beat Blaster - Editor/level/'..path..'/tempbullets.lua')
end

-- This function compares the temporary file to the current one.
-- If they do not match exactly, the user is prompted to save their work.
-- This menu only occurs when the user exits the main editor screen.
function PromptForSave()
--[[
	if temp ~= curfile then
		NewMenu("SavePrompt")
	else
		DiscardMenu();
	end
]]
end

function AppendBulletPattern(path,difficulty,pattern)
	local diff_flag = false;
	local diff_end = false;
	local appended = false;
	
	local temp = io.open('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/tempbullets.lua') do
		temp:write(line,"\n");
	end
	temp:close();
	
	local rewrite = io.open('Beat Blaster - Editor/level/'..path..'/tempbullets.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua') do
		if not appended then
			if string.find(line,difficulty.." = {") then diff_flag = true; end
			if string.find(line,"-- end of patterns") then diff_end = true; end
			if diff_flag and diff_end then
				rewrite:write(pattern,"\n"); -- write the new pattern into the file before the end of the table
				Trace("Pattern successfully added");
				appended = true;
			end
		end
		rewrite:write(line,"\n");
	end
	rewrite:close();
	os.remove('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua')
end

function DeleteBulletPattern(path,difficulty,index)
	local start = -2;
	local mode;
	if gEditMode == "Bullet" then mode = "bulletpatterns";
elseif gEditMode == "Note" then mode = "notepatterns";
else mode = "shotfield";
	end
	
	local temp = io.open('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/tempbullets.lua') do
		if start == -2 then if string.find(line,difficulty..' = {') then start = -1; end
	elseif start == -1 then if string.find(line,mode..' = {') then start = 0; end
	elseif start >= 0 then start = start + 1; end
		if start ~= index then temp:write(line,"\n"); else end
	end
	temp:close();
	Trace("Start = "..start);
	Trace("Index = "..index);
	
	local rewrite = io.open('Beat Blaster - Editor/level/'..path..'/tempbullets.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua') do
		rewrite:write(line,"\n");
	end
	rewrite:close();
	os.remove('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua')
end



function CopyBulletPattern(path,difficulty,index)
	local start = -2;
	local mode;
	if gEditMode == "Bullet" then mode = "bulletpatterns";
elseif gEditMode == "Note" then mode = "notepatterns";
else mode = "shotfield";
	end
	
	local temp = io.open('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/tempbullets.lua') do
		if start == -2 then if string.find(line,difficulty..' = {') then start = -1; end
	elseif start == -1 then if string.find(line,mode..' = {') then start = 0; end
	elseif start >= 0 then start = start + 1; end
		
		if start ~= index then temp:write(line,"\n"); else temp:write(line,"\n"); temp:write(line,"\n"); end
	end
	temp:close();
	Trace("Start = "..start);
	Trace("Index = "..index);
	
	local rewrite = io.open('Beat Blaster - Editor/level/'..path..'/tempbullets.lua',"w+");
	for line in io.lines('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua') do
		rewrite:write(line,"\n");
	end
	rewrite:close();
	os.remove('Beat Blaster - Editor/level/'..path..'/tempbullets2.lua')
end
