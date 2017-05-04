local ELEMENT = {}

function ELEMENT:Init()
	self:NoClipping(true)
	self.Header:SetContentAlignment(5)
end

function ELEMENT:Paint(w, h)
	self.Header:SetTextColor(Color(0,0,0,255))

	surface.SetDrawColor(Color(155,155,155, 255))
	surface.DrawRect(0,0, w+1,h)
end
vgui.Register("cq_listview_column", ELEMENT, "DListView_ColumnPlain")


ELEMENT = {}

function ELEMENT:Init()
	self:NoClipping(true)
end

function ELEMENT:Paint(w, h)
	surface.SetDrawColor(Color(255,255,255, 255))
	surface.DrawRect(0,0, w,h)
end

function ELEMENT:AddColumnCustom(title)
	local pColumn = nil

	pColumn = vgui.Create( "cq_listview_column", self )

	pColumn:SetName( title )
	pColumn:SetZPos( 10 )

	local ID = table.insert( self.Columns, pColumn )
	pColumn:SetColumnID( ID )

	self:InvalidateLayout()

	return pColumn
end

vgui.Register("cq_listview", ELEMENT, "DListView")
