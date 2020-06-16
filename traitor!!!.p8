pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

-- TODO
-- CODE AUDIT TIME
-- make allies move left and right, generally improve AI
-- make explosions more patterned
-- UI
-- text printing


function vect(posx, posy)
	return {
		x=posx,
		y=posy,

		vect_mult = function(self, m)
		    self.x *= m
			self.y *= m
		end,
		vect_div = function(self, d)
			self.x /= d
			self.y /= d
		end,
		vect_add = function(self, v)
			self.x += v.x
			self.y += v.y
		end,
		vect_sub = function(self, v)
			self.x -= v.x
			self.y -= v.y
		end,
		get_magnitude = function(self)
			return sqrt((self.x ^ 2) + (self.y ^ 2))
		end,
		set_magnitude = function(self, new_magnitude)
			current_magnitude = self:get_magnitude()

			new_x = self.x * new_magnitude / current_magnitude
			new_y = self.y * new_magnitude / current_magnitude

			self.x = new_x
			self.y = new_y
		end,
		normalize = function(self)
			current_magnitude = self:get_magnitude()

			new_x = self.x / current_magnitude
			new_y = self.y / current_magnitude

			self.x = new_x
			self.y = new_y
		end,
		dist = function(self, v)
			return abs(self.x-v.x) + abs(self.y-v.y)
		end
	}
end

function actor(t, posx, posy, properties)
  local a = {
  pos = vect(posx,posy),
  vel = vect(0,0),
  acc = vect(0,0),
		type = t or "notype",

		update = function(self) end,
		draw = function(self) end,
		add_acc = function(self, addx, addy)
		 self.acc.x += addx
		 self.acc.y += addy
		end,
		center = function(self)
			return vect(self.pos.x+4, self.pos.y+4)
		end,
		detect_hit = function(self, a, dist_to_check)
			return (self:center():dist(a:center()) < dist_to_check)
		end
 	}

	local property,value
 	for property,value in pairs(properties) do
		a[property]=value
	end

	add(actors, a)
	return a
end

function make_player()
	player = actor("player", 60,60,
					-- additional properties the player will need go here
					{
						dead = false,
						goingright = false,
						goingleft = false,
						-- how the player updates
						update = function(self)
							if not self.dead then
								self.acc:vect_mult(0.45)
								self.vel.x += self.acc.x
								self.vel.y += self.acc.y
								self.pos.x +=self.vel.x
								self.pos.y += self.vel.y
								self.vel:vect_mult(0.6)

								local i
								-- loop through all actors backwards
								for i=#actors,1,-1 do
									local a = actors[i]
									-- testing these as different hit distances for now
									if a.type == "missile" and self:detect_hit(a, 5) and a.enemies then
										self:die()
									elseif (a.type == "enemy" or a.type == "ally") and self:detect_hit(a, 8) then
										a:die()
										self:die()
									end
								end

								-- flame trails
								local displacement = -2
								if (not reverse) displacement = 10
								make_flame(player.pos.x+1, player.pos.y+displacement, 10, false, 4*progressrate)
								make_flame(player.pos.x+6, player.pos.y+displacement, 10, false, 4*progressrate)

								if self.pos.x >= 128 then
									noright = true
								else
									noright = false
								end

								if self.pos.x <= 8 then
									noleft = true
								else
									noleft = false
								end

								if self.pos.y >= 128 then
									nodown = true
								else
									nodown = false
								end

								if self.pos.y <= 8 then
									noup = true
								else
									noup = false
								end
							end
						end,
						-- how to draw the player
						draw = function(self)
							if not self.dead then
								if not reverse then
									if self.goingleft then
										spr(2, self.pos.x-4, self.pos.y-4)
									elseif self.goingright then
										spr(2, self.pos.x-4, self.pos.y-4, 1, 1, true)
									else
										spr(1, self.pos.x-4, self.pos.y-4, 1, 1)
									end
								elseif reverse then
									if self.goingleft then
										spr(2, self.pos.x-4, self.pos.y-4, 1, 1, false, true)
									elseif self.goingright then
										spr(2, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
									else
										spr(1, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
									end
								end
							elseif self.dead then
								print("GAME OVER", 49, 60, 8)
							end
						end,
						die = function(self)
							self.dead = true
							sfx(2)
							generate_explosion(self.pos.x, self.pos.y, {7 ,1})
							del(actors,player)
						end
					})
end

function make_enemy()
	local enemy = actor("enemy", flr(rnd(128)), -10,
						{
							dead = false,
							-- how the enemy updates
							update = function(self)
								self.pos.y += progressrate*2

								if (self.pos.y >= 132) del(actors,self)

								local i
								for i=#actors,1,-1 do
									local a = actors[i]
									-- testing these as different hit distances for now
									if a.type == "missile" and self:detect_hit(a, 5) and not a.enemies then
										self:die()
									elseif a.type == "ally" and self:detect_hit(a, 8) then
										a:die()
										self:die()
									end
								end
							end,
							-- how to draw the enemy
							draw = function(self)
								if not reverse then 
									spr(4, self.pos.x-4, self.pos.y-4)
								else
									spr(4, self.pos.x-4, self.pos.y-4, 1, 1, false, true)
								end
							end,
							die = function(self)
								-- delete and make explosion for the enemy
								self.dead = true;
								sfx(2)
								generate_explosion(self.pos.x, self.pos.y, {8, 11, 3})
								del(actors, self)
								del(actors, a)
							end
						})
end

function make_ally()
	local a = actor("ally", rnd(128), 132, {
					dead = false,
					goingleft = false,
					goingright = false,
					update = function(self)
						self.pos.y += progressrate*2

						if (self.pos.y <= 0) del(actors, self)

						local i
						for i=#actors,1,-1 do
							local a = actors[i]
							
							local alignedWithTarget = abs(self.pos.x-a.pos.x) < 8
							local randChance = flr(rnd(40)) == 1

							if (a.type=="player" or a.type=="enemy") and alignedWithTarget and randChance then
								make_missile(self.pos.x, self.pos.y, not reverse, true)
							end

							if a.type=="missile" and not a.enemies and self:detect_hit(a, 8) then
								self:die()
							end
						end
					end,
					draw = function(self)
						if reverse then
							if self.goingleft then
								spr(6, self.pos.x-4, self.pos.y-4)
							elseif self.goingright then
								spr(6, self.pos.x-4, self.pos.y-4, 1, 1, true)
							else
								spr(5, self.pos.x-4, self.pos.y-4, 1, 1)
							end
						elseif not reverse then
							if self.goingleft then
								spr(6, self.pos.x-4, self.pos.y-4, 1, 1, false, true)
							elseif self.goingright then
								spr(6, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
							else
								spr(5, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
							end
						end
					end,
					die = function(self)
						dead = true
						sfx(2)
						-- delete and make explosion for the enemy
						generate_explosion(self.pos.x, self.pos.y, {8,7})
						del(actors, self)
						del(actors, a)
					end
					})
end

function make_missile(posx, posy, facing, e)
	sfx(1)
	local m = actor("missile", posx,posy, {
					facing_down = facing or false,
					flip = false,
					acc_factor = progressrate*-1,
					enemies = e or false,
					update = function(self)
						self.flip = not self.flip
						self.acc:vect_mult(0.999)
						self.vel.x += self.acc.x
						self.vel.y += self.acc.y
						self.pos.x +=self.vel.x
						self.pos.y += self.vel.y
						self.vel:vect_mult(0.075)

						if not self.enemies then
						self:add_acc(0, self.acc_factor)
						else
							self:add_acc(0, -self.acc_factor)
						end

						-- if not self.facing_down then
						-- 	make_flame(self.pos.x+4, self.pos.y+8, 10, true, self.acc_factor)
						-- else
						-- 	make_flame(self.pos.x+4, self.pos.y, 10, true, self.acc_factor)
						-- end

						if (self.pos.y >= 128) or (self.pos.y <= 0) then
							del(actors,self)
						end
					end,
					draw = function(self)
						if self.facing_down then
							spr(3, self.pos.x-4, self.pos.y-4, 1, 1, self.flip, true)
						else
							spr(3, self.pos.x-4, self.pos.y-4, 1, 1, self.flip)
						end
					end
				})
end

function make_star()
	local s = actor("star", flr(rnd(128)),flr(rnd(128)),
					-- additional properties a star need go here
					{
						offscreen = false,
						col = rnd(3)+5,
						-- for parallax-ish stuff
						z = ceil(rnd(6)),
						move_left = function(self)
							self.pos.x += 0.1*self.z
						end,
						move_right = function(self)
							self.pos.x -= 0.1*self.z
						end,
						update = function(self)
							if btn(0) and not noleft then
								self:move_left()
							elseif btn(1) and not noright then
								self:move_right()
							end

							self.pos.y += ((0.5*progressrate) * self.z)

							if self.pos.y >= 132 then
								self.pos.y = -4
							end

							if self.pos.y <= -5 then
								self.pos.y = 131
							end


							if self.pos.x >= 132 then
								self.pos.x = -4
							end

							if self.pos.x <= -5 then
								self.pos.x = 131
							end
						end,
						draw = function(self)
							circfill(self.pos.x, self.pos.y, 1, self.col)
						end
					})
end

function make_flame(posx, posy, l, add_random, accf)
	local f = actor("flame", posx, posy,
					{
						lifetime = l or 25,
						col = rnd(3)+8,
						acc_factor = accf or 0,
						update = function(self)
							self.acc:vect_mult(0.5)
							self.vel.x += self.acc.x
							self.vel.y += self.acc.y
							self.pos.x += self.vel.x
							self.pos.y += self.vel.y
							self.vel:vect_mult(0.5)
							self:add_acc(0, self.acc_factor)

							self.lifetime -= 1
							if self.lifetime <= 0 then
								del(actors, self)
							end
						end,
						draw = function(self)
								circfill(self.pos.x-4, self.pos.y-4, 1, self.col)
							end
					})
	if (add_random) f:add_acc(rnd(5)-2.5, 0)
end

function make_explosion_piece(posx, posy, c, d)
	local e = actor("explosion_piece", posx, posy, {
					col = c,
					lifetime = 25,
					dir = d or vect(rnd(2)-1, rnd(2)-1),
					update = function(self)
						self.pos:vect_add(self.dir)

						self.lifetime -= 1
						if (self.lifetime <= 0) del(actors, self)
					end,
					draw = function(self)
						circfill(self.pos.x, self.pos.y, 0, c)
					end
				})
end

function generate_explosion(posx, posy, col_table)
	local i
	for i=1,6 do
		local j
		for j=1,6 do
			c = col_table[ceil(rnd(#col_table))]
			make_explosion_piece(posx+(i), posy+(j), c, vect(rnd(2)-1,-1))
		end
	end
end

function process_input()
	if not player.dead then
		if btn(0) and not noleft then
			player:add_acc(-1, 0)

			 player.goingleft = true
		elseif not btn(0) then
			player.goingleft = false
		end

		if btn(1) and not noright then
			player:add_acc(1, 0)

			player.goingright = true
		elseif not btn(1) then
			player.goingright = false
		end

		if btn(2) and not noup then
			player:add_acc(0, -1)
		end

		if btn(3) and not nodown then
			player:add_acc(0, 1)
		end

		if btnp(4) then
			make_missile(player.pos.x, player.pos.y, reverse)
		end
	end
end

-->8
function _init()
	-- player character
	make_player()

	-- arrays of objects go here
	actors = {}
	-- displacement of flames on the player's ship
	flamedisplace = 1
	-- keeping track of the progress made
	progress = 0
	-- and how fast that progress goes
	progressrate = 0.25
	printcounter = 100
	-- making sure player doesn't go off screen
	noleft = false
	noright = false
	noup = false
	nodown = false
	-- boolean for reversing all action when you become traitor
	reverse = false

	-- initialize stars
 local i
	for i=1,50 do
	 make_star()
 end
end
-->8
function _update60()

	-- become the traitor!
	progress += progressrate
	if progress >= 100 or progress <= 0 then
	 	progressrate *= -1
	 	reverse = not reverse
		sfx(0)
		print("TRAITOR!!!", 49, 60, 8)
	end

	-- change flame displacement
	flamedisplace += 5
	if flamedisplace >= 9 then
		flamedisplace = 1
	end

	process_input()

	player:update()

	if not reverse then
		if (flr(rnd(100)) == 1)	make_enemy()
	elseif reverse then
		if (flr(rnd(100)) == 1)	make_ally()
	end

	-- update and remove flames when necessary
	local i
	for i=#actors,1,-1 do
		actors[i]:update()
	end
end
-->8
function _draw()
	cls()
	
	local i
	for i=#actors,1,-1 do
		actors[i]:draw()
	end

 player:draw()
end
__gfx__
0000000000077000000780000000b000000033300007700000071000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000770000007800000030000008833880007700000071000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000077000000780000000b000008833880007700000071000000000000000000000000000000000000000000000000000000000000000000000000000
000770000087780000078800000b0000003333330017710000071100000000000000000000000000000000000000000000000000000000000000000000000000
00077000007777000077788000003000003333300077770000777110000000000000000000000000000000000000000000000000000000000000000000000000
007007000778877007787780000b0000003333300771177007717710000000000000000000000000000000000000000000000000000000000000000000000000
0000000077899877778988700000b0000bbbbbb07719917777191170000000000000000000000000000000000000000000000000000000000000000000000000
00000000788aa887788a888700030000bb0000bb711aa117711a1117000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200000e3400f3400e3400e3400e3400e3400e3400e3400e3400f34010340053000530005300053200533005330053300533004330053300533004330063300630005300043000330003300033000330000000
000100001170011700127002e7501e750227501b75021750157501c7500770007700077000670005700047000370001700007001a7001a7001b7001c7001d7001e7001e7001e7001e7001f700207002070000000
0004000000000000002065021650216401d640186301a6201c62015620106200d6100961009610036100461003610036100460000000000000000000000000000000000000000000000000000000000000000000
