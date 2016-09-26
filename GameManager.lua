GameManager={}
LEFT_SIDE=1
RIGHT_SIDE=2

GameManager.heros={}
GameManager.heros[LEFT_SIDE]={}
GameManager.heros[RIGHT_SIDE]={}

MAX_INT=10000000

local debug=false

function GameManager:init( )
	--init heros
	--init enemys
	--init all objects
	self.objects={}
	for k,v in pairs(self.heros[LEFT_SIDE]) do
		table.insert(self.objects,v)
	end
	for k,v in pairs(self.heros[RIGHT_SIDE]) do
		table.insert(self.objects,v)
	end
end

function GameManager:findNearestEnemy(hero)
	local battleSide=hero:getBattleSide()
	local minDis=MAX_INT
	local minDisEnemy=nil
	local enemySide=(battleSide==LEFT_SIDE and RIGHT_SIDE or LEFT_SIDE)
	assert(enemySide~=battleSide)
	for k,v in pairs(self.heros[enemySide]) do
		debug_print("hero:getPosition()",hero:getPosition())
		local dis=Util.getDistance(cc.p(hero:getPosition()),cc.p(v:getPosition()))
		if dis<minDis then
			minDis=dis
			minDisEnemy=v
		end
	end
	assert(minDisEnemy:getBattleSide()~=hero:getBattleSide())
	hero.nearestEnemy=minDisEnemy --不应该这样做？
	return minDisEnemy,minDis
end

function GameManager:hasEnemyInVision(hero)
	local nearestEnemy,dis=self:findNearestEnemy(hero)
	if dis<hero:getEyeRange() then
		return true
	else 
		return false
	end
end

function GameManager:hasEnemyInAttackRange(hero)
	local nearestEnemy,dis=self:findNearestEnemy(hero)
	debug_print("nearestEnemy.id: ",nearestEnemy.id)
	debug_print("nearestEnemy.pos: ",nearestEnemy:getPosition())
	debug_print("dis= ",dis,"       ","attackRange= ",hero:getAttackRange())
	if dis<hero:getAttackRange() then
		return true
	else 
		return false
	end
end


Cmd=class("Cmd")

CMD_MOVETO=1
CMD_ATTACK=2
CMD_SUPERATTACK=3

function Cmd:ctor(type,param)
	self.type=type
	self.param=param
end

function GameManager:setOperateHero(hero)
	self.operateHero=hero
end

function GameManager:isSelfSide(obj)
	return obj.battleSide==LEFT_SIDE
end

function GameManager:onTouch(pos)
	print("function GameManager:onTouch(des)")
	--if not Util.isWalkable(pos) then
		--Tips.show("障碍")
		--print("障碍障碍障碍障碍障碍障碍障碍障碍障碍障碍障碍障碍障碍障碍障碍")
		--return
	--end

	local obj=self:getObjectAtPos(pos)
	if nil==obj or tolua.isnull(obj) then
		print("self.operateHero.cmd=Cmd.new(CMD_MOVETO,pos)")
		print("self.operateHero.cmd=Cmd.new(CMD_MOVETO,pos)")
		print("self.operateHero.cmd=Cmd.new(CMD_MOVETO,pos)")
		print("self.operateHero.cmd=Cmd.new(CMD_MOVETO,pos)")
		print("self.operateHero.cmd=Cmd.new(CMD_MOVETO,pos)")
		self.operateHero.cmd=Cmd.new(CMD_MOVETO,pos)
	elseif self:isSelfSide(obj) and obj:isHuman() then
		print("self side self side self side")
		print("obj.id ",obj.id)
		print("obj.battleSide ",obj.battleSide)
		print(" self:isSelfSide(obj) and self:isHuman(obj) ")
		self:setOperateHero(obj)
	elseif not self:isSelfSide(obj)  then
		print("enemy side enemy side enemy side enemy side")
		print("obj.id ",obj.id)
		print("obj.id ",obj.id)
		print("obj.id ",obj.id)
		print("obj.id ",obj.id)
		print("obj.id ",obj.id)
		self.operateHero.cmd=Cmd.new(CMD_ATTACK,obj)
	end
end

Rect=class("Rect")

function Rect:ctor(cen,w,h)
	self.cen=cen --center
	self.hw=w/2 --half width
	self.hh=h/2
end

function  GameManager:getObjectAtPos(pos)
	for k,v in pairs(self.objects) do  --应该分区 ，四叉树、八叉树之类的，以提高效率
		local s=v.actor:getContentSize() --v:getContentSize()
		local rect=Rect.new(cc.p(v:getPosition()),s.width,s.height)--暂时默认锚点在中心
		if Util.isPointInRect(pos,rect) then
			print("v.id===========",v.id)
			print("v.size: ",s.width,s.height)
			print("v.pos: ",v:getPosition())
			return v
		end
	end

end

