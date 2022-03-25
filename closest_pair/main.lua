function printPointset(P)
        local s = ''
        for i=1, #P do
                s = string.format('%s{%d,%d}, ', s, P[i][1], P[i][2])
        end
        print(s)
end

function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function table.slice(tbl, first, last, step)
  local sliced = {}
  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end
  return sliced
end

function closestPair(X, Y)
	local n = #X
	if n == 2 then 
		return d(X[1], X[2]), X[1], X[2]
	elseif n == 3 then 
		d1 = d(X[1], X[2])
		d2 = d(X[2], X[3])
		d3 = d(X[1], X[3])
		min = math.min(d1, d2, d3)
		if min == d1 then
			return d1, X[1], X[2]
		elseif min == d2 then
			return d2, X[2], X[3]
		else
			return d3, X[1], X[3]
		end
	end

	piv = math.floor(n/2)
	local p = X[1]
	local q = X[2]
	local dl, pl, ql = closestPair(table.slice(X, 1, piv), Y)
	local dr, pr, qr = closestPair(table.slice(X, piv+1, n), Y)
	local delta = math.min(dl, dr)
	if delta == dl then
		p = pl
		q = ql
	else 
		p = pr
		q = qr
	end

	S = {} -- points in strip
	for i = 1, n do
		if Y[i][1] < X[piv][1] + delta and Y[i][1] > X[piv][1] + delta then
			table.insert(S, Y[i])
		end
	end

	for i = 1, #S do
		for j = 1, 7 do
			local delta_tmp = d(S[i], S[i+j])
			if delta_tmp < delta then
				 delta = delta_tmp
				 p = S[i]
				 q = S[i+j]
			end
		end
	end
	printPointset({p, q})
	return delta, p, q
end


function cp_wrapper()
	X = table.copy(P)
	Y = table.copy(P)
   table.sort(X, function (a,b) -- sort pointset by X and Y coordinate
      return (a[1] < b[1])      -- you could save time by only sorting in
    end)						-- Y and using the calculating the median as pivot
   table.sort(Y, function (a,b)
      return (a[2] < b[2])
    end)
	delta, p, q = closestPair(X, Y)
	print(delta)
	printPointset({p, q})
end


function love.load()
   local screen_width, screen_height = love.graphics.getDimensions()
   n = 5   -- how many points we want
   love.window.setTitle(string.format('closest pair of %d points', n))
   love.graphics.setPointSize(10)

   P = {}   -- table of points

   for i=1, n do   
      local x = love.math.random(5, screen_width-5)   -- generate random coordinates
      local y = love.math.random(5, screen_height-5)   
      P[i] = {x, y}   
   end
	
   cp_wrapper()
	
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then 
      table.insert(P, {x, y})
   	  love.window.setTitle(string.format('closest pair of %d points', n))
	  cp_wrapper()
   end
end


function d(p, q)
	return math.pow(math.pow(p[1] - q[1],2) + math.pow(p[2] - q[2],2), 1/2)
end

function drawPointSet()
	love.graphics.setColor( 0.1, 0.1, 1, 100 )
	love.graphics.points(P)   -- draw each point
end

function drawPoint(P)
	love.graphics.setColor( 1, 0.1, 0.1, 100 )
	love.graphics.points(P)   -- draw each point
end

function love.draw()
	drawPointSet(P)
	drawPoint({p, q})
end
