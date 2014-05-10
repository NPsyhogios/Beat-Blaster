-- This file handles all of the visual transitions in the game.
function FadeOutToColor(r,g,b)
	gTrans.red = r;
	gTrans.green = g;
	gTrans.blue = b;
	gTrans.t = 30; gTrans.curtrans = "FadeOutToColor"
end

function FadeInFromColor(r,g,b)
	gTrans.red = r;
	gTrans.green = g;
	gTrans.blue = b;
	gTrans.t = 30; gTrans.curtrans = "FadeInFromColor"
end

function OpenDialog()
	gTrans.t = 30; gTrans.curtrans = "OpenDialog"
end

function CloseDialog()
	gTrans.t = 30; gTrans.curtrans = "CloseDialog"
end

function UpdateTransition()
	if gTrans.t == 0 then gInTransition = false; return; end
	gTrans.t = gTrans.t - 1;
	
	if gTrans.t == 0 then 
		if gTrans.curtrans == "FadeOutToColor" then
			gTrans.t = 30;
			gTrans.curtrans = "FadeInFromColor"
			if gTrans.queue then
				ExecuteFunctionQueue();
			end
	elseif gTrans.curtrans == "OpenDialog" then
			if gTrans.queue then
				ExecuteFunctionQueue();
			end
			gTrans.curtrans = nil;
	elseif gTrans.curtrans == "CloseDialog" then
		gTrans.curtrans = nil;
		end
	end
end

function ExecuteFunctionQueue()
	for i=1,#gTrans.queue do
		if gTrans.method[i] == 1 then
			_G[gTrans.queue[i]](gTrans.param[i]); -- execute function from transition queue
	elseif gTrans.method[i] == 2 then
			_G[gTrans.var[i]] = _G[gTrans.queue[i]](gTrans.param[i]);
	elseif gTrans.method[i] == 3 then
			_G[gTrans.var[i]] = _G[gTrans.queue[i]](_G[gTrans.param[i]]);
	elseif gTrans.method[i] == 4 then
			_G[gTrans.queue[i]](gTrans.var[i],gTrans.param[i]);
		end
	end
	
	gTrans.method = nil;
	gTrans.queue = nil;
	gTrans.var = nil;
	gTrans.param = nil;
end

function DrawTransition(s)
	local g = love.graphics;
	if gTrans.curtrans == "FadeOutToColor" then
		g.setColor(gTrans.red,gTrans.green,gTrans.blue,(30-gTrans.t)*(255/30))
		g.rectangle("fill",camera.x,camera.y,SCREENW,SCREENH);
elseif gTrans.curtrans == "FadeInFromColor" then
		g.setColor(gTrans.red,gTrans.green,gTrans.blue,gTrans.t*(255/30))
		g.rectangle("fill",camera.x,camera.y,SCREENW,SCREENH);
elseif gTrans.curtrans == "OpenDialog" then
		g.setColor(0,0,0,255);
		g.rectangle("fill",camera.x+SCREENW/2-(300-gTrans.t*10),camera.y+SCREENH/2-(225-gTrans.t*2.5),600-gTrans.t*20,150-gTrans.t*5);
elseif gTrans.curtrans == "CloseDialog" then
		g.setColor(0,0,0,255);
		g.rectangle("fill",camera.x+SCREENW/2-(gTrans.t*10),camera.y+SCREENH/2-gTrans.t*2.5-150,gTrans.t*20,gTrans.t*5);
	end
	
	g.setColor(255,255,255,255);
end

function InitializeTransitions()
	gTrans = {
				t = 0,
				red = 0,
				green = 0,
				blue = 0,
				curtrans = nil,
				queue = nil,
				var = nil
			};
end
