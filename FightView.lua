local FightView=class("FightView",cc.Layer)

local armaturePathV={
"D100001",
"D100002",
"D100004",
"D100005",
"D110002",
"D110003"
}

local posV={
{300,300},
{350,300},
{400,300},
{1400,300},
{1500,300},
{1600,300}
}


function FightView:ctor()
	local bg=ccui.ImageView:create()
	bg:loadTexture("")
	self:addChild(bg,-20)
	self.heros={}
	self.enemies={}
	for i=1,3 do
		self.heros[i]=Character.new(armaturePathV[i].."/",armaturePathV[i],posV[i])
		self:addChild(self.heros[i])
		self.heros[i].battleSide=LEFT_SIDE
		table.insert(GameManager.heros[LEFT_SIDE],self.heros[i])
	end

	for i=1,3 do
		self.enemies[i]=Character.new(armaturePathV[i+3].."/",armaturePathV[i+3],posV[i+3])
		self:addChild(self.enemies[i])
		self.enemies[i].battleSide=RIGHT_SIDE
		table.insert(GameManager.heros[RIGHT_SIDE],self.enemies[i])
	end
	drawMapGrid(self)
	self:registerTouchListener()

	self.heros[1]:setPosition(900,500)

	-- self.heros[1].bt=HeroBT.new(self.heros[1]) --bt : behavior tree
 --    local delay = cc.DelayTime:create(GAMEFRAME*50) --2*GAMEFRAME
 --    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(function() self.heros[1]:update() end ))
 --    local action = cc.RepeatForever:create(sequence)
 --    self.heros[1]:runAction(action)
end

function FightView:registerTouchListener()
	self.moveSpeed=0.1

	--print("director:getProjection(): ",director:getProjection())

	print("winsize:",director:getWinSize().width,director:getWinSize().height)

	local function onTouchBegan(touch,event)
		self.lastPos=touch:getLocation()
		self.bMoved=false
		local scene=director:getRunningScene()
		local cam=scene:getDefaultCamera()
		local x,y=cam:getPosition()
		print("began camPos ",x,y)
		return true
	end

	local function onTouchMoved(touch,event)
		self.bMoved=true
		local loc=touch:getLocation()
		local offx=loc.x-self.lastPos.x
		local offy=loc.y-self.lastPos.y
		self.lastPos=loc
		local scene=director:getRunningScene()
		local cam=scene:getDefaultCamera()
		local x,y=cam:getPosition()
		cam:setPosition(x-offx,y-offy)
		print("onTouchMoved pos: ",loc.x,loc.y)
	end

	local function onTouchEnded(touch,event)
		local loc=touch:getLocation()
		print("onTouchEnded pos: ",loc.x,loc.y)
		local scene=director:getRunningScene()
		local camX,camY=scene:getDefaultCamera():getPosition()
		print("end cam pos",camX,camY)
		local ws=director:getWinSize()
		local des=cc.p(loc.x+camX-ws.width/2,loc.y+camY-ws.height/2)
		--print("des ",des.x,des.y)
		--print("self.heros[1].pos: ",self.heros[1]:getPosition())
		if not self.bMoved then
			GameManager:onTouch(loc)
		end
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return FightView