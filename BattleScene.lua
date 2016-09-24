GAMEFRAME=1.0/60

local BattleScene=class("BattleScene",cc.Scene)

function BattleScene:ctor()
	local fightView=FightView.new()
	self:addChild(fightView)
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(self.update, GAMEFRAME, false)
end

function BattleScene:update()

end

function BattleScene:run()
	local scene=director:getRunningScene()
	if nil==scene or tolua.isnull(scene) then
		director:runWithScene(self)
	else
		director:replaceScene(self)
	end
end

return BattleScene