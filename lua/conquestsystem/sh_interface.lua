function ConquestSystem.GetPointColour(point)
	if point.CategoryEnabled then

		if ConquestSystem.Config.DarkRP then

			if LocalPlayer():getJobTable().command == point.Owner then

				return LocalPlayer():getJobTable().color

			end

			return Color(255,0,0,255)

		else

			-- find that team
			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == point.Owner then

					return v.Color

				end

			end

			return Color(255,255,255,255)

		end

	else

		if ConquestSystem.Config.DarkRP then

			return ConquestSystem.FindTeamByCommand(point.Owner).color

		else

			-- find that team
			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == point.Owner then

					return v.Color

				end

			end

			return Color(255,255,255,255)

		end

	end
end


function ConquestSystem.GetUserColour(ply)
	-- default system, returns darkrp team if flag set, normal team if not.
	if ConquestSystem.Config.DarkRP then

		local job = RPExtraTeams[ply:Team()]
		return job.color

	else

		return team.GetColor(ply:Team())

	end
end

function ConquestSystem.GetTeamName(point, ply)

	if ConquestSystem.Config.DarkRP then

		local job = RPExtraTeams[ply:Team()]

		if point.CategoryEnabled then

			return job.category

		else

			return job.command

		end

	else

		return team.GetName(ply:Team())

	end

end

function ConquestSystem.GetTeamNameWithoutCategory(ply)

	if ConquestSystem.Config.DarkRP then

		local job = RPExtraTeams[ply:Team()]

		return job.command

	else

		return team.GetName(ply:Team())

	end

end

function ConquestSystem.GetTeamShape(point, ply)

	if ConquestSystem.Config.TeamShapes[ConquestSystem.GetTeamName(point, ply)] ~= nil then

		return ConquestSystem.Config.TeamShapes[ConquestSystem.GetTeamName(point, ply)]

	end

	return 32
end

function ConquestSystem.FindTeamByCommand(command)

	for k,v in pairs(RPExtraTeams) do

		if v.command == command then

			return v

		end

	end

end

function ConquestSystem.GetPlayerOwnedPoints(ply)

	local ownedPoints = {}

	local points
	if SERVER then points = ConquestSystem.Points else points = ConquestSystem.CapturePoints end

	for k,v in pairs(points) do

		local owner = v.Owner

		local relativeName = ConquestSystem.GetTeamName(v, ply)

		if (owner == relativeName) then

			table.insert(ownedPoints, v)

		end

	end

	return ownedPoints

end