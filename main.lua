require("functions")
require("Heap")
require("ConfigMap")
V=require("V")
Astar=require("Astar")


astar=Astar.new()
local result=astar:findPath(V.new(6,7),V.new(4,22)) --11,6

for i=#result,1,-1 do
	result[i].v:vprint()
end