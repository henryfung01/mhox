
local HeroBT=class("HeroBT")                             --许多node都需要获取外界（hero）数据，也会改变外界数据



function HeroBT:createBT()
	local operateCond=Condition.new("")

	local atkCond=Condition.new("atkCond",function() return self.owner:hasEnemyInAttackRange() end)
	
	local atkAction=Behavior.new("atkAction")	
	atkAction.update=function(atkAction)  return self.owner:attack(self.owner.nearestEnemy)   end

	local atkSeq=BehaviorTree.createComp("atkSeq","Sequence",atkCond,atkAction)


	local chaseCond=Condition.new("chaseCond",function() return self.owner:hasEnemyInVision() end)
	local chaseAction=Behavior.new("chaseAction")
	chaseAction.update=function(chaseAction)  return self.owner:chaseEnemy()  end
	local chaseSeq=BehaviorTree.createComp("chaseSeq","Sequence",chaseCond,chaseAction)

	local wanderCond=Condition.new("wanderCond",function() return true end)
	local wanderAction=Behavior.new("wanderAction")
	wanderAction.update=function(wanderAction)  return self.owner:wander() end
	local wanderSeq=BehaviorTree.createComp("wanderSeq","Sequence",wanderCond,wanderAction)

	local aiSelector=BehaviorTree.createComp("aiSelector","Selector",atkSeq,chaseSeq,wanderSeq)
	aiSelector.preCondition=function(aiSelector) return not self.owner:isCommanded()  end

-------------------------------------------------

	local superattackAction=Behavior.new("superattackAction")
	superattackAction.preCondition=function(superattackAction)  return self.owner:isInCommand(CMD_SUPERATTACK) end
	superattackAction:setUpdateFunc(function(superattackAction) return self.owner:superattack()  end)

	local chaseattackAction=Behavior.new("chaseattackAction")
	chaseattackAction.preCondition=function(chaseattackAction) return self.owner:isInCommand(CMD_ATTACK)  end
	chaseattackAction:setUpdateFunc(function(chaseattackAction)  return self.owner:attackAsCommanded()  end)

	local movetoAction=Behavior.new("movetoAction")
	movetoAction.preCondition=function(movetoAction) 
	print("movetoAction.preCondition movetoAction.preCondition movetoAction.preCondition")
	print("self.owner.cmd.type: ",self.owner.cmd.type)
print("self.owner.cmd.type: ",self.owner.cmd.type)
print("self.owner.cmd.type: ",self.owner.cmd.type)
print("self.owner.cmd.type: ",self.owner.cmd.type)
print("self.owner.cmd.type: ",self.owner.cmd.type)
	return self.owner:isInCommand(CMD_MOVETO) end
	movetoAction:setUpdateFunc(function(movetoAction) return self.owner:moveAsCommanded() end)
	
	local cmdSelector=BehaviorTree.createComp("cmdSelector","Selector",superattackAction,chaseattackAction,movetoAction)--执行完后将owner.cmd赋值nil
	cmdSelector.preCondition=function(cmdSelector)  return self.owner:isCommanded() end
	cmdSelector.onTerminate=function(cmdSelector,status)  print("cmdSelector.onTerminate cmdSelector.onTerminate cmdSelector.onTerminate cmdSelector.onTerminate",status) self.owner:clearCommand() end


	self.root=BehaviorTree.createComp("rootSelector","Selector",cmdSelector,aiSelector)
end



function HeroBT:ctor(owner)
	self.owner=owner
	self:createBT()
end

function HeroBT:update()
	
	self.root:tick()
end

return HeroBT