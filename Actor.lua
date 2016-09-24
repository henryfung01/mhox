local Actor=class("Actor",function(path,armatureName) 
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path..armatureName..".ExportJson")
	return ccs.Armature:create(armatureName) 
	end)

return Actor
	