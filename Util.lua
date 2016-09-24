Util={}

function Util.getDistance(p1,p2)
	local dx=p1.x-p2.x
	local dy=p1.y-p2.y
	return math.sqrt(dx*dx+dy*dy)
end

function Util.drawLine(p1,p2,color)
	local color=color or cc.c4f(0,1,1,1)
	if nil==Util.drawNode or tolua.isnull(Util.drawNode) then
		Util.drawNode=cc.DrawNode:create()
		local curScene=cc.Director:getInstance():getRunningScene()
		curScene:addChild(Util.drawNode,10)
	end
	Util.drawNode:drawLine(p1,p2,color)
end

function Util.step(oriPos,desPos ,speed) --bad implementation???
	Util.drawLine(oriPos,desPos)
 	local dx=desPos.x-oriPos.x
 	local dy=desPos.y-oriPos.y
 	local deg=math.atan2(dy,dx)

 	local nextPos={}
 	nextPos.x=oriPos.x+speed*math.cos(deg)
 	nextPos.y=oriPos.y+speed*math.sin(deg)
 	return nextPos
end

function Util.getGridRowCol(gridPos)
	local row=math.floor(gridPos/ConfigMap.Width) 
	local col=gridPos-row*ConfigMap.Width
	return row,col
end

function Util.gridToPos(gridPos)
	local row,col=Util.getGridRowCol(gridPos)
	local x=(col-0.5)*ConfigMap.mapGridW
	local y=(ConfigMap.Height-row+0.5)*ConfigMap.mapGridH
	return cc.p(x,y)
end

function Util.genRandomWalkablePos()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local gridPos
    while true do 
        gridPos=math.random(ConfigMap.Height*ConfigMap.Width)
        if 1==ConfigMap.data[gridPos] then
            break
        end
    end
    return Util.gridToPos(gridPos)
end

