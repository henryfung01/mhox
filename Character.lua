local Character=class("Character",cc.Node)

local id=0 --for debug

local debug=false

function Character:ctor(armaturePath,armatureName,pos)
    id=id+1
    self.id=id              --for debug
    debug_print("new character id:  ",id)
    self.name=armatureName  --for debug
	self.actor=Actor.new(armaturePath,armatureName)
    --print("self.size: ",self:getContentSize().width,self:getContentSize().height)
    --print("self.actor.size: ",self.actor:getContentSize().width,self.actor:getContentSize().height)
	self.actor:getAnimation():play("run_up")
	self:addChild(self.actor)
	self:setPosition(pos[1],pos[2])
	self.speed=100
    self.eyeRange=400
    self.attackRange=200

    self.bt=HeroBT.new(self) --bt : behavior tree

    --nodeEx.lua中定义node:schedule(callback, delay)
    -- local delay = cc.DelayTime:create(GAMEFRAME*50) --2*GAMEFRAME
    -- local sequence = cc.Sequence:create(delay, cc.CallFunc:create(function() self:update() end ))
    -- local action = cc.RepeatForever:create(sequence)
    -- self:runAction(action)
end

function Character:findWayTo(des)  --连续多次点击屏幕会有问题，当des变化时怎么马上结束上一次run的还没完成的action(stopAction or stopAllActions)？？？或者不用runAction有更好的方式？？？
	--print("des: ",des.x,des.y)
	--print("self.pos: ",self:getPosition())
	local x1,y1=self:getPosition()
	local x2,y2=des.x,des.y
	local angle=math.atan2(y2-y1,x2-x1) --顺序别搞错了，(deltaY,deltaX)
	local dx,dy=y2-y1,x2-x1
	local dis=math.sqrt(dx*dx+dy*dy)
	if dis<1 then
		return 
	end
	debug_print("angle: ",angle)
	self:setOrient(angle*180/math.pi)
	debug_print("angle_: ",angle*180/math.pi)
	debug_print("self._faceDir: ",self._faceDir)

	local index= self._faceDir<=5 and self._faceDir or self._faceDir-4 
	debug_print("index= ",index)
	self.actor:getAnimation():play( CharacterDefine.ANIS_RUN[index] )

	--self:stopAllActions()	

	local moveTo=cc.MoveTo:create(dis/self.speed,des)
	local func=function() debug_print("movetoPos",self:getPosition()) end
	self:runAction(cc.Sequence:create(moveTo,cc.CallFunc:create(func)))  --最好不用runAction
end


function Character:setOrient(degree)
    local dir=CharacterDefine.FACE_DIR.DIR_RIGHT
    local rotation=0

    if degree>-22.5 and degree<=22.5 then
        dir=CharacterDefine.FACE_DIR.DIR_RIGHT
        rotation=-degree

    elseif degree>22.5 and degree<=67.5 then
        dir=CharacterDefine.FACE_DIR.DIR_RIGHT_UP
        rotation=45-degree

    elseif degree>67.5 and degree<=112.5 then
        dir=CharacterDefine.FACE_DIR.DIR_UP
        rotation=90-degree

    elseif degree>112.5 and degree<=157.5 then
        dir=CharacterDefine.FACE_DIR.DIR_LEFT_UP
        rotation=135-degree

    elseif (degree>157.5 and degree<=180) or degree<=-157.5 then
        dir=CharacterDefine.FACE_DIR.DIR_LEFT
        if degree>0 then
            rotation=180-degree
        elseif degree<0 then
            rotation=-(180+degree)
        end

    elseif degree>-157.5 and degree<=-112.5 then
        dir=CharacterDefine.FACE_DIR.DIR_LEFT_DOWN
        rotation=-(135+degree)

    elseif degree>-112.5 and degree<=-67.5 then
        dir=CharacterDefine.FACE_DIR.DIR_DOWN
        rotation=-(90+degree)

    elseif degree>-67.5 and degree<=-22.5 then
        dir=CharacterDefine.FACE_DIR.DIR_RIGHT_DOWN
        rotation=-(45+degree)
    end

    self._faceDegree=degree
    self._faceRotation=rotation
    self._faceDir=dir

    if dir <= 5 then
         self.actor:setScaleX(1)
    else
         self.actor:setScaleX(-1)
    end

    self:setRotation(self._faceRotation)

end


function Character:update( )
    self.bt.root:tick()
end

function Character:wander()

    if nil==self.wanderPos then
        self.wanderPos=Util.genRandomWalkablePos()
    end
    if Util.getDistance(self.wanderPos,cc.p(self:getPosition()))<self.speed then
        self.wanderPos=nil
        return BH_SUCCESS
    else
        self:step(self.wanderPos)
        return BH_RUNNING
    end
   
end

function Character:step(targetPos)
    self:setPosition(Util.step(cc.p(self:getPosition()),targetPos,self.speed))
end

function Character:chaseEnmey()
    local targetPos=cc.p(self.nearestEnemy:getPosition())
    self:step(targetPos)
end

function Character:getAnimIndex(des)
    local x1,y1=self:getPosition()
    local x2,y2=des.x,des.y
    local angle=math.atan2(y2-y1,x2-x1) --顺序别搞错了，(deltaY,deltaX)
    local dx,dy=y2-y1,x2-x1
    local dis=math.sqrt(dx*dx+dy*dy)
    if dis<1 then
        return 
    end
    self:setOrient(angle*180/math.pi)

    local index= self._faceDir<=5 and self._faceDir or self._faceDir-4 
    return index
end

function Character:attack(enemy)
    local targetPoint=cc.p(enemy:getPosition())
    local index=self:getAnimIndex(targetPoint)
    debug_print("animation index: ",index)
    debug_print("attack animation name: ",CharacterDefine.ANIS_ATK[index])
    self.actor:getAnimation():play(CharacterDefine.ANIS_ATK[index])
    if enemy:isDead() and not self:isDead() then
        return BH_SUCCESS
    else
        return BH_FAILURE
    end
end

function Character:hasEnemyInVision()
    return GameManager:hasEnemyInVision(self)
end

function Character:hasEnemyInAttackRange()
    return GameManager:hasEnemyInAttackRange(self)
end

function Character:findNearestEnemy()
    return GameManager:findNearestEnemy(self)
end


function Character:chaseEnemy()
    local enemy=self:findNearestEnemy()
    local epos=cc.p(enemy:getPosition())
    local oriPos=cc.p(self:getPosition())
    local dis=Util.getDistance(epos,oriPos)
    if dis<=self.attackRange then
        return BH_SUCCESS
    elseif dis>self.eyeRange then
        return BH_FAILURE
    end
    pos= Util.step(oriPos,epos ,self.speed)
    self:setPosition(pos.x,pos.y)
    return BH_RUNNING
end

function Character:getBattleSide()
    return self.battleSide
end

function Character:getAttackRange()
    return self.attackRange
end

function Character:getEyeRange()
    return self.eyeRange
end

function Character:isCommanded()
    return nil~=self.cmd
end

function Character:isInCommand(cmdType)
    return self.cmd.type==cmdType
end

function Character:superattack()
    if self:hasEnemyInAttackRange() then
       -- self:播放大招动画--需要自己和特效都需要面向nearestEnemy
       print("hero ",self.id," 放大招")
       return BH_SUCCESS
    else
        return BH_FAILURE
    end
end

function Character:playAnim(anim)
    self.actor:getAnimation():play(anim)
end

function Character:attackAsCommanded()
    local targetPoint=cc.p(self.cmd.param:getPosition())
    local pos=cc.p(self:getPosition())
    local dis=Util.getDistance(targetPoint,pos)
    local index=self:getAnimIndex(targetPoint)
    if dis<=self.attackRange then
        self:playAnim(CharacterDefine.ANIS_ATK[index])
        return self:attack(self.cmd.param)
    else
        self:playAnim(CharacterDefine.ANIS_RUN[index])
        self:step(targetPoint)
        return BH_RUNNING
    end
end

function  Character:moveAsCommanded( )
    print("function  Character:moveAsCommanded( )")
    print("function  Character:moveAsCommanded( )")
    print("function  Character:moveAsCommanded( )")
    print("function  Character:moveAsCommanded( )")
    print("function  Character:moveAsCommanded( )")
    local targetPoint=cc.p(self.cmd.param)
    local pos=cc.p(self:getPosition())
    local dis=Util.getDistance(targetPoint,pos)
    local index=self:getAnimIndex(targetPoint)
    self:playAnim(CharacterDefine.ANIS_RUN[index])
    if dis<self.speed then
        return BH_SUCCESS
    else
        self:step(targetPoint)
        return BH_RUNNING
    end
end

function Character:isDead( )
    return false
end

function  Character:clearCommand(  )
    self.cmd=nil
end

function Character:isHuman()
    return true
end

return Character