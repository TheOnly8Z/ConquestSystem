ConquestSystem.CapturePoints = {}



include("ui/cq_button.lua")
include("ui/cq_listview.lua")
include("ui/base.lua")



ConquestSystem.Materials = {}
ConquestSystem.Materials["circle32"] = Material("materials/conquestsystem/circle32.png", "noclamp smooth")
ConquestSystem.Materials["circle64"] = Material("materials/conquestsystem/circle64.png", "noclamp smooth")
ConquestSystem.Materials["circle128"] = Material("materials/conquestsystem/circle128.png", "noclamp smooth")

ConquestSystem.Materials["square32"] = Material("materials/conquestsystem/square32.png", "noclamp smooth")
ConquestSystem.Materials["square64"] = Material("materials/conquestsystem/square64.png", "noclamp smooth")
ConquestSystem.Materials["square128"] = Material("materials/conquestsystem/square128.png", "noclamp smooth")

ConquestSystem.Materials["triangle32"] = Material("materials/conquestsystem/triangle32.png", "noclamp smooth")
ConquestSystem.Materials["triangle64"] = Material("materials/conquestsystem/triangle64.png", "noclamp smooth")
ConquestSystem.Materials["triangle128"] = Material("materials/conquestsystem/triangle128.png", "noclamp smooth")

function ConquestSystem.Materials.GetMaterial(name, pixelSize)
	if pixelSize <= 48 then return ConquestSystem.Materials[name .. "32"] end
	if pixelSize <= 96 then return ConquestSystem.Materials[name .. "64"] end
	return ConquestSystem.Materials[name .. "128"]
end


net.Receive("CS_NETPOINTS", function()
	ConquestSystem.CapturePoints = {}
	
	local count = net.ReadUInt(32)

	for i=1, count do
		local pointIndex = net.ReadUInt(32)
		local pointTable = net.ReadTable()

		ConquestSystem.CapturePoints[pointIndex] = pointTable
	end

end)

net.Receive("CS_NOTIF", function()

	local contents = net.ReadString()
	local notifType = net.ReadInt(8)

	notification.AddLegacy(contents, notifType, 3)

end)


function ConquestSystem.RenderHUDIcon(point, x, y, dist, isVisible)
	local alpha = ConquestSystem.FadeInValue(dist)
	if alpha then surface.SetAlphaMultiplier(alpha/255) end

	local atPoint = dist < point.Radius
	if atPoint then

		local capturingPosition = ConquestSystem.Config.Positioning.WhenCapturing(ScrW(), ScrH())
		x = capturingPosition.x
		y = capturingPosition.y

	end

	local tx, ty, tw, th = 0, 0, 0, 0
	tw = ConquestSystem.Config.Sizes.IconForegroundShapeRadius
	th = ConquestSystem.Config.Sizes.IconForegroundShapeRadius
	tx = x + -tw/2
	ty = y + -th/2

	local outerCircleRadius = (ConquestSystem.Config.Sizes.IconForegroundShapeRadius/2) + 5
	local shapeMaterial = ConquestSystem.Materials.GetMaterial(point.Shape, ConquestSystem.Config.Sizes.IconForegroundShapeRadius)

	-- if the point is visible or if your at the point but not looking at it.
	-- render a background circle.
	if isVisible or (not isVisible and atPoint) then

		if atPoint and point.Capturing ~= nil then

			local timeAtPoint = CurTime() - point.Capturing
			local normalizedTime = timeAtPoint / ConquestSystem.Config.CaptureTime -- 0 to 1

			if normalizedTime <= 1 then

				render.ClearStencil()
				render.SetStencilEnable(true)
					render.SetStencilWriteMask( 1 )
					render.SetStencilTestMask( 1 )

					-- draw mask for counting down.
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
					render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
					render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)
					render.SetStencilReferenceValue(1)

					surface.SetDrawColor(1,1,1)
					ConquestSystem.RenderCircle(x, y, outerCircleRadius+100, 300, normalizedTime * 360)

					-- draw actual texture
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
					render.SetStencilReferenceValue(1)
					render.SetStencilFailOperation(STENCILOPERATION_ZERO)
					render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)

					surface.SetDrawColor(ConquestSystem.GetUserColour(LocalPlayer()))
					surface.SetMaterial(shapeMaterial)
					surface.DrawTexturedRect(tx - 5,ty - 5, tw + 10,th + 10) 


				render.SetStencilEnable(false)

			end

		end

	end

	-- paint the actual shape
	if point.Owner ~= nil then

		surface.SetDrawColor(ConquestSystem.GetPointColour(point))

	else

		surface.SetDrawColor(ConquestSystem.Config.Colours.HUDIconUncaptured)

	end
	surface.SetMaterial(shapeMaterial)
	surface.DrawTexturedRect(tx,ty, tw,th) 

	local tagy = y
	if point.Shape == "triangle" then
		tagy = tagy + (th/8)
	end

	draw.SimpleTextOutlined(point.Tag,
		ConquestSystem.Config.Fonts.Tag,
		x, tagy,
		ConquestSystem.Config.Colours.TagFill,
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
		1, Color(0,0,0,255))

	if isVisible or (not isVisible and atPoint) then

		draw.SimpleTextOutlined(point.Name,
			ConquestSystem.Config.Fonts.Name,
			x, y + (ConquestSystem.Config.Sizes.IconForegroundShapeRadius/2) + (ConquestSystem.Config.Positioning.TextPaddingTop),
			ConquestSystem.Config.Colours.NameFill,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, Color(0,0,0,255))

		draw.SimpleTextOutlined(math.Round(dist / 100) .. "m",
			ConquestSystem.Config.Fonts.Distance,
			x, y + (ConquestSystem.Config.Sizes.IconForegroundShapeRadius/2) + (ConquestSystem.Config.Positioning.TextPaddingTop) + (ConquestSystem.Config.Positioning.TextSpacing * 2),
			ConquestSystem.Config.Colours.DistanceFill,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, Color(0,0,0,255))
	end

	if alpha then surface.SetAlphaMultiplier(255) end
	
end

function ConquestSystem.RenderOppositionOwned(point, scrnW, scrnH)
	if not ConquestSystem.PointVisibility(point) then return end

	local screenData = point.Position:ToScreen()
	local x,y,visible = screenData.x, screenData.y, screenData.visible

	-- player facing vector
	local plyLookAt = LocalPlayer():GetAimVector()
	plyLookAt:Normalize()

	-- player to point vector
	local pointLookAt = Vector(point.Position.x, point.Position.y, point.Position.z)
	pointLookAt:Sub(LocalPlayer():GetPos())
	local dist = pointLookAt:Length()

	pointLookAt:Normalize()

	-- get visible angle check.
	local dot = plyLookAt:Dot( pointLookAt ) / pointLookAt:Length()
	local visible = math.deg(math.acos(dot)) < 46

	if visible then

		ConquestSystem.RenderHUDIcon(point, x, y, dist, visible)
		
	else

		-- calculate yaw difference.
		local plyLookY = plyLookAt:Angle().y
		local plyToPointY = pointLookAt:Angle().y

		local angDiff = math.AngleDifference(plyLookY, plyToPointY)

		-- convert -180 < x < 180 to 0 < x < 360
		if (angDiff < 0) then
			angDiff = 180 + (angDiff + 180)
		end

		-- rotate according to view
		angDiff = angDiff - 90

		local horiz, vert
		local offsetSize = ConquestSystem.Config.Sizes.IconForegroundShapeRadius

		vert = (scrnH/2) + (( (scrnH-(offsetSize*1.4)) / 2) * math.sin(math.rad(angDiff)))
		horiz = (scrnW/2) + (( (scrnW-offsetSize) / 2) * math.cos(math.rad(angDiff)))

		ConquestSystem.RenderHUDIcon(point, horiz, vert, dist, visible)

	end

end



hook.Add("HUDPaint", "DrawConquestIcons", function()
	local oW, oH = ScrW(), ScrH()

	cam.Start2D()

	for k,v in pairs(ConquestSystem.CapturePoints) do

		ConquestSystem.RenderOppositionOwned(v, oW, oH)

	end

	cam.End2D()
end)



function ConquestSystem.RenderCircle( x, y, radius, seg, angle )
	local cir = {}
	if angle == nil then angle = 360 end

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )

		if math.deg(a)*-1 <= angle then
			table.insert( cir, {
				x = x + math.sin( a ) * radius,
				y = y + math.cos( a ) * radius,
				u = math.sin( a ) / 2 + 0.5,
				v = math.cos( a ) / 2 + 0.5
			} )
		end
	end

	if angle ~= 360 then

		table.insert(cir, {
			x = x,
			y = y,
			u = 0.5,
			v = 0.5
		})

	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, {
		x = x + math.sin( a ) * radius,
		y = y + math.cos( a ) * radius,
		u = math.sin( a ) / 2 + 0.5,
		v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function ConquestSystem.PointVisibility(point)

	-- disallow view if not visible.
	if not ConquestSystem.Config.Visibility.SeeThroughWalls then

		local tr = util.TraceLine( {
			start = EyePos(),
			endpos = point.Position,
			filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
		} )

		return not tr.Hit

	else

		return true

	end
end

function ConquestSystem.FadeInValue(distance)

	if ConquestSystem.Config.Visibility.Fade.Enabled then

		-- at fadeStart alpha = 0,  
		local fadeStart = ConquestSystem.Config.Visibility.Fade.FadeInStartDistance
		local fadeEnd = ConquestSystem.Config.Visibility.Fade.FadeInEndDistance
		distance = distance / 100

		if distance > fadeStart then
			return 0
		elseif distance < fadeStart and distance > fadeEnd then
			
			-- normalize the distance between the start and the end
			local norm = 1/(fadeStart-fadeEnd)*(distance-fadeStart)+1

			return (1-norm) * 255

		elseif distance < fadeEnd then
			return 255
		end

	else

		return false

	end

end