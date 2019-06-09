pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function m_vector(x, y)
  local x = x - player.x
  local y = y - player.y
  local c = x^2 + y^2
  return abs(sqrt(c))
end


function collid_ray(wa_x, wa_y, wb_x, wb_y, c_x, c_y, vx, vy)
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


function _init()
  h = 64
  vectors = {}
  walls = {
    {wa_x=50, wa_y=20, wb_x=50, wb_y=80, c = 9},
    {wa_x=50, wa_y=20, wb_x=80, wb_y=20, c=13},
    {wa_x=80, wa_y=10, wb_x=100, wb_y=10, c=12},
    {wa_x=50,wa_y=80,wb_x=20, wb_y=80, c=14},
  }
  player = {x=64, y=64}

  for b=0,1,1/360 do
    x, y = cos(b)*h, sin(b)*h
    add(vectors, {x= x, y=y, bx=x+player.x, by=y+player.y, color=0})
  end
end


function _update()
  if(btn(0))then player.x-=1 end
  if(btn(1))then player.x+=1 end
  if(btn(2))then player.y-=1 end
  if(btn(3))then player.y+=1 end

  for vector in all(vectors) do
    closed_ray = 1000
    fc, fx, fy = 0, 0, 0
    for w in all(walls) do
       px, py = collid_ray(
          w.wa_x, w.wa_y, w.wb_x, w.wb_y, player.x,
          player.y, (vector.x+player.x), (vector.y+player.y)
       )
      if px or py then
        local m = m_vector(px, py)
        if m < closed_ray then
          closed_ray = m
          fx, fy, fc= px, py, w.c
       end
      end
    end
    vector.color = fc
    vector.bx = fx
    vector.by = fy
  end
end


function _draw()
  cls()
  rectfill(0, 0, 127, 127, 0)

  for vector in all(vectors) do
    line(player.x, player.y, vector.bx, vector.by, vector.color)
  end

  circfill(player.x, player.y, 1, 10)
  for wall in all(walls) do
    line(wall.wa_x, wall.wa_y, wall.wb_x, wall.wb_y, 8)
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
