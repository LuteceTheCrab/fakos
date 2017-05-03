object[3].current_phase = 2
stage_conf[stage_number][3] = 2
if flor == nil or flor <= 0 then
	flor = 1
elseif flor < 9 then
	flor = flor + 1
else
	love.audio.stop(bgm)
	event_count = 0
	open_stage(path..division.."5-sala.txt")
	open_persona(path..division.."5-barganha-d.txt")
	bgm = love.audio.newSource("5-aceitacao.mp3", "stream")
end