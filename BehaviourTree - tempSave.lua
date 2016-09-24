 local BH_INVALID=0
 local BH_SUCCESS=1
 local BH_FAILURE=2
 local BH_RUNNING=3
 local BH_ABORTED=4

 Behavior=class("Behavior")

 function Behavior:ctor()
 	self.status=BH_INVALID
 end

 function Behavior:update()
 	print("should implement update")
 end

 function Behavior:onInitialize()

 end

 function Behavior:onTerminate()

 end

 function Behavior:tick()
 	if self.status~=BH_INVALID then 
 		self:onInitialize()
 	end
 	self.status=self:update()
 	if self.status~=BH_RUNNING then
 		self:onTerminate(self.status)
 	end
 	return self.status
 end

 function Behavior:reset()
 	self.status=BH_INVALID
 end

 function Behavior:abort()
 	self:onTerminate(BH_ABORTED)
 	status=BH_ABORTED
 end

 function Behavior:isTerminated()
 	return status == BH_SUCCESS or status == BH_FAILURE
 end

 function Behavior:isRunning()
 	return self.status==BH_RUNNING
 end

 function Behavior:getStatus()
 	return self.status
 end


Decorator=class("Decorator",Behavior)

function Decorator:ctor(child)
	self.child=child
end

Repeat=class("Repeat",Decorator)

function Repeat:ctor(child)
	self.super:ctor(child)
	self.limit=0
	self.count=0
end

function Repeat:setCount(count)
	self.limit=count
end

function Repeat:onInitialize()
	self.limit=0
end

function Repeat:update()
	while true do
		self.child:tick()
		if self.child:getStatus()==BH_RUNNING then
			break --break应该改为return BH_RUNNING ？？？
		end
		if self.child:getStatus()==BH_FAILURE then
			return BH_FAILURE
		end
		self.count=self.count+1
		if self.count==self.limit then
			return BH_SUCCESS
		end
		self.child:reset()
	end
	return BH_INVALID
end

Composite=class("Composite",Behavior)

function Composite:ctor()
	self.children={}
end

function Composite:addChild(child)
	table.insert(self.children,child)
end

function Composite:removeChildByIndex(index)
	local cn=#self.children
	assert(index>=1 and index<=cn)
	for i=index+1,cn do
		self.children[i-1]=self.children[i]
	end
	self.children[cn]=nil
end

function Composite:removeChild(child)
	local rmIndex=0
	for k,v in pairs(self.children) do
		if v==child then
			rmIndex=k
			break
		end
	end
	if 0==rmIndex then
		print("child to be removed is not contained in the table")
	else
		removeChildByIndex(rmIndex)
	end
end

function Composite:clearChildren()
	self.children={}
end

Sequence=class("Sequence",Composite)

function Sequence:ctor()
	self.super:ctor()
	self.curChildIndex=0
end

function Sequence:onInitialize()
	self.curChildIndex=1
end

function Sequence:update()
	while true do
		local curChild=self.children[curChildIndex]
		local status=curChild:tick()
		if status~=BH_SUCCESS then
			return status
		end
		self.curChildIndex=self.curChildIndex+1
		if self.curChildIndex > #self.children then
			return BH_SUCCESS
		end
	end
end


Selector=class("Selector",Composite)

function Selector:ctor()
	self.super:ctor()
	self.curChildIndex=0
end

function Selector:onInitialize()
	self.curChildIndex=1
end

function Selector:update()
	while true do
		local curChild=self.children[curChildIndex]
		local status=curChild:tick()
		if status~=BH_FAILURE then
			return status
		end
		self.curChildIndex=self.curChildIndex+1
		if self.curChildIndex > #self.children then
			return BH_FAILURE
		end
	end
end


Parallel=class("Parallel",Composite)


Policy_RequireOne=1
Policy_RequireAll=2

function Parallel:ctor(sucPolicy,failPolicy)
	self.sucPolicy=sucPolicy or Policy_RequireAll
	self.failPolicy=failPolicy or Policy_RequireAll
end

function Parallel:update()
	local sucCount=0
	local failCount=0
	for k,v in pairs(self.children)
		if not v:isTerminated() then
			v:tick()
		end
		if v:getStatus()==BH_SUCCESS then
			sucCount=sucCount+1
			if self.sucPolicy==Policy_RequireOne then
				return BH_SUCCESS
			end
		elseif status==BH_FAILURE then
			failCount=failCount+1
			if self.failPolicy==Policy_RequireOne then
				return BH_FAILURE
			end
		end
	end
	local cn=#self.children
	if self.failPolicy==Policy_RequireAll and failCount==cn then
		return BH_FAILURE
	end
	if self.sucPolicy==Policy_RequireAll and sucCount==cn then
		return BH_SUCCESS
	end
end







