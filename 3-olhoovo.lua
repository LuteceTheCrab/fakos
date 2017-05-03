if persona.equipped == nil then
	persona.equipped = "olhoovo"
	object[4].current_phase = 2
	stage_conf[stage_number][4] = 2
	stage_conf[9][2] = 2
	if stage_conf[8][6] == 1 then
		stage_conf[8][6] = 2
		object[6].current_phase = 2
	end
	if stage_conf[7][3] == 1 then
		stage_conf[7][3] = 2
	end
end