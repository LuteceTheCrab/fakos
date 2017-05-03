if event_count == nil then
	event_count = 0
	negacao_end = false
	raiva_end = false
	barganha_end = false
	aceitacao_end = false
	event_image = {}
	event_image[1]  = love.graphics.newImage('img/1-pedacos.png')
	event_image[2]  = love.graphics.newImage('img/1-jornal.png')
	event_image[3]  = love.graphics.newImage('img/1-aceitacao.jpg')
	event_image[4]  = love.graphics.newImage('img/1-1.png')
	event_image[5]  = love.graphics.newImage('img/1-2.png')
	event_image[6]  = love.graphics.newImage('img/1-3.png')
	event_image[7]  = love.graphics.newImage('img/1-4.png')
	event_image[8]  = love.graphics.newImage('img/2-cena1_queimada.jpg')
	event_image[9]  = love.graphics.newImage('img/2-cena2_queimada.jpg')
	event_image[10] = love.graphics.newImage('img/2-cena3_queimada.jpg')
	event_image[11] = love.graphics.newImage('img/4-floresta1.jpg')
	event_image[12] = love.graphics.newImage('img/4-floresta2.jpg')
	event_image[13] = love.graphics.newImage('img/4-floresta3.jpg')
	event_image[14] = love.graphics.newImage('img/4-floresta4.jpg')
	event_image[15] = love.graphics.newImage('img/4-floresta5.jpg')
end
if negacao_end == true and stage_number == 1 then
	persona.current_station = 1
	persona.x = station[persona.current_station].x
	persona.y = station[persona.current_station].y
	if event_count == 0 then
		for i = 1,5 do 
			object[i][object[i].current_phase].static_img = obj_img[1]
		end
	end
	event_count = event_count + 1
	local aux = math.floor(event_count / 5)
	if aux < 12 then
		scenery = event_image[1]
	elseif aux < 42 then
		scenery = event_image[2]
	elseif aux < 54 then
		scenery = event_image[3]
	elseif aux < 57 then
		scenery = event_image[4]
	elseif aux < 60 then
		scenery = event_image[5]
	elseif aux < 62 then
		scenery = event_image[6]
	elseif aux < 63 then
		scenery = event_image[7]
	elseif aux < 64 then
		scenery = event_image[4]
	elseif aux < 65 then
		scenery = event_image[5]
	elseif aux < 66 then
		scenery = event_image[6]
	elseif aux < 67 then
		scenery = event_image[7]
	elseif aux < 68 then
		scenery = event_image[4]
	elseif aux < 69 then
		scenery = event_image[5]
	else
		negacao_end = false
		event_count = 0
		love.audio.stop(bgm)
		open_stage(path..division.."2-raiva1.txt")
		open_persona(path..division.."2-raiva-d.txt")
		bgm = love.audio.newSource("2-raiva.mp3", "stream")
	end
end
if stage_number == 6 then
	for i = 1,object_count do
		if object[i].current_phase == 2 then
			object[i].x = 800
			object[i].y = 600
		end
	end
end
if raiva_end then
	if stage_number == 4 then
		scenery = event_image[8]
	elseif stage_number == 5 then
		scenery = event_image[9]
	elseif stage_number == 6 then
		scenery = event_image[10]
	end
end
if barganha_end == true and stage_conf[8][5] == 1 then
	stage_conf[8][5] = 2
	if stage_number == 8 then
		object[5].current_phase = 2
	end
end
if barganha_end == true and stage_number == 8 then
	event_count = event_count + 1
	if math.floor(event_count / 60) < 3 then
		object[5][2].static_img.prop = 0.3
	elseif math.floor(event_count / 60) < 4 then
		object[5][2].static_img.prop = 0.6
		object[5][2].static_img.rad = object[5][2].static_img.rad + 0.5
	elseif math.floor(event_count / 60) < 5 then
		object[5][2].static_img.prop = 0.9
		object[5][2].static_img.rad = object[5][2].static_img.rad + 0.5
	elseif math.floor(event_count / 60) < 6 then
		object[5][2].static_img.prop = 1.2
		object[5][2].static_img.rad = object[5][2].static_img.rad + 0.5
	elseif math.floor(event_count / 60) < 7 then
		object[5][2].static_img.prop = 1.5
		object[5][2].static_img.rad = object[5][2].static_img.rad + 0.5
	elseif math.floor(event_count / 60) < 8 then
		object[5][2].static_img.prop = 3
		object[5][2].static_img.rad = object[5][2].static_img.rad + 0.5
	elseif math.floor(event_count / 60) < 9 then
		object[5][2].static_img.prop = 6
		object[5][2].static_img.rad = object[5][2].static_img.rad + 0.5
	else
		barganha_end = false
		event_count = 0
		love.audio.stop(bgm)
		open_stage(path..division.."4-floresta.txt")
		open_persona(path..division.."4-negacao-d.txt")
		bgm = love.audio.newSource("4-depressao.mp3", "stream")
	end
end
if stage_number == 10 then
	event_count = event_count + 1
	if math.floor(event_count / 25) % 25 < 5 then
		scenery = event_image[11]
	elseif math.floor(event_count / 25) % 25 < 10 then
		scenery = event_image[12]
	elseif math.floor(event_count / 25) % 25 < 15 then
		scenery = event_image[13]
	elseif math.floor(event_count / 25) % 25 < 20 then
		scenery = event_image[14]
	else
		scenery = event_image[15]
	end
end
if aceitacao_end == true then
	event_count = event_count + 1
	if event_count > 120 then
		love.event.quit()
	end
end