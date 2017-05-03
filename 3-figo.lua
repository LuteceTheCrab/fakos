if persona.equipped == nil then
	return
elseif persona.equipped == "colar" then
	persona.equipped = nil
	object[6].current_phase = 3
	stage_conf[stage_number][6] = 3
	if stage_conf[7][3] == 2 then
		stage_conf[7][3] = 1
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