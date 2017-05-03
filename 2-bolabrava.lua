if alimento == nil then
	alimento = 1
	object[2].current_phase = 1
	stage_conf[4][2] = 1
elseif alimento < 8 then
	alimento = alimento + 1
	object[2].current_phase = 1
	stage_conf[4][2] = 1
else
	stage_conf[5][3] = 2
	object[2].current_phase = 3
	stage_conf[4][2] = 3
	raiva_end = true
end
persona.equipped = nil