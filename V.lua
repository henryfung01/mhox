local V=class("V")

local rows=ConfigMap.Height
local cols=ConfigMap.Width
local map=ConfigMap.data 

function V:ctor(x,y)
	self.x=x  --x row
	self.y=y  --y colb
end

function V:vprint()
	print(self.x,self.y) --xth row,yth col
end

function V:isSame(v)
	return self.x==v.x and self.y==v.y
end

function V:getCost(v)
	assert(math.abs(self.x-v.x)<=1 and math.abs(self.y-v.y)<=1)
	if self.x==v.x and self.y==v.y then
		return 0
	end
	if self.x~=v.x and self.y~=v.y then
		return 14
	end
	return 10
end

function V:getHeuristicValue(v)
	return 10*( math.abs(self.x-v.x)+math.abs(self.y-v.y) )
end

function V:getSuccessors()
	local vSet={}
	for r=self.x-1,self.x+1 do
		for c=self.y-1,self.y+1 do
			if (r~=self.x or c~=self.y) and r>1 and r<rows
				and c>1 and c<cols and 1==map[(r-1)*cols+c] then
				table.insert(vSet,V.new(r,c))
			end
		end
	end
	return vSet
end

function V.isWalkable(v)
	return 1==map[(v.x-1)*cols+v.y]
end

return V