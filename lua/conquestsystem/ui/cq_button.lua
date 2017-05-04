local ELEMENT = {}

function ELEMENT:Init()
	self.text = ""
end

function ELEMENT:SetText(text)
	self.text = text
end

function ELEMENT:SetBackgroundColor(color)
	self.bgColor = color
end

function ELEMENT:Paint(w, h)
	local wAdd = 0
	if self.hovered then
		local timeSinceEntered = CurTime() - self.enteredTime

		if timeSinceEntered < 0.5 then
			wAdd = (timeSinceEntered * 2) * 20
		else
			wAdd = 20
		end
	else
		if self.exitedTime ~= nil then
			local timeSinceExited = CurTime() - self.exitedTime

			if timeSinceExited < 1 then
				wAdd = 20 + ( (1-timeSinceExited*5) / 5) * 20
			else
				wAdd = 0
			end
		end
	end

	surface.SetDrawColor(self.bgColor)
	surface.DrawRect(0,0, w+wAdd,h)

	surface.SetFont("DermaDefault")
	surface.SetTextColor(Color(0,0,0,255))

	local tw, th = surface.GetTextSize(self.text)
	surface.SetTextPos(w/2 - tw/2, h/2 - th/2)
	surface.DrawText(self.text)
end

function ELEMENT:OnCursorEntered()

	self.hovered = true
	self.enteredTime = CurTime()

end

function ELEMENT:OnCursorExited()

	self.hovered = false
	self.exitedTime = CurTime()

end

vgui.Register("cq_button", ELEMENT, "Panel")
