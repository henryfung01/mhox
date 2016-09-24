GameManager={}
LEFT_SIDE=1
RIGHT_SIDE=2

GameManager.heros={}
GameManager.heros[LEFT_SIDE]={}
GameManager.heros[RIGHT_SIDE]={}

MAX_INT=10000000

function GameManager:findNearestEnemy(hero)
	local battleSide=hero:getBattleSide()
	local minDis=MAX_INT
	local minDisEnemy=nil
	local enemySide=(battleSide==LEFT_SIDE and RIGHT_SIDE or LEFT_SIDE)
	assert(enemySide~=battleSide)
	for k,v in pairs(self.heros[enemySide]) do
		print("hero:getPosition()",hero:getPosition())
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
	print("nearestEnemy.id: ",nearestEnemy.id)
	print("nearestEnemy.pos: ",nearestEnemy:getPosition())
	print("dis= ",dis,"       ","attackRange= ",hero:getAttackRange())
	if dis<hero:getAttackRange() then
		return true
	else 
		return false
	end
end

function GameManager:onTouch(loc)

end

