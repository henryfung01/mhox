local Actor=class("Actor",function(path,armatureName) 
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path..armatureName..".ExportJson")
	return ccs.Armature:create(armatureName) 
	end)

--角色不规则（非rectangle）图形，怎么进行碰撞检测

function Actor:getContentSize()
	return {width=100,height=100}
end

return Actor
	