-- This file handles all of the music functions in the game. --
-- The functions below here will deal with the level music. --


function PlayLevelMusic()
	if gLevelData.song then
		love.audio.stop(gLevelData.song);
	end
	love.audio.play(gLevelData.song);
end

function PauseLevelMusic()
	if gPaused then love.audio.pause();
	else love.audio.resume(); end
end

function LoopLevelMusic()
	if gLevelData.song then
		if gLevelData.song:tell() >= gLevelData.loopend then
			gLevelData.song:seek(gLevelData.loopstart, "seconds");
			gLevelStats.loops = gLevelStats.loops + 1;
			for i,v in ipairs(gBulletData[gLevelStats.difficulty].bulletpatterns) do
				if v.inLoop then
					gBulletData[gLevelStats.difficulty].bulletpatterns[i].fired = false;
				end
			end
		end
	end
end

function StopLevelMusic()
	if gLevelData.song then
		love.audio.stop(gLevelData.song);
	end
end





-- The functions below here will deal with the game music. --

function LoopMusic()
	if gMusic[gMusic.curSong].loop then
		local song = gMusic[gMusic.curSong].song;
		if song:tell() >= gMusic[gMusic.curSong].loopend then
			song:seek(gMusic[gMusic.curSong].loopstart, "seconds");
		end
	end
end

function PlayMusic(s)
	if gMusic.curSong then
		love.audio.stop(gMusic[gMusic.curSong].song);
	end
	gMusic.curSong = s;
	love.audio.play(gMusic[gMusic.curSong].song);
end

function StopMusic()
	if gMusic.curSong then
		love.audio.stop(gMusic[gMusic.curSong].song);
	end
end

function InitializeSoundtrack()
	gMusic = {
		curSong = nil,
		
		stageselect = {
			song = love.audio.newSource("music/system/stageselect.mp3"),
			loop = true;
			loopstart = 0.050,
			loopend = 11.315
			},
		};
	
end
