extends Node

func is_inside(vertices, cx, cy, r):
	return poly_circle(vertices, cx, cy, r)

# referenced from: http://jeffreythompson.org/collision-detection/poly-circle.php

func poly_circle(vertices, cx, cy, r):
	# go through each of the vertices, plus
	# the next vertex in the list
	var next = 0
	for current in range(vertices.size()):
		# get next vertex in list
		# if we've hit the end, wrap around to 0
		next = current+1
		if (next == vertices.size()): next = 0
		
		# get the PVectors at our current position
		# this makes our if statement a little cleaner
		var vc = vertices[current]    # c for "current"
		var vn = vertices[next]       # n for "next"
		
		# check for collision between the circle and
		# a line formed between the two vertices
		var collision = line_circle(vc.x,vc.y, vn.x,vn.y, cx,cy,r)
		if (collision): return false
	
	if (polygon_point(vertices, cx,cy)): return true
	
	# otherwise, after all that, return false
	return false

func line_circle(x1, y1, x2, y2, cx, cy, r):
	# is either end INSIDE the circle?
	# if so, return true immediately
	var inside1 = point_circle(x1,y1, cx,cy,r)
	var inside2 = point_circle(x2,y2, cx,cy,r)
	if (inside1 || inside2): return true
	
	# get length of the line
	var distX = x1 - x2
	var distY = y1 - y2
	var length = sqrt((distX*distX) + (distY*distY))
	
	# get dot product of the line and circle
	var dot = (((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1))) / pow(length,2)
	
	# find the closest point on the line
	var closestX = x1 + (dot * (x2-x1))
	var closestY = y1 + (dot * (y2-y1))
	
	# is this point actually on the line segment?
	# if so keep going, but if not, return false
	var onSegment = line_point(x1,y1,x2,y2, closestX,closestY)
	if (!onSegment): return false
	
	# get distance to closest point
	distX = closestX - cx
	distY = closestY - cy
	var distance = sqrt( (distX*distX) + (distY*distY))
	
	# is the circle on the line?
	if (distance <= r):
		return true
	
	return false

func line_point(x1, y1, x2, y2, px, py):

	# get distance from the point to the two ends of the line
	var d1 = dist(px,py, x1,y1)
	var d2 = dist(px,py, x2,y2)

	# get the length of the line
	var lineLen = dist(x1,y1, x2,y2)

	# since vars are so minutely accurate, add
	# a little buffer zone that will give collision
	var buffer = 0.1    # higher # = less accurate

	# if the two distances are equal to the line's
	# length, the point is on the line!
	# note we use the buffer here to give a range, rather
	# than one #
	if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer):
		return true
	
	return false

func point_circle(px, py, cx, cy, r):
	
	# get distance between the point and circle's center
	# using the Pythagorean Theorem
	var distX = px - cx
	var distY = py - cy
	var distance = sqrt( (distX*distX) + (distY*distY) )

	# if the distance is less than the circle's 
	# radius the point is inside!
	if (distance <= r):
		return true
	
	return false

func polygon_point(vertices, px, py):
	var collision = false
	
	# go through each of the vertices, plus the next
	# vertex in the list
	var next = 0
	for current in range(vertices.size()):
		# get next vertex in list
		# if we've hit the end, wrap around to 0
		next = current+1
		if (next == vertices.size()): next = 0
		
		# get the PVectors at our current position
		# this makes our if statement a little cleaner
		var vc = vertices[current]    # c for "current"
		var vn = vertices[next]       # n for "next"
		
		# compare position, flip 'collision' variable
		# back and forth
		if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py))
				&& (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)):
			collision = !collision
	
	return collision

func dist(x1, y1, x2, y2):
	return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
