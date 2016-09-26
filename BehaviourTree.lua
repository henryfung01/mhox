 BH_INVALID=0
 BH_SUCCESS=1
 BH_FAILURE=2
 BH_RUNNING=3
 BH_ABORTED=4

 Behavior=class("Behavior")

local debug=false

function debug_print(...)
	if debug then
		print(...)
	end
end

 function Behavior:ctor(name)
 	self.status=BH_INVALID
 	self.name=name
 	self.type="Behavior"
 end

 function Behavior:update()
 	--debug_print("should implement update")
 	if not self:preCondition() then
 		print(self.name,"  preCondition failure")
 		print(self.name,"  preCondition failure")
		print(self.name,"  preCondition failure")
 		print(self.name,"  preCondition failure")
 		print(self.name,"  preCondition failure")
		return BH_FAILURE
	end
	if self._updateFunc then
		return self:_updateFunc()
	end
 end

 function Behavior:setUpdateFunc(func)
 	self._updateFunc=func
 end

 function Behavior:onInitialize()

 end

 function Behavior:onTerminate()

 end

 function Behavior:preCondition() 
 	return true
 end

 function Behavior:tick()
 	print("Behavior:tick() self.name: ",self.name)
 	print("Behavior:tick() self.name: ",self.name)
 	print("Behavior:tick() self.name: ",self.name)
 	if self.status~=BH_RUNNING then 
 		self:onInitialize()
 	end
 	self.status=self:update()
 	if self.name=="movetoAction" then
 		print("movetoAction return status: ",self.status)
 		print("movetoAction return status: ",self.status)

	print("movetoAction return status: ",self.status)
	print("movetoAction return status: ",self.status)
print("movetoAction return status: ",self.status)

	print("movetoAction return status: ",self.status)

 	end
 	if self.status~=BH_FAILURE then
 		print("self.status~=BH_FAILURE self.name: ",self.name)
 		print("self.status~=BH_FAILURE self.name: ",self.name)
 		print("self.status~=BH_FAILURE self.name: ",self.name)
 	end
 	assert(self.status~=nil)
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

 Condition=class("Condition",Behavior)

 function Condition:ctor(name,func)
 	self.super.ctor(self,name)
 	self.func=func
 	self.type="Condition"
 end

 function Condition:update()
 	if self.func() then
 		return BH_SUCCESS
 	else
 		return BH_FAILURE
 	end
 end


Decorator=class("Decorator",Behavior)

function Decorator:ctor(name,child)
	self.super.ctor(self,name)
	self.child=child
	self.type="Decorator"
end

Repeat=class("Repeat",Decorator)

function Repeat:ctor(name,child)
	self.super.ctor(self,name,child)
	self.limit=0
	self.count=0
	self.type="Repeat"
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

function Composite:ctor(name)
	if self.super==Composite then
		Composite.super.ctor(self,name)
	else
		self.super.ctor(self,name) 
	end
	self.children={}
	self.type="Composite"
end

function Composite:addChild(child)
	--print("child.name ",child.name)
	--print("self.name ",self.name)
	assert(child.name~=self.name)
	assert(child~=self)
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

function Sequence:ctor(name)
	self.super.ctor(self,name)
	self.curChildIndex=0
	self.type="Sequence"
end

function Sequence:onInitialize()
	self.curChildIndex=1
end

function Sequence:update()
	if not self:preCondition() then
		return BH_FAILURE
	end
	while true do
		local curChild=self.children[self.curChildIndex]
		
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

function Selector:ctor(name)
	self.super.ctor(self,name)
	self.curChildIndex=0
	self.type="Selector"
end

function Selector:onInitialize()
	self.curChildIndex=1
end

function Selector:update()
	if not self:preCondition() then
		print("BH_FAILURE: ",self.name)
		print("BH_FAILURE: ",self.name)
		print("BH_FAILURE: ",self.name)
		print("BH_FAILURE: ",self.name)
		print("BH_FAILURE: ",self.name)
		print("BH_FAILURE: ",self.name)
		return BH_FAILURE
	end

	while true do
		--print("#self.children: ",#self.children)
		--print(self.curChildIndex)
		local curChild=self.children[self.curChildIndex]
		local status=curChild:tick()
		if status~=BH_FAILURE then
			if self.name=="cmdSelector" then
		print("curChild.name: ",curChild.name)
		print("status status status status: ",status)
		print("curChild.name: ",curChild.name)
		print("status status status status: ",status)
		print("curChild.name: ",curChild.name)
		print("status status status status: ",status)
		print("curChild.name: ",curChild.name)
		print("status status status status: ",status)
		print("curChild.name: ",curChild.name)
		print("status status status status: ",status)
		print("curChild.name: ",curChild.name)
		print("status status status status: ",status)
			end	
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

function Parallel:ctor(name,sucPolicy,failPolicy)
	self.super.ctor(self,name)
	self.sucPolicy=sucPolicy or Policy_RequireAll
	self.failPolicy=failPolicy or Policy_RequireAll
	self.type="Parallel"
end

function Parallel:update()
	local sucCount=0
	local failCount=0
	for k,v in pairs(self.children) do
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


BehaviorTree={}
function BehaviorTree.createComp(name,type,...)
	children={...}

	local par
	if type=="Sequence" then
		par=Sequence.new(name)
	elseif type=="Selector" then
		par=Selector.new(name)
	elseif type=="Parallel" then
		par=Parallel.new(name)
	else
		print("ERRORRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR")
	end

	for k,v in pairs(children) do
		par:addChild(v)
	end
	return par
end


function BehaviorTree.printTree(root) --bfs
	BehaviorTree.printChild(root)
	for k,v in pairs(root.children) do  --temp, should use bfs algorithm
		BehaviorTree.printChild(v)
	end
end

function BehaviorTree.printChild(root) 
	print("self.name= ",root.name)
	print(root.name..".child.name: ")
	for k,v in pairs(root.children) do
		print(v.name)
	end
	print("child end")
end




