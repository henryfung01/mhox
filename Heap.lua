
function adjustdown_heap(vec,s,m) --小根堆
	local i=2*s
	local temp=vec[s]
	while i<=m do
		if i<m then
			i= vec[i+1]<vec[i] and i+1 or i
		end
		if temp>vec[i] then
			vec[s]=vec[i]
			s=i
			i=2*i
		else
			break
		end
	end
	vec[s]=temp
end

function adjustup_heap(vec,s,m) --小根堆
	m=m or 1
	local i=math.floor(s/2)
	local temp=vec[s]
	while i>=m do
		print("temp.f= ",temp.f)
		if temp<vec[i] then --vec[i]>temp
			vec[s]=vec[i]
			s=i
			i=math.floor(i/2)
		else
			break
		end
	end
	vec[s]=temp
end

function adjust_heap(vec,s)  --vec[s]值大小变化后调用
	local i=math.floor(s/2)
	if i<1 then
		adjustdown_heap(vec,s,#vec)
		return
	end
	if vec[s]>vec[i] then
		adjustdown_heap(vec,s,#vec)
	elseif(vec[s]<vec[i]) then
		adjustup_heap(vec,s,1)
	end
end

function make_heap(vec)
	local sz=#vec
	for i=math.floor(sz/2),1,-1 do
		adjustdown_heap(vec,i,sz)
	end
end

function push_heap(vec) --先vec[#vec+1]=value,再push_heap(vec)
	adjustup_heap(vec,#vec,1)
end



function pop_heap(vec)  --先pop_heap(vec),再vec[#vec]=nil
	local temp=vec[#vec]
	vec[#vec]=vec[1]
	vec[1]=temp
	adjustdown_heap(vec,1,#vec-1)
end

