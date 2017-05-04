concommand.Add("ConquestSystem_Open", function()
	local BaseFrame = vgui.Create("DFrame")
	BaseFrame:SetPos( ScrW()/2-150, ScrH()/2-90 )
	BaseFrame:SetSize( 300, 160 )
	BaseFrame:SetTitle( "Conquest System - Admin" )
	BaseFrame:SetVisible( true )
	BaseFrame:ShowCloseButton( false )
	BaseFrame:MakePopup()
	BaseFrame:NoClipping(true)
	BaseFrame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(24,24,24, 235) )
	end


	local PointListView = vgui.Create("cq_listview")	
	PointListView:SetPos(0, 28)
	PointListView:SetSize(205, 120)
	PointListView:SetMultiSelect( false )
	PointListView:AddColumnCustom( "Tag" )
	PointListView:AddColumnCustom( "Name" )
	PointListView:AddColumnCustom( "Team" )

	for k,v in pairs(ConquestSystem.CapturePoints) do
		PointListView:AddLine(v.Tag, v.Name, v.Owner)
	end

	PointListView:SetParent(BaseFrame)


	local CreateButton = vgui.Create("cq_button")
	CreateButton:SetPos(215, 28)
	CreateButton:SetSize(85, 20)
	CreateButton:NoClipping(true)
	CreateButton:SetBackgroundColor(Color(25, 180, 25, 255))
	CreateButton:SetText("Create")
	CreateButton.OnMousePressed = function(self) LocalPlayer():ConCommand("ConquestSystem_CreatePoint") end
	CreateButton:SetParent(BaseFrame)

	local DeleteButton = vgui.Create("cq_button")
	DeleteButton:SetPos(215, 28 + 20 + 5)
	DeleteButton:SetSize(85, 20)
	DeleteButton:NoClipping(true)
	DeleteButton:SetBackgroundColor(Color(180, 25, 25, 255))
	DeleteButton:SetText("Delete")
	DeleteButton.OnMousePressed = function(self) 
		local lineNumber = PointListView:GetSelectedLine()
		local value = PointListView:GetLine(lineNumber):GetValue(1)

		LocalPlayer():ConCommand("ConquestSystem_Sv_DeletePoint " .. value)
		PointListView:RemoveLine(lineNumber)
	end
	DeleteButton:SetParent(BaseFrame)

	local EditButton = vgui.Create("cq_button")
	EditButton:SetPos(215, 28 + 20 + 5 + 20 + 5)
	EditButton:SetSize(85, 20)
	EditButton:NoClipping(true)
	EditButton:SetBackgroundColor(Color(180, 180, 25, 255))
	EditButton:SetText("Edit Selected")
	EditButton.OnMousePressed = function(self)
		local lineNumber = PointListView:GetSelectedLine()
		if lineNumber == nil then return end
		local value = PointListView:GetLine(lineNumber):GetValue(1)

		LocalPlayer():ConCommand("ConquestSystem_EditPoint " .. value)
	end
	EditButton:SetParent(BaseFrame)

	local CloseButton = vgui.Create("cq_button")
	CloseButton:SetPos(215, 28 + 20 + 5 + 20 + 5 + 20 + 5 + 20 + 5)
	CloseButton:SetSize(85, 20)
	CloseButton:NoClipping(true)
	CloseButton:SetBackgroundColor(Color(255,255,255,255))
	CloseButton:SetText("Close")
	CloseButton.OnMousePressed = function(self) self:GetParent():Close() end
	CloseButton:SetParent(BaseFrame)

	local CreditLabel = vgui.Create("DLabel")
	CreditLabel:SetText("Bambö © 2016")
	CreditLabel:SetPos(120, 175-32 + 5)
	CreditLabel:SetFont("HudHintTextSmall")
	CreditLabel:SizeToContents()
	CreditLabel:SetParent(BaseFrame)
end)

concommand.Add("ConquestSystem_EditPoint", function(ply, cmd, args)
	local pointTag = args[1]

	-- find that point
	local foundPoint = nil
	for k,v in pairs(ConquestSystem.CapturePoints) do

		if v.Tag == pointTag then

			foundPoint = v

		end

	end

	if foundPoint == nil then return end

	local BaseFrame = vgui.Create("DFrame")
	BaseFrame:SetPos( ScrW()/2+150, ScrH()/2-90  )
	BaseFrame:SetSize( 128, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 32 + 20 + 20 + 20 + 20 + 32 + 128)
	BaseFrame:SetTitle( "Edit Point (" .. foundPoint.Tag ..")" )
	BaseFrame:SetVisible( true )
	BaseFrame:ShowCloseButton( false )
	BaseFrame:MakePopup()
	BaseFrame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(24,24,24, 235) )
	end

	local TagLabel = vgui.Create("DLabel")
	TagLabel:SetText("Tag: (Single letter or number)")
	TagLabel:SetPos(2, 20 + 8)
	TagLabel:SetFont("HudHintTextSmall")
	TagLabel:SizeToContents()
	TagLabel:SetParent(BaseFrame)

	local TagInput = vgui.Create("DTextEntry")
	TagInput:SetPos(0, 20 + 8 + 12)
	TagInput:SetSize(128, 20)
	TagInput:SetText(foundPoint.Tag)
	TagInput:SetParent(BaseFrame)


	local NameLabel = vgui.Create("DLabel")
	NameLabel:SetText("Name:")
	NameLabel:SetPos(2, 20 + 8 + 12 + 24)
	NameLabel:SetFont("HudHintTextSmall")
	NameLabel:SizeToContents()
	NameLabel:SetParent(BaseFrame)

	local NameInput = vgui.Create("DTextEntry")
	NameInput:SetPos(0, 20 + 8 + 12 + 24 + 12)
	NameInput:SetSize(128, 20)
	NameInput:SetText(foundPoint.Name)
	NameInput:SetParent(BaseFrame)


	local RadiusLabel = vgui.Create("DLabel")
	RadiusLabel:SetText("Radius: (Size of capture circle)")
	RadiusLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24)
	RadiusLabel:SetFont("HudHintTextSmall")
	RadiusLabel:SizeToContents()
	RadiusLabel:SetParent(BaseFrame)

	local RadiusInput = vgui.Create("DTextEntry")
	RadiusInput:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12)
	RadiusInput:SetSize(128, 20)
	RadiusInput:SetText( tonumber(foundPoint.Radius / 100) )
	RadiusInput:SetParent(BaseFrame)

	local ShapeLabel = vgui.Create("DLabel")
	ShapeLabel:SetText("Shape:")
	ShapeLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24)
	ShapeLabel:SetFont("HudHintTextSmall")
	ShapeLabel:SizeToContents()
	ShapeLabel:SetParent(BaseFrame)

	local ShapeInput = vgui.Create("DComboBox")
	ShapeInput:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 20 + 14)
	ShapeInput:SetSize(128, 20)
	ShapeInput:SetValue("Select a shape...")
	ShapeInput:AddChoice("circle")
	ShapeInput:AddChoice("triangle")
	ShapeInput:AddChoice("square")
	if foundPoint.Shape == "circle" then ShapeInput:ChooseOptionID(1) end
	if foundPoint.Shape == "triangle" then ShapeInput:ChooseOptionID(2) end
	if foundPoint.Shape == "square" then ShapeInput:ChooseOptionID(3) end
	ShapeInput:SetParent(BaseFrame)

	local CategoryLabel = vgui.Create("DLabel")
	CategoryLabel:SetText("Category Based (DarkRP)")
	CategoryLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20)
	CategoryLabel:SetFont("HudHintTextSmall")
	CategoryLabel:SizeToContents()
	CategoryLabel:SetParent(BaseFrame)

	local CategoryCheckBox = vgui.Create("DCheckBox")
	CategoryCheckBox:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20 + 12)
	local value = 0
	if foundPoint.CategoryEnabled then value = 1 end
	CategoryCheckBox:SetValue(value)
	CategoryCheckBox:SetParent(BaseFrame)

	local DisallowedTeamsLabel = vgui.Create("DLabel")
	DisallowedTeamsLabel:SetText("Disallow Teams (multiselect):")
	DisallowedTeamsLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20 + 12 + 20)
	DisallowedTeamsLabel:SetFont("HudHintTextSmall")
	DisallowedTeamsLabel:SizeToContents()
	DisallowedTeamsLabel:SetParent(BaseFrame)

	local DisallowedTeamsListView = vgui.Create("cq_listview")
	DisallowedTeamsListView:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20 + 12 + 20 + 12)
	DisallowedTeamsListView:SetSize(128,128)
	DisallowedTeamsListView:AddColumnCustom("Team/Job")
	DisallowedTeamsListView:AddColumnCustom("Category")
	DisallowedTeamsListView:SetParent(BaseFrame)

	if ConquestSystem.Config.DarkRP then

		-- list using darkrp system
		for k,v in pairs(DarkRP.getCategories().jobs) do

			for i,j in pairs(v.members) do

				local line = DisallowedTeamsListView:AddLine(j.command, j.category)

				if foundPoint.DisallowedTeams ~= nil then
					for index,teamName in pairs(foundPoint.DisallowedTeams) do

						if teamName == j.command or teamName == j.category then

							DisallowedTeamsListView:SelectItem(line)

						end

					end
				end
			end

		end

	else

		local teamList = team.GetAllTeams()
		
		for k,v in pairs(teamList) do

			local line = DisallowedTeamsListView:AddLine(v.Name, "N/A")

			for index,teamName in pairs(foundPoint.DisallowedTeams) do

				if teamName == v.Name then

					DisallowedTeamsListView:SelectItem(line)

				end

			end

		end

	end



	local w, h = BaseFrame:GetSize()
	local AcceptButton = vgui.Create("cq_button")
	AcceptButton:SetPos(0, h-40)
	AcceptButton:SetBackgroundColor(Color(25, 180, 25, 255))
	AcceptButton:SetSize(128, 20)
	AcceptButton:SetText("Accept")
	AcceptButton.OnMousePressed = function(self)
		local checkedVal = 0
		if CategoryCheckBox:GetChecked() then checkedVal = 1 end
		local selectedShape, _ = ShapeInput:GetSelected()

		local disallowedTeams = {}
		local selectedLines = DisallowedTeamsListView:GetSelected()
		for k,v in pairs(selectedLines) do

			table.insert(disallowedTeams, v:GetColumnText(1))

		end
		local disallowedTeamsStr = util.TableToJSON(disallowedTeams)
		disallowedTeamsStr = string.Replace(disallowedTeamsStr, "\"", "'")

		LocalPlayer():ConCommand("ConquestSystem_Sv_EditPoint " .. TagInput:GetValue() .. " " .. NameInput:GetValue() .. "  " .. RadiusInput:GetValue() .. "  " .. checkedVal .. " " .. selectedShape .. " \"" .. disallowedTeamsStr .. "\"")
		BaseFrame:Close()
	end
	AcceptButton:SetParent(BaseFrame)

	local CancelButton = vgui.Create("cq_button")
	CancelButton:SetPos(0, h-20)
	CancelButton:SetBackgroundColor(Color(255,255,255,255))
	CancelButton:SetSize(128, 20)
	CancelButton:SetText("Cancel")
	CancelButton.OnMousePressed = function(self)
		self:GetParent():Close()
	end
	CancelButton:SetParent(BaseFrame)
end)

concommand.Add("ConquestSystem_CreatePoint", function()
	local BaseFrame = vgui.Create("DFrame")
	BaseFrame:SetPos( ScrW()/2+150, ScrH()/2-90 )
	BaseFrame:SetSize( 128, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 32 + 20 + 20 + 20 + 20 + 32 + 140)
	BaseFrame:SetTitle( "Create Point" )
	BaseFrame:SetVisible( true )
	BaseFrame:ShowCloseButton( false )
	BaseFrame:MakePopup()
	BaseFrame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(24,24,24, 235) )
	end

	local TagLabel = vgui.Create("DLabel")
	TagLabel:SetText("Tag: (Single letter or number)")
	TagLabel:SetPos(2, 20 + 8)
	TagLabel:SetFont("HudHintTextSmall")
	TagLabel:SizeToContents()
	TagLabel:SetParent(BaseFrame)

	local TagInput = vgui.Create("DTextEntry")
	TagInput:SetPos(0, 20 + 8 + 12)
	TagInput:SetSize(128, 20)
	TagInput:SetParent(BaseFrame)


	local NameLabel = vgui.Create("DLabel")
	NameLabel:SetText("Name:")
	NameLabel:SetPos(2, 20 + 8 + 12 + 24)
	NameLabel:SetFont("HudHintTextSmall")
	NameLabel:SizeToContents()
	NameLabel:SetParent(BaseFrame)

	local NameInput = vgui.Create("DTextEntry")
	NameInput:SetPos(0, 20 + 8 + 12 + 24 + 12)
	NameInput:SetSize(128, 20)
	NameInput:SetParent(BaseFrame)


	local RadiusLabel = vgui.Create("DLabel")
	RadiusLabel:SetText("Radius: (Size of capture circle)")
	RadiusLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24)
	RadiusLabel:SetFont("HudHintTextSmall")
	RadiusLabel:SizeToContents()
	RadiusLabel:SetParent(BaseFrame)

	local RadiusInput = vgui.Create("DTextEntry")
	RadiusInput:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12)
	RadiusInput:SetSize(128, 20)
	RadiusInput:SetValue(6)
	RadiusInput:SetParent(BaseFrame)

	local ShapeLabel = vgui.Create("DLabel")
	ShapeLabel:SetText("Shape:")
	ShapeLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24)
	ShapeLabel:SetFont("HudHintTextSmall")
	ShapeLabel:SizeToContents()
	ShapeLabel:SetParent(BaseFrame)

	local ShapeInput = vgui.Create("DComboBox")
	ShapeInput:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 20 + 14)
	ShapeInput:SetSize(128, 20)
	ShapeInput:SetValue("Select a shape...")
	ShapeInput:AddChoice("circle")
	ShapeInput:AddChoice("triangle")
	ShapeInput:AddChoice("square")
	ShapeInput:ChooseOptionID(1)
	ShapeInput:SetParent(BaseFrame)

	local CategoryLabel = vgui.Create("DLabel")
	CategoryLabel:SetText("Category Based (DarkRP)")
	CategoryLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20)
	CategoryLabel:SetFont("HudHintTextSmall")
	CategoryLabel:SizeToContents()
	CategoryLabel:SetParent(BaseFrame)

	local CategoryCheckBox = vgui.Create("DCheckBox")
	CategoryCheckBox:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20 + 12)
	CategoryCheckBox:SetValue(0)
	CategoryCheckBox:SetParent(BaseFrame)

	local DisallowedTeamsLabel = vgui.Create("DLabel")
	DisallowedTeamsLabel:SetText("Disallow Teams (multiselect):")
	DisallowedTeamsLabel:SetPos(2, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20 + 12 + 20)
	DisallowedTeamsLabel:SetFont("HudHintTextSmall")
	DisallowedTeamsLabel:SizeToContents()
	DisallowedTeamsLabel:SetParent(BaseFrame)

	local DisallowedTeamsListView = vgui.Create("cq_listview")
	DisallowedTeamsListView:SetPos(0, 20 + 8 + 12 + 24 + 12 + 24 + 12 + 24 + 12 + 20 + 12 + 20 + 12)
	DisallowedTeamsListView:SetSize(128,128)
	DisallowedTeamsListView:AddColumnCustom("Team/Job")
	DisallowedTeamsListView:AddColumnCustom("Category")
	DisallowedTeamsListView:SetParent(BaseFrame)

	if ConquestSystem.Config.DarkRP then

		-- list using darkrp system
		for k,v in pairs(DarkRP.getCategories().jobs) do

			for i,j in pairs(v.members) do

				DisallowedTeamsListView:AddLine(j.command, j.category)


			end

		end

	else

		local teamList = team.GetAllTeams()
		
		for k,v in pairs(teamList) do

			DisallowedTeamsListView:AddLine(v.Name, "N/A")

		end

	end

	local w, h = BaseFrame:GetSize()
	local AcceptButton = vgui.Create("cq_button")
	AcceptButton:SetPos(0, h-40)
	AcceptButton:SetBackgroundColor(Color(25, 180, 25, 255))
	AcceptButton:SetSize(128, 20)
	AcceptButton:SetText("Accept")
	AcceptButton.OnMousePressed = function(self)
		local checkedVal = 0
		if CategoryCheckBox:GetChecked() then checkedVal = 1 end
		local selectedShape, _ = ShapeInput:GetSelected()

		local disallowedTeams = {}
		local selectedLines = DisallowedTeamsListView:GetSelected()
		for k,v in pairs(selectedLines) do

			table.insert(disallowedTeams, v:GetColumnText(1))

		end
		local disallowedTeamsStr = util.TableToJSON(disallowedTeams)
		disallowedTeamsStr = string.Replace(disallowedTeamsStr, "\"", "'")

		local concommand = "ConquestSystem_Sv_CreatePoint " .. TagInput:GetValue() .. " \"" .. NameInput:GetValue() .. "\"  " .. RadiusInput:GetValue() .. " " .. checkedVal .. " " .. selectedShape .. " \"" .. disallowedTeamsStr .. "\""
		LocalPlayer():ConCommand(concommand)
		BaseFrame:Close()
	end
	AcceptButton:SetParent(BaseFrame)

	local CancelButton = vgui.Create("cq_button")
	CancelButton:SetPos(0, h-20)
	CancelButton:SetBackgroundColor(Color(255,255,255,255))
	CancelButton:SetSize(128, 20)
	CancelButton:SetText("Cancel")
	CancelButton.OnMousePressed = function(self)
		self:GetParent():Close()
	end
	CancelButton:SetParent(BaseFrame)
end)

--[[-------------------------------------------------------------------------
Player Spawning
---------------------------------------------------------------------------]]
concommand.Add("ConquestSystem_DeathMenu", function(ply, cmd, args)
	local points = ConquestSystem.GetPlayerOwnedPoints(LocalPlayer())

	if table.Count(points) > 0 then
		local BaseFrame = vgui.Create("DFrame")
		BaseFrame:SetPos( ScrW()/2-64, ScrH()/2-(170/2)  )
		BaseFrame:SetSize( 128, 170)
		BaseFrame:SetTitle( "Choose spawn point" )
		BaseFrame:SetVisible( true )
		BaseFrame:ShowCloseButton( false )
		BaseFrame:MakePopup()
		BaseFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(24,24,24, 235) )
		end

		local PointListView = vgui.Create("cq_listview")	
		PointListView:SetPos(0, 28)
		PointListView:SetSize(128, 120)
		PointListView:SetMultiSelect( false )
		PointListView:AddColumnCustom( "Tag" )
		PointListView:AddColumnCustom( "Name" )

		for k,v in pairs(points) do
			PointListView:AddLine(v.Tag, v.Name)
		end

		PointListView:SetParent(BaseFrame)

		local w, h = BaseFrame:GetSize()
		local SpawnButton = vgui.Create("cq_button")
		SpawnButton:SetPos(0, h-20)
		SpawnButton:SetBackgroundColor(Color(255,255,255,255))
		SpawnButton:SetSize(128, 20)
		SpawnButton:SetText("Spawn")
		SpawnButton.OnMousePressed = function(self)
			local selectedLines = PointListView:GetSelected()

			if (table.Count(selectedLines) > 0) then
				local tag = selectedLines[1]:GetColumnText(1)

				LocalPlayer():ConCommand("ConquestSystem_Sv_SetSpawn " .. tag)

				self:GetParent():Close()
			end
		end

		SpawnButton:SetParent(BaseFrame)
	end
end)