function getLeftMost(P)
	ret = P[1]
	idx = 1
	for i = 2, #P do
		if P[i][1] < P[idx][1] then
			idx = i
		end
	end
	return idx
end


function love.load()
   local screen_width, screen_height = love.graphics.getDimensions()
   n = 50   -- how many points we want
   love.window.setTitle(string.format('Jarvis\' March with %d points', n))
   love.graphics.setPointSize(10)

   P = {}   -- table of points

   for i=1, n do   
      local x = love.math.random(5, screen_width-5)   -- generate random coordinates
      local y = love.math.random(5, screen_height-5)   
      P[i] = {x, y}   
   end
   v0 = getLeftMost(P)
   hull = {P[v0]}

   p = v0

   q = v0 % #P + 1
   r = 1

   running = true


end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      table.insert(P, {x, y})
	n = n + 1
	v0 = getLeftMost(P)
   	hull = {P[v0]}

   p = v0

   q = v0 % #P + 1
   r = 1
   
   love.window.setTitle(string.format('Jarvis\' March with %d points', n))
   running = true

   end
end


function cross(p, q, r)
	return (q[1] - p[1]) * (r[2] - p[2]) - (q[2] - p[2]) * (r[1] - p[1])
end


function d(p, q)
	return math.pow(math.pow(p[1] - q[1],2) + math.pow(p[2] - q[2],2), 1/2)
end

function love.update(dt)
	if running then
		if r >= #P then
			p = q
	   		q = p % #P + 1
			r = 1
			table.insert(hull, P[p])
			if p == v0 then
				running = false
			end
		end
	
		area = cross(P[p], P[q], P[r])
		if area > 0 or (area == 0 and d(P[p], P[r]) > d(P[p], P[q])) then
			q = r
		end
		r = r + 1
	end
end


function drawPointSet()
	love.graphics.setColor( 0.1, 0.1, 1, 100 )
	love.graphics.points(P)   -- draw each point
end

function drawHull()
	love.graphics.setColor( 1, 0.1, 0.1, 100 )
	love.graphics.points(hull)   -- draw leftmost point
	if #hull > 1 then
		for i = 1, #hull - 1 do
			love.graphics.line(hull[i][1], hull[i][2], hull[i+1][1], hull[i+1][2])
		end
	end
end

function drawLine()
	love.graphics.setColor( 0, 1, 0, 100 )
	love.graphics.line(P[p][1], P[p][2], P[q][1], P[q][2])
end


function love.draw()
	drawPointSet()
	drawHull()
	if running then
		drawLine()
	end
end
