
local HeroBT=class("HeroBT")                             --许多node都需要获取外界（hero）数据，也会改变外界数据



function HeroBT:createBT()

	t1=class("t1")
	function t1:ctor(name)
		self.name=name
	end

	t2=class("t2",t1)
	function t2:ctor(name)
		if self.super==t2 then
			t2.super.ctor(self,name)
		else
			self.super.ctor(self,name) 
		end
	end

	t3=class("t3",t2)
	function t3:ctor(name)
		self.super.ctor(self,name)
	end

	_t3=t3.new("t3")

	local atkCond=Condition.new("atkCond",function() return self.owner:hasEnemyInAttackRange() end)
	
	local atkAction=Behavior.new("atkAction")	
	atkAction.update=function(atkAction)  self.owner:attack(cc.p(self.owner.nearestEnemy:getPosition())) return BH_SUCCESS end

	local atkSeq=BehaviorTree.createComp("atkSeq","Sequence",atkCond,atkAction)


	local chaseCond=Condition.new("chaseCond",function() return self.owner:hasEnemyInVision() end)
	local chaseAction=Behavior.new("chaseAction")
	chaseAction.update=function(chaseAction)  self.owner:chaseEnemy() return BH_SUCCESS end
	local chaseSeq=BehaviorTree.createComp("chaseSeq","Sequence",chaseCond,chaseAction)

	local wanderCond=Condition.new("wanderCond",function() return true end)
	local wanderAction=Behavior.new("wanderAction")
	wanderAction.update=function(wanderAction)  self.owner:wander() return BH_SUCCESS end
	local wanderSeq=BehaviorTree.createComp("wanderSeq","Sequence",wanderCond,wanderAction)

	self.root=BehaviorTree.createComp("rootSelector","Selector",atkSeq,chaseSeq,wanderSeq)

	
end



function HeroBT:ctor(owner)
	self.owner=owner
	self:createBT()
end

function HeroBT:update()
	
	self.root:tick()
end

return HeroBT