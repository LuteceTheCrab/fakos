if persona.equipped == nil then
	persona.equipped = "pimenta"
	object[4].current_phase = 2
	stage_conf[stage_number][4] = 2
	object[3].current_phase = 2
	stage_conf[stage_number][3] = 2
	if stage_conf[8][6] == 1 then
		stage_conf[8][6] = 2
	end
	if stage_conf[9][2] == 1 then
		stage_conf[9][2] = 2
	end
end