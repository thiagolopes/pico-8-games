pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
vx = 1
vy = 1

x = 80
y = 30
RADIUS = 8
color_id = 4
trace = {
   {pos_x = x, pos_y = y, color = color_id},
   {pos_x = x, pos_y = y, color = color_id},
   {pos_x = x, pos_y = y, color = color_id},
   {pos_x = x, pos_y = y, color = color_id},
   {pos_x = x, pos_y = y, color = color_id},
   {pos_x = x, pos_y = y, color = color_id},
}

function is_c(x, y)
   if (x-RADIUS<0) or (y-RADIUS<0)then
      return false
   end
   if (x+RADIUS>127) or (y+RADIUS>127*.8)then
      return  false
   end
   return true
end

function add_shadow_in_stack(x, y, color)
   for t=#trace,1,-1 do
      if t == 1 then
         trace[t].pos_x = x
         trace[t].pos_y = y
         trace[t].color = color
      else
         trace[t].pos_x = trace[t-1].pos_x
         trace[t].pos_y = trace[t-1].pos_y
         trace[t].color = trace[t-1].color
      end
   end
end

function _update()
   old_x, old_y = x, y

   x += vx
   y += vy

   if not is_c(x+1,y) or not is_c(x-1,y) then
      vx *= -1
   end
   if not is_c(x,y+1) or not is_c(x,y-1) then
      vy *= -1
   end

   if (btn(0) and is_c(x-1,y)) then
      x = x - 1
   end

   if (btn(1) and is_c(x+1,y)) then
      x = x + 1
   end

   if (btn(2) and is_c(x,y-1)) then
      y = y - 1
   end

   if (btn(3) and is_c(x,y+1)) then
      y = y + 1
   end

   if old_x != x or old_y !=y then
      add_shadow_in_stack(old_x, old_y, color_id)
      get_color()
   end
end

function get_color()
   if color_id >= 15 then
      color_id = 2
      return
   end
   color_id = color_id + 1
end

function _draw()
   cls()
   rectfill(0,0,127,127*0.8,1)

   for tt=#trace,1,-1 do
      local t = trace[tt]
      circ(t.pos_x, t.pos_y, RADIUS, t.color)
   end
   circfill(x,y,RADIUS,color_id)
end
