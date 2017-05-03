-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- CLICK OF THE PATRIOTS --------------------------------------------
---------------------------------- Sistema de jogo Point and Click com engine LOVE ------------------------------
-----------------------------------------------------------------------------------------------------------------
-- Por Caio Rulli                                                                                              --
-- Feito para o Projeto Geral de Design de Caroline Mie Chen                                                   --
--                                                                                                             --
-- Versão 1.0                                                                                                  --
-- Suporta:                                                                                                    --
-- > Personagem                                                                                                --
-- >> Carregado de Arquivo                                                                                     --
-- >> Animações próprias para andar e interagir                                                                --
-- > Estações                                                                                                  --
-- >> Carregado de Arquivo                                                                                     --
-- >> Múltiplos Cenários                                                                                       --
-- > Objetos                                                                                                   --
-- >> Carregado de Arquivo                                                                                     --
-- >> Imagem estática                                                                                          --
-- >> Associados a estados:                                                                                    --
-- >>> Ação única para cada estado                                                                             --
-- >>> Animação única para cada estado                                                                         --
-----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
-------------------------------------------- Função LOAD --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function love.load()
	os_string = love.system.getOS()
	path = love.filesystem.getSourceBaseDirectory();
	if os_string == "OS X" or os_string == "Linux" then
		division = "/"
		cycle_frame = 12
		speed = 3
	elseif os_string == "Windows" then
		division = "\\";
		path, beterraba = string.gsub(path, "/", "\\");
		cycle_frame = 6
		speed = 20
	end

	local file = io.open(path..division..'init.txt', 'r')
	stage_init = file:read()
	persona_init = file:read()
	music_init = file:read()
	io.close(file)

	bgm = love.audio.newSource(music_init, "stream")
	love.audio.play(bgm)

	open_stage(path..division..stage_init)
	open_persona(path..division..persona_init)
	-- alcance do mouse em relação à estação / objeto
	mouse_range = 75
	station_cursor = love.mouse.getSystemCursor("hand")
	object_cursor = love.mouse.getSystemCursor("crosshair")
	door_cursor = love.mouse.getSystemCursor("sizens")
	-- contagem de frames em um ciclo de object
	object_cycle_count = 0
end

-----------------------------------------------------------------------------------------------------------------
-------------------------------------------- Subrotinas LOAD ----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
function open_persona(filename)
	local file = io.open(filename, 'r')
	persona_img = {}
	for i = 1,15 do
		local line = file:read()
		local img, rad, prop, offset_x, offset_y = line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
		persona_img[i] = {}
		persona_img[i].img = love.graphics.newImage('persona/'.. img)
		persona_img[i].rad = tonumber(rad)
		persona_img[i].prop = tonumber(prop)
		persona_img[i].offset_x = tonumber(offset_x)
		persona_img[i].offset_y = tonumber(offset_y)
	end
	io.close(file)

	--====----------------------====--
	------ Estrutura do Persona ------
	--====----------------------====--

	persona = {}
	persona.current_station = 1
	persona.current_object = nil
	persona.x = station[persona.current_station].x
	persona.y = station[persona.current_station].y
	persona.fx = nil
	persona.fy = nil
	persona.static_img = persona_img[1]
	persona.walking = nil
	persona.walk_count = 0
	persona.walkl = {}
	persona.walkl[1] = persona_img[2]
	persona.walkl[2] = persona_img[3]
	persona.walkl[3] = persona_img[4]
	persona.walkl[4] = persona_img[5]
	persona.walkr = {}
	persona.walkr[1] = persona_img[6]
	persona.walkr[2] = persona_img[7]
	persona.walkr[3] = persona_img[8]
	persona.walkr[4] = persona_img[9]
	persona.interacting = nil
	persona.int_count = 0
	persona.intl = {}
	persona.intl[1] = persona_img[10]
	persona.intl[2] = persona_img[11]
	persona.intl[3] = persona_img[10]
	persona.intl[4] = persona_img[12]
	persona.intr = {}
	persona.intr[1] = persona_img[13]
	persona.intr[2] = persona_img[14]
	persona.intr[3] = persona_img[13]
	persona.intr[4] = persona_img[15]
end

function open_stage(filename)
	if stage_conf == nil then
		stage_conf = {}
	end

	local stage = io.open(filename, 'r')
	stage_number = tonumber(stage:read())
	scenery = love.graphics.newImage('img/'..stage:read())
	

	--====-----------------====--
	------ Estrutura do ME ------
	--====-----------------====--
	station = {}
	local line = stage:read()
	station_count = tonumber(line:match('%d+'))
	for i = 1, station_count do
		line = stage:read()
		station[i] = {}
		station[i].x, station[i].y, station[i].bl = line:match('(%d+)%s+(%d+)%s+(%d+)')
		station[i].x = tonumber(station[i].x) * 800/scenery:getWidth()
		station[i].y = tonumber(station[i].y) * 600/scenery:getHeight()
		station[i].bl = tonumber(station[i].bl)
	end

	--====------------------====--
	------ Estrutura do MOI ------
	--====------------------====--
	obj_img = {}
	line = stage:read()
	obj_img_count = tonumber(line:match('%d+'))
	for i = 1, obj_img_count do
		local line = stage:read()
		local img, rad, prop, offset_x, offset_y = line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
		obj_img[i] = {}
		obj_img[i].img = love.graphics.newImage('img/'.. img)
		obj_img[i].rad = tonumber(rad)
		obj_img[i].prop = tonumber(prop)
		obj_img[i].offset_x = tonumber(offset_x)
		obj_img[i].offset_y = tonumber(offset_y)
		-- obj_img[i] = love.graphics.newImage('img/'..stage:read())
	end
	object = {}
	line = stage:read()
	object_count = tonumber(line:match('%d+'))
	if stage_conf[stage_number] == nil then
		stage_conf[stage_number] = {}
		for i = 1, object_count do
			stage_conf[stage_number][i] = 1
		end
	end
	for i = 1, object_count do
		local linei = stage:read()
		local img_number = nil
		local phase_count = nil
		object[i] = {}
		object[i].current_phase = stage_conf[stage_number][i]
		object[i].x, object[i].y, object[i].bl, 
			phase_count, object[i].isDoor = linei:match('(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)')
		object[i].x = tonumber(object[i].x) * 800/scenery:getWidth()
		object[i].y = tonumber(object[i].y) * 600/scenery:getHeight()
		object[i].bl = tonumber(object[i].bl)
		object[i].phase_count = tonumber(phase_count)
		object[i].isDoor = tonumber(object[i].isDoor)
		for j = 1, object[i].phase_count do
			local linej = stage:read()
			local filename = nil
			object[i][j] = {}
			img_number, filename, object[i][j].length, 
				object[i][j].duration = linej:match('(%d+)%s+(%S+)%s+(%d+)%s+(%d+)')
			object[i][j].static_img = obj_img[tonumber(img_number)]
			object[i][j].length = tonumber(object[i][j].length)
			object[i][j].duration = tonumber(object[i][j].duration)
			object[i][j].action = function() dofile(path..division..filename) end
			for k = 1, object[i][j].length do
				object[i][j][k] = obj_img[tonumber(stage:read())]
			end
		end
	end
	io.close(stage)
end

-----------------------------------------------------------------------------------------------------------------
-------------------------------------------- Função UPDATE ------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function love.update(dt)
	-- funções básicas
	if love.keyboard.isDown('escape') then
		love.event.quit()
	end

	love.mouse.setCursor()
	local gx, gy = love.mouse.getX(), love.mouse.getY()
	local station = station_id(gx,gy)
	local objecte = object_id(gx,gy)
	if station ~= nil and valid_station(station) then
		love.mouse.setCursor(station_cursor)
	elseif objecte ~= nil and valid_object(objecte) then
		if object[objecte].isDoor == 1 then
			love.mouse.setCursor(door_cursor)
		else
			love.mouse.setCursor(object_cursor)
		end
	end

	-- movimentação
	if love.mouse.isDown('l') then
		set_destination(station)
	end
	walk()

	-- interação
	if love.mouse.isDown('r') then
		set_interaction(objecte)
	end

	if bgm:isPlaying() == false then
		love.audio.play(bgm)
	end

	dofile(path..division.."additional_update.lua")
end

-----------------------------------------------------------------------------------------------------------------
-------------------------------------------- Função DRAW --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function love.draw()
	-- teste: cenário
	love.graphics.draw(scenery, 0, 0, 0, 800/scenery:getWidth(), 600/scenery:getHeight());

	-- -- ME
	-- for i=1,station_count do
	-- 	love.graphics.circle('fill', station[i].x, station[i].y, mouse_range, 30)
	-- end

	-- MOI
	for i=1,object_count do
		if persona.current_object ~= i then
			object_draw(i)
		else
			object_animation(i)
		end
	end

	-- Personagem
	love.graphics.setColor(255, 255, 255)
	if persona.walking ~= nil then
		persona_walk(persona.walking)
	elseif persona.interacting ~= nil then
		persona_interact(persona.interacting)
	else
		persona_draw()
	end
end


-----------------------------------------------------------------------------------------------------------------
----------------------------------------------- Funções do ME ---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function station_id(gx, gy)
	for i=1,station_count do
		-- distância ao centro menor que mouse_range
		if math.sqrt(math.pow(gx - station[i].x, 2) + math.pow(gy - station[i].y, 2)) < mouse_range then
			return i
		end
	end
	return nil
end

function valid_station(destination)
	if persona.current_station ~= nil and math.floor(station[persona.current_station].bl 
		/ math.pow(2,destination - 1)) % 2 == 1 then
		return true
	end
	return false
end 

function set_destination(destination)
	-- está no meio do caminho, ou destino inválido
	if destination == nil or persona.current_station == nil or persona.current_object ~= nil then 
		return
	-- é ímpar, pode ir até lá
	elseif valid_station(destination) then 
		persona.fx, persona.fy = station[destination].x, station[destination].y
		persona.current_station = nil
		if station[destination].x < persona.x then
			persona.walking = 'l'
		elseif station[destination].x >= persona.x then
			persona.walking = 'r'
		end
	end
end

function walk()
	if persona.fx == nil then
		return
	elseif math.abs(persona.fx - persona.x) < speed and math.abs(persona.fy - persona.y) < speed then
		persona.x = persona.fx
		persona.y = persona.fy
		persona.fx = nil
		persona.fy = nil
		local a, b = persona.x, persona.y
		persona.current_station = station_id(a, b)
		persona.walking = nil
		persona.walk_count = 0
	else
		local hipotenuse = math.sqrt(math.pow(persona.fx - persona.x, 2) + math.pow(persona.fy - persona.y, 2))
		persona.x = persona.x + speed * (persona.fx - persona.x) / hipotenuse
		persona.y = persona.y + speed * (persona.fy - persona.y) / hipotenuse
	end
end


-----------------------------------------------------------------------------------------------------------------
----------------------------------------------- Funções do MOI --------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function object_id(gx, gy)
	i = object_count + 1
	while true do
		i = i - 1
		if i < 1 then
			break
		end
		-- distância ao centro menor que mouse_range
		if math.sqrt(math.pow(gx - object[i].x, 2) + math.pow(gy - object[i].y, 2)) < mouse_range then
			return i
		end
	end
	-- for i=object_count,1 do
	-- 	-- distância ao centro menor que mouse_range
	-- 	if math.sqrt(math.pow(gx - object[i].x, 2) + math.pow(gy - object[i].y, 2)) < mouse_range then
	-- 		return i
	-- 	end
	-- end
	return nil
end

function valid_object(interaction)
	if persona.current_station ~= nil and math.floor(object[interaction].bl / math.pow(2,persona.current_station - 1)) % 2 == 1 then 
		return true
	end
	return false
end

function set_interaction(interaction)
	-- está no meio do caminho, ou destino inválido
	if interaction == nil or persona.current_object ~= nil or persona.current_station == nil then 
		return

	-- é ímpar, pode interagir com o objeto
	elseif valid_object(interaction) then 
		persona.current_object = interaction;
		if object[interaction].x < persona.x then
			persona.interacting = 'l'
		else
			persona.interacting = 'r'
		end
	end
end

-----------------------------------------------------------------------------------------------------------------
------------------------------------------ Funções da Animação --------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function persona_draw()
	love.graphics.draw(persona.static_img.img, persona.x, persona.y, persona.static_img.rad, 
		persona.static_img.prop, persona.static_img.prop, 
		persona.static_img.offset_x * persona.static_img.img:getWidth(), 
		persona.static_img.offset_y * persona.static_img.img:getHeight())
end


function persona_walk(direction)
	persona.walk_count = persona.walk_count + 1
	local counter = math.floor((persona.walk_count % (4 * cycle_frame)) / cycle_frame) + 1
	if direction == 'l' then
		love.graphics.draw(
			persona.walkl[counter].img, persona.x, persona.y, persona.walkl[counter].rad, 
			persona.walkl[counter].prop, persona.walkl[counter].prop, 
			persona.walkl[counter].offset_x * persona.walkl[counter].img:getWidth(), --250
			persona.walkl[counter].offset_y * persona.walkl[counter].img:getHeight()) --800
	elseif direction == 'r' then
		love.graphics.draw(
			persona.walkr[counter].img, persona.x, persona.y, persona.walkr[counter].rad, 
			persona.walkr[counter].prop, persona.walkr[counter].prop, 
			persona.walkr[counter].offset_x * persona.walkr[counter].img:getWidth(), --250
			persona.walkr[counter].offset_y * persona.walkr[counter].img:getHeight()) --800
	end
end

function persona_interact(direction)
	persona.int_count = persona.int_count + 1
	local counter = math.floor(persona.int_count / cycle_frame) + 1
	if counter < 4 then
		if direction == 'l' then
			love.graphics.draw(
				persona.intl[counter].img, persona.x, persona.y, persona.intl[counter].rad, 
				persona.intl[counter].prop, persona.intl[counter].prop, 
				persona.intl[counter].offset_x * persona.intl[counter].img:getWidth(), --250
				persona.intl[counter].offset_y * persona.intl[counter].img:getHeight()) --800
		elseif direction == 'r' then
			love.graphics.draw(
				persona.intr[counter].img, persona.x, persona.y, persona.intr[counter].rad, 
				persona.intr[counter].prop, persona.intr[counter].prop, 
				persona.intr[counter].offset_x * persona.intr[counter].img:getWidth(), --250
				persona.intr[counter].offset_y * persona.intr[counter].img:getHeight()) --800
		end
	elseif counter >= 4 then
		if direction == 'l' then
			love.graphics.draw(
				persona.intl[4].img, persona.x, persona.y, persona.intl[4].rad, 
				persona.intl[4].prop, persona.intl[4].prop, 
				persona.intl[4].offset_x * persona.intl[4].img:getWidth(),
				persona.intl[4].offset_y * persona.intl[4].img:getHeight())
		elseif direction == 'r' then
			love.graphics.draw(
				persona.intr[4].img, persona.x, persona.y, persona.intr[4].rad, 
				persona.intr[4].prop, persona.intr[4].prop, 
				persona.intr[4].offset_x * persona.intr[4].img:getWidth(),
				persona.intr[4].offset_y * persona.intr[4].img:getHeight())
		end
	end
end

function object_draw(interaction)
	if interaction > object_count then
		return
	end
	-- love.graphics.draw(object[interaction].static_img, object[interaction].x, object[interaction].y)
	local phase = object[interaction].current_phase
	love.graphics.draw(
		object[interaction][phase].static_img.img, object[interaction].x, object[interaction].y, 
		object[interaction][phase].static_img.rad, 
		object[interaction][phase].static_img.prop, object[interaction][phase].static_img.prop,
		object[interaction][phase].static_img.offset_x * object[interaction][phase].static_img.img:getWidth(), 
		object[interaction][phase].static_img.offset_y * object[interaction][phase].static_img.img:getHeight())
end

function object_animation(interaction)
	if interaction == nil then
		return
	end
	object_cycle_count = object_cycle_count + 1
	local phase = object[interaction].current_phase
	if math.floor(object_cycle_count / cycle_frame) >= object[interaction][phase].duration then
		object[persona.current_object][phase].action()
		persona.current_object = nil
		persona.interacting = nil
		object_cycle_count = 0
		persona.int_count = 0
	else
		image_cycle(interaction, phase)
	end
end

function image_cycle(interaction, phase)
	local counter = math.floor((object_cycle_count % (object[interaction][phase].length 
		* cycle_frame)) / cycle_frame) + 1
	-- love.graphics.draw(object[interaction][phase][counter], object[interaction].x, object[interaction].y)
	love.graphics.draw(
		object[interaction][phase][counter].img, object[interaction].x, 
		object[interaction].y, object[interaction][phase][counter].rad, 
		object[interaction][phase][counter].prop, object[interaction][phase][counter].prop, 
		object[interaction][phase][counter].offset_x * object[interaction][phase][counter].img:getWidth(), 
		object[interaction][phase][counter].offset_y * object[interaction][phase][counter].img:getHeight())
end
