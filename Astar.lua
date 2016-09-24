
local ND={}
ND.__le=function(a,b)
	return a.f<=b.f
end

ND.__lt=function(a,b)
	return a<=b and not (b<=a)
end

ND.__eq=function(a,b)
	return a<=b and b<=a
end

local Astar=class("Astar")

local STATE_FAIL=0
local STATE_RUN=1
local STATE_SUC=2
local bDebug=true

function ND:ctor(v)
	self.v=v
	self.g=0
	self.h=0
	self.f=0
	self.parent=nil
end

function ND.new(v)
	local o={}
	ND.__index=ND
	setmetatable(o,ND)
	o.v=v
	o.g=0
	o.h=0
	o.f=0
	o.parent=nil
	return o
end

function Astar:ctor()
	self.start=nil
	self.goal=nil
	self.openList={}
	self.closedList={}
	self.steps=0
end

function Astar:setStartAndGoal(start,goal)
	assert(nil==self.start and nil==self.goal)
	self.start=ND.new(start)
	self.start.g=0
	self.start.h=self.start.v:getHeuristicValue(goal)
	self.start.f=self.start.g+self.start.h
	self.start.parent=nil
	self.goal=ND.new(goal)
	table.insert(self.openList,self.start)
end


function Astar:step( )
	self.steps=self.steps+1
	if nil==next(self.openList) then
		print("failed to find path")
		return STATE_FAIL
	end
	local pnd=self.openList[1]
	pop_heap(self.openList)
	self.openList[#self.openList]=nil
	
	if bDebug then
		print("\n step "..self.steps.." :")
		print(pnd.v.x,pnd.v.y)
	end
	
	if pnd.v:isSame(self.goal.v) then
		self.goal.parent=pnd.parent
		self.goal.g=pnd.g
		self.goal.h=pnd.h
		self.goal.f=pnd.f
		table.insert(self.closedList,pnd)
		return STATE_SUC
	end

	local successor=pnd.v:getSuccessors()

	if bDebug then
		print("successor num: ",#successor)
	end
	
	for k,v in ipairs(successor) do
		local inOpenList=false
		for ko,ndo in ipairs(self.openList) do
			if ndo.v:isSame(v) then
				local newg=pnd.g+pnd.v:getCost(ndo.v)
				if ndo.g>newg then
					ndo.g=newg
					ndo.f=ndo.g+ndo.h
					ndo.parent=pnd
					adjustup_heap(self.openList,ko,1)
				end
				inOpenList=true
			end
		end
		
		if not inOpenList then
			local nd=ND.new(v)
			nd.parent=pnd
			nd.g=pnd.g+pnd.v:getCost(nd.v)
			nd.h=nd.v:getHeuristicValue(self.goal.v)
			nd.f=nd.g+nd.h
			table.insert(self.openList,nd)
			push_heap(self.openList)
		end
	end
	
	print("len of self.openList: ",#self.openList)
	
	table.insert(self.closedList,pnd)
	return STATE_RUN
end

function Astar:findPath(start,goal)
	assert(V.isWalkable(start) and V.isWalkable(goal),"start point or goal point not walkable")
	local result={}
	self:setStartAndGoal(start,goal)
	local state=STATE_RUN
	while(STATE_RUN==state) do
		state=self:step()
	end
	local nd=self.goal
	while(nd and nd.parent) do   --去掉nd.parent这个条件可以把起点加入result
		table.insert(result,nd) --reversed
		nd=nd.parent
	end

	self.openList={}
	self.closedList={}
	print("steps= ",self.steps)
	return result
end


--function Astar:printResult()
--	for i=#result,1 do
--		self.result[i].v:vprint()
--	end
--end

return Astar