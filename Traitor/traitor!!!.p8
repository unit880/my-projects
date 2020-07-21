pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

-- Traitor!!!
-- made by: neptune supermax

-- v = vect(x,y)
-- instantiates a vector table with a position of (x, y)
function vect(posx, posy)
	return {
		x=posx,
		y=posy,

		-- v:vect_mult(m)
		-- where v is a vector object and m is the multiplier
		vect_mult = function(self, m)
		    self.x *= m
			self.y *= m
		end,
		-- v:vect_div(d)
		-- where v is a vector object and d is the divisor
		vect_div = function(self, d)
			self.x /= d
			self.y /= d
		end,
		-- v:vect_add(v2)
		-- where v is a vector object and v2 is a vector object with x/y components to be added
		vect_add = function(self, v)
			self.x += v.x
			self.y += v.y
		end,
		-- v:vect_sub(v2)
		-- where v is a vector object and v2 is a vector object with x/y components ot be subtracted
		vect_sub = function(self, v)
			self.x -= v.x
			self.y -= v.y
		end,
		-- v:get_magnitude()
		-- returns the magnitude of a vector object v
		get_magnitude = function(self)
			return sqrt((self.x ^ 2) + (self.y ^ 2))
		end,
		-- v:set_magnitude(new_magnitude)
		-- sets vector object v's magnitude to new_magnitude
		set_magnitude = function(self, new_magnitude)
			current_magnitude = self:get_magnitude()

			new_x = self.x * new_magnitude / current_magnitude
			new_y = self.y * new_magnitude / current_magnitude

			self.x = new_x
			self.y = new_y
		end,
		-- v:normalize()
		-- sets a vector object v's magnitude to 1
		normalize = function(self)
			current_magnitude = self:get_magnitude()

			new_x = self.x / current_magnitude
			new_y = self.y / current_magnitude

			self.x = new_x
			self.y = new_y
		end,
		-- v:dist(v2)
		-- returns v's distance to v2 using manhattan distance
		dist = function(self, v)
			return abs(self.x-v.x) + abs(self.y-v.y)
		end,
		-- v:euclidean_dist(v2)
		-- returns v's distance to v2 using euclidean distance 
		euclidean_dist = function(self, v)
			return sqrt(((self.x-v.x)^2) + ((self.y-v.y)^2))
		end
	}
end

-- a = actor(t, x, y, additional_properties)
-- instantiates an actor table with type t, pos of (x, y) and table of additional properties to add
function actor(t, x, y, additional_properties)
  local a = {
	  	-- "notype" used as a default in order to catch untyped objects
	  	type = t or "notype",
		pos = vect(x,y) or vect(0,0),
		vel = vect(0,0),
		acc = vect(0,0),

		-- placeholder update and draw functions
		update = function(self) end,
		draw = function(self) end,
		-- basic way to add acceleration to an object
		add_acc = function(self, addx, addy)
		 self.acc.x += addx
		 self.acc.y += addy
		end,
		-- returns the centerpoint of an actor's sprite
		center = function(self)
			return vect(self.pos.x+4, self.pos.y+4)
		end,
		-- a:detect_hit(a2, dist_to_check)
		-- checks if actor a's center and actor a2's center is within radius dist_to_check 
		detect_hit = function(self, a, dist_to_check)
			return (self:center():dist(a:center()) < dist_to_check)
		end,
		-- same thing but using euclidean distance with a sqrt check
		detect_hit_euclidean = function(self, a, dist_to_check)
			return (self:center():euclidean_dist(a:center()) < dist_to_check)
		end
 	}

	-- add all additional properties to the actor table
	local property,value
 	for property,value in pairs(additional_properties) do
		a[property]=value
	end

	-- automatically add actor a to the actors table
	add(actors, a)
	-- also return it so it may be caught if necessary
	return a
end

-- p = make_player()
function make_player()
	player = actor("player", 60,60,
			-- additional properties the player will need go here
			{
				-- various bools which alter win conditions and sprite state
				dead = false,
				goingright = false,
				goingleft = false,
				-- update function for player table
				update = function(self)
					if not self.dead then
						-- acceleration/velocity handling for player
						self.acc:vect_mult(0.45)
						self.vel.x += self.acc.x
						self.vel.y += self.acc.y
						self.pos.x +=self.vel.x
						self.pos.y += self.vel.y
						self.vel:vect_mult(0.6)

						local i
						-- loop through all actors backwards because they might need deleting
						for i=#actors,1,-1 do
							local a = actors[i]
							-- if an enemy missile hits us, we're dead
							if a.type == "missile" and self:detect_hit(a, 5) and a.enemies then
								self:die()
							-- if ally or enemy crashes into our ship, we both die
							elseif (a.type == "enemy" or a.type == "ally") and self:detect_hit(a, 8) then
								a:die()
								self:die()
							end
						end

						-- code that handles flame trails for the player
						local displacement = -2
						if (not reverse) displacement = 10
						make_flame(player.pos.x+1, player.pos.y+displacement, 10, false, 4*progressrate)
						make_flame(player.pos.x+6, player.pos.y+displacement, 10, false, 4*progressrate)

						-- limit player's movement to the right
						if self.pos.x >= 128 then
							noright = true
						else
							noright = false
						end

						-- limit player's movement to the left
						if self.pos.x <= 8 then
							noleft = true
						else
							noleft = false
						end

						-- limit player's movement down
						if self.pos.y >= 128 then
							nodown = true
						else
							nodown = false
						end

						-- limit player's movement up
						if self.pos.y <= 8 then
							noup = true
						else
							noup = false
						end
					end
				end,
				-- draw function for player table
				draw = function(self)
					if not self.dead then
						-- sprites for fighting enemies
						if not reverse then
							-- sprite for leaning left
							if self.goingleft then
								spr(2, self.pos.x-4, self.pos.y-4)
							-- sprite for leaning right
							elseif self.goingright then
								spr(2, self.pos.x-4, self.pos.y-4, 1, 1, true)
							-- default sprite
							else
								spr(1, self.pos.x-4, self.pos.y-4, 1, 1)
							end
						-- sprites for fighting allies
						elseif reverse then
							-- sprite for leaning left
							if self.goingleft then
								spr(2, self.pos.x-4, self.pos.y-4, 1, 1, false, true)
							-- sprite for leaning right
							elseif self.goingright then
								spr(2, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
							-- default sprite
							else
								spr(1, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
							end
						end
					-- what to draw when player has died
					elseif self.dead then
						print("GAME OVER", 49, 60, 8)
					end
				end,
				-- called once when player dies
				die = function(self)
					self.dead = true
					sfx(2)
					generate_explosion(self.pos.x, self.pos.y, {7 ,1})
					del(actors,player)
				end
			})
end

-- e = make_enemy()
function make_enemy()
	local enemy = actor("enemy", flr(rnd(128)), -10,
				{
					-- various bools we might need for enemy states
					dead = false,
					-- update function for enemy table
					update = function(self)
						-- manually move enemy depending on progress rate
						self.pos.y += progressrate*2

						-- delete any enemy that moves too far offscreen
						if (self.pos.y >= 132) del(actors,self)

						local i
						-- loop through actors backward in case we need to delete any
						for i=#actors,1,-1 do
							local a = actors[i]
							-- if a missile hits an enemy, they die
							if a.type == "missile" and self:detect_hit(a, 5) then
								self:die()
							-- if an ally hits an enemy, they both die
							elseif a.type == "ally" and self:detect_hit(a, 8) then
								a:die()
								self:die()
							end
						end
					end,
					-- how to draw the enemy
					draw = function(self)
						-- reverse sprite in event we're traitoring
						if not reverse then 
							spr(4, self.pos.x-4, self.pos.y-4)
						else
							spr(4, self.pos.x-4, self.pos.y-4, 1, 1, false, true)
						end
					end,
					-- called once when an enemy dies
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

-- a = make_ally()
function make_ally()
	local a = actor("ally", rnd(128), 132, 
			{
				-- booleans to keep track of various states
				dead = false,
				goingleft = false,
				goingright = false,
				-- updatae function for ally tables
				update = function(self)
					-- move allies along to progress rate
					self.pos.y += progressrate*2

					-- if an ally goes too far off screen, delete em
					if (self.pos.y <= 0) del(actors, self)

					local i
					-- reverse through actors in case any need deleting
					for i=#actors,1,-1 do
						local a = actors[i]
						
						-- bad current AI for allies shooting missiles, hopefully to be replaced
						local alignedWithTarget = abs(self.pos.x-a.pos.x) < 8
						local randChance = flr(rnd(40)) == 1

						if (a.type=="player" or a.type=="enemy") and alignedWithTarget and randChance then
							make_missile(self.pos.x, self.pos.y, not reverse, true)
						end

						-- if a missile of ours hits an ally, they die
						if a.type=="missile" and not a.enemies and self:detect_hit(a, 8) then
							self:die()
						end
					end
				end,
				-- draw function for ally tables
				draw = function(self)
					if reverse then
						-- going left
						if self.goingleft then
							spr(6, self.pos.x-4, self.pos.y-4)
						-- going right
						elseif self.goingright then
							spr(6, self.pos.x-4, self.pos.y-4, 1, 1, true)
						-- default sprite (only one that works currently lmao)
						else
							spr(5, self.pos.x-4, self.pos.y-4, 1, 1)
						end
					-- this is after because this is not the default state for when allies come out
					elseif not reverse then
						-- going left no reverse
						if self.goingleft then
							spr(6, self.pos.x-4, self.pos.y-4, 1, 1, false, true)
						-- going right no reverse
						elseif self.goingright then
							spr(6, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
						-- default reverse sprite
						else
							spr(5, self.pos.x-4, self.pos.y-4, 1, 1, true, true)
						end
					end
				end,
				-- called once when an ally dies
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

-- m = make_missile(x, y, facing, enemies)
function make_missile(x, y, facing, e)
	-- play a sound effect when making a missile automatically
	sfx(1)
	local m = actor("missile", x,y, 
			{
				-- various booleans for keeping track of missile states
				facing_down = facing or false,
				flip = false,
				
				-- may manually change acc_factor at a later date, or make it so they start of slow and progressively get faster.
				acc_factor = progressrate*-1,
				enemies = e or false,

				-- update function for missile tables
				update = function(self)
					self.flip = not self.flip
					self.acc:vect_mult(0.999)
					self.vel.x += self.acc.x
					self.vel.y += self.acc.y
					self.pos.x +=self.vel.x
					self.pos.y += self.vel.y
					self.vel:vect_mult(0.075)

					-- add acceleration factor that is based on progress rate 
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
				-- draw function for missile tables
				draw = function(self)
					-- one for facing up or down, depending which way it shoots
					if self.facing_down then
						spr(3, self.pos.x-4, self.pos.y-4, 1, 1, self.flip, true)
					else
						spr(3, self.pos.x-4, self.pos.y-4, 1, 1, self.flip)
					end
				end
			})
end

-- s = make_star()
function make_star()
	local s = actor("star", flr(rnd(128)),flr(rnd(128)),
			-- additional properties a star need go here
			{
				-- just a bool to check if we should delete a star
				offscreen = false,
				-- color of the star
				col = rnd(3)+5,
				-- for parallax-ish stuff relating to how far away a star is
				z = ceil(rnd(6)),

				-- for moving directions depending on player's movement
				move_left = function(self)
					self.pos.x += 0.1*self.z
				end,
				move_right = function(self)
					self.pos.x -= 0.1*self.z
				end,
				-- update function for all stars
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
				-- draw function for all stars
				draw = function(self)
					circfill(self.pos.x, self.pos.y, 1, self.col)
				end
			})
end

-- f = make_flame(x,y, lifetime of the flame, for adding random direction, acceleration factor)
function make_flame(x, y, l, add_random, accf)
	local f = actor("flame", x, y,
			{
				-- lifetime of the flame
				lifetime = l or 25,
				-- color of the flame
				col = rnd(3)+8,
				-- how fast the flame moves
				acc_factor = accf or 0,
				-- update function for all flames
				update = function(self)
					self.acc:vect_mult(0.5)
					self.vel.x += self.acc.x
					self.vel.y += self.acc.y
					self.pos.x += self.vel.x
					self.pos.y += self.vel.y
					self.vel:vect_mult(0.5)
					self:add_acc(0, self.acc_factor)

					-- delet this if lifetime is less then 0
					self.lifetime -= 1
					if self.lifetime <= 0 then
						del(actors, self)
					end
				end,
				-- draw function for all flames
				draw = function(self)
						circfill(self.pos.x-4, self.pos.y-4, 1, self.col)
					end
			})
	if (add_random) f:add_acc(rnd(5)-2.5, 0)
end

-- e = make_explosion_piece(x,y, color, direction)
function make_explosion_piece(x, y, c, d)
	local e = actor("explosion_piece", x, y, 
			{
				-- color of the explosion piece
				col = c,
				-- lifetime the explosion piece has
				lifetime = 25,
				-- direction the explosion piece moves
				dir = d or vect(rnd(2)-1, rnd(2)-1),
				-- update function for explosion piece tables
				update = function(self)
					self.pos:vect_add(self.dir)

					self.lifetime -= 1
					if (self.lifetime <= 0) del(actors, self)
				end,
				-- draw function for explosion piece tables
				draw = function(self)
					circfill(self.pos.x, self.pos.y, 0, c)
				end
			})
end

-- generate an explosion at p = (x,y) taking random colors from a table of provided colors
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

-- for processing all player input
function process_input()
	if not player.dead then
		-- pressing left or a
		if btn(0) and not noleft then
			player:add_acc(-1, 0)

			 player.goingleft = true
		elseif not btn(0) then
			player.goingleft = false
		end

		-- pressing right or d
		if btn(1) and not noright then
			player:add_acc(1, 0)

			player.goingright = true
		elseif not btn(1) then
			player.goingright = false
		end

		-- pressing up or w
		if btn(2) and not noup then
			player:add_acc(0, -1)
		end

		-- pressing down or s
		if btn(3) and not nodown then
			player:add_acc(0, 1)
		end

		-- pressing z
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

	-- when progress hits a certain threshold, you become a traitor
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

	-- process player input
	process_input()

	-- update the player
	player:update()

	-- generate random enemies
	if not reverse then
		if (flr(rnd(100)) == 1)	make_enemy()
	elseif reverse then
		if (flr(rnd(100)) == 1)	make_ally()
	end

	-- update all actors besides the player
	local i
	for i=#actors,1,-1 do
		actors[i]:update()
	end
end
-->8
function _draw()
	-- clear screen
	cls()
	
	-- draw all actors besides player
	local i
	for i=#actors,1,-1 do
		actors[i]:draw()
	end

	-- draw the player
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
