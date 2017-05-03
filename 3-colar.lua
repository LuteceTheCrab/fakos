if persona.equipped == nil then
	persona.equipped = "colar"
	object[3].current_phase = 2
	stage_conf[stage_number][3] = 2
	object[6].current_phase = 2
	stage_conf[stage_number][6] = 2
	if stage_conf[7][3] == 1 then
		stage_conf[7][3] = 2
	end
	if stage_conf[9][2] == 1 then
		stage_conf[9][2] = 2
	end
end