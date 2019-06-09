pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
center_x, center_y = 64, 64
h = 64
vectors = {}
walls = {
{
 wa_x=50,
 wa_y=20,
 wb_x=50,
 wb_y=80,
 c = 9
},
{
 wa_x=50,
 wa_y=20,
 wb_x=80,
 wb_y=20,
 c=13
},
{
 wa_x=80,
 wa_y=10,
 wb_x=100,
 wb_y=10,
 c=12
},
{
 wa_x=50,
 wa_y=80,
 wb_x=20,
 wb_y=80,
 c=14
},
}

c_x, c_y = 64, 64

function m_vector(x, y)
	local x = x - c_x
	local y = y - c_y
	local c = x^2 + y^2
	return abs(sqrt(c))
end

for i=0,1,1/360 do
x,y = cos(i)*h, sin(i)*h
add(vectors,
    {x=x, y=y,
    bx=x+c_x,
    by=y+c_y,
    color=0})
end
end

function collid(
 wa_x, wa_y, wb_x, wb_y, c_x,
 c_y, vx, vy
)
den = (wa_x - wb_x) * (c_y - vy) - (wa_y - wb_y) * (c_x - vx)

if not den then
 return nil, nil
end


t = ((wa_x - c_x) * (c_y - vy) - (wa_y - c_y) * (c_x - vx)) / den
u = -((wa_x - wb_x) * (wa_y - c_y) - (wa_y - wb_y) * (wa_x - c_x)) / den

if t > 0 and t < 1 and u > 0 then
 px = wa_x + t * (wb_x - wa_x)
 py = wa_y + t * (wb_y - wa_y)
 return px, py
end
return nil, nil
end


function _update()
if(btn(0))then c_x-=1end
if(btn(1))then c_x+=1end
if(btn(2))then c_y-=1end
if(btn(3))then c_y+=1end

for v in all(vectors) do
closed = 9999
fc, fx, fy = 0, 0, 0
for w in all(walls) do
 px, py = collid(w.wa_x, w.wa_y, w.wb_x, w.wb_y, c_x, c_y, (v.x+c_x), (v.y+c_y))
 if px or py then
 if px and py then
 local m = m_vector(px, py)
	if m < closed then
	 closed = m
	 fx, fy, fc= px, py, w.c
	end
	end 
	end
end
v.color = fc
v.bx = fx
v.by = fy
end
 
end

function _draw()
casts = {}
cls()
rectfill(0, 0, 127, 127, 0)

for v in all(vectors) do
 line(c_x, c_y, v.bx, v.by, v.color)
end

circfill(c_x, c_y, 1, 10)
for w in all(walls) do
 line(w.wa_x,w.wa_y, w.wb_x, w.wb_y, 8)
end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
