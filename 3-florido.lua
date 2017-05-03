if persona.equipped == nil then
	return
elseif persona.equipped == "pimenta" then
	persona.equipped = nil
	object[3].current_phase = 3
	stage_conf[stage_number][3] = 3
	if stage_conf[8][6] == 2 then
		stage_conf[8][6] = 1
	end
	if stage_conf[9][2] == 2 then
		stage_conf[9][2] = 1
	end
	if convidados == nil then
		convidados = 1
	elseif convidados == 1 then
		convidados = 2
	else
		barganha_end = true
	end
end