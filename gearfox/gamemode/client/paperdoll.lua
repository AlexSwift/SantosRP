local meta = FindMetaTable("Player")

function meta:AttachModel(ID,BoneID,offpos,offang,scale,Model)
	if (!self._AM) then self._AM = {} end
	if (self._AM[ID] and IsValid(self._AM[ID].CEnt)) then self._AM[ID].CEnt:Remove() end
	
	self._AM[ID] = {CEnt = ClientsideModel(Model), BID = BoneID,}
	self._AM[ID].CEnt:SetModelScale(scale)
	self._AM[ID].CEnt:FollowBone(self,BoneID)
	self._AM[ID].CEnt:SetLocalPos(offpos)
	self._AM[ID].CEnt:SetLocalAngles(offang)
end

function meta:DetachModel(ID)
	if (!self._AM) then return end
	if (self._AM[ID] and IsValid(self._AM[ID].CEnt)) then self._AM[ID].CEnt:Remove() end
	self._AM[ID] = nil
end

function meta:GetModelByID(ID)
	if (!self._AM) then return NULL end
	return self._AM[ID]
end

function meta:GetModels()
	return self._AM or {}
end
