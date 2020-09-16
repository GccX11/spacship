ast_speed = 10
ast_size = 50
ship_speed = 10
ship_width = 60
ship_height = math.floor(2*ship_width/3)
flame_size = 40

ast_x = nil
ast_y = nil
x = 130
y = math.floor(love.graphics.getHeight() / 2)

score = 0
max_score = 0
lose = false

last_ast_time = 0
time_between_asts = 0

function love.load()
end

function love.update(dt)
	-- move ship
	if love.keyboard.isDown("up") then
		if y - ship_speed > 0 then
			y = y - ship_speed
		end
	end
	if love.keyboard.isDown("down") then
		if y + ship_speed + ship_height < love.graphics.getHeight() then
			y = y + ship_speed
		end
	end

	if love.keyboard.isDown("down") or love.keyboard.isDown("up") then
		if last_ast_time == 0 then
			last_ast_time = love.timer.getTime()
			time_between_asts = (love.math.random() * 4) * 1000 + 1000
		end
	end

	-- generate random asteroids
	if ast_x == nil and ast_y == nil then
		if love.timer.getTime() - last_ast_time - time_between_asts < 100 then
			ast_size = math.floor(love.math.random() * 60) + 50
			ast_x = love.graphics.getWidth()
			ast_y = math.floor(love.math.random() * (love.graphics.getHeight() - ast_size))
			last_ast_time = love.timer.getTime()
			time_between_asts = (love.math.random() * 10) * 1000 + 1000
		end
	else
		if check_collision(x,y,ship_width,ship_height, ast_x,ast_y,ast_size,ast_size) then
			-- lose = true
      if score > max_score then
        max_score = score
      end
      score = 0
		end
		if ast_x - ast_speed + ast_size > 0 then
			ast_x = ast_x - ast_speed
		else
			last_ast_time = love.timer.getTime()
			ast_x = nil
			ast_y = nil
			if not lose then
        score = score + 1
        if score > max_score then
          max_score = score
        end
			end
		end
	end
end

function love.draw()
	if not lose then
		love.graphics.print(score, 10, 10, 0, 2, 2)
    love.graphics.print(max_score, 100, 10, 0, 2, 2)

		if ast_x ~= nil and ast_y ~= nil then
			love.graphics.setColor(0, 0, 255)
			love.graphics.rectangle("fill", ast_x, ast_y, ast_size, ast_size)
		end

		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", x-math.floor(ship_width/10), y+math.floor(ship_height/2), flame_size, 3) --flame
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("fill", x, y, ship_width, ship_height) --ship
	else
		love.graphics.print("You Lose - Score "..score, love.graphics.getWidth()/2-120, 
			love.graphics.getHeight()/2-30, 0, 2, 2)

	end
end

function love.keypressed(key)
	if lose or key == "escape" then
		love.event.quit()
	end
end

function love.quit()
end


-- Collision detection function.
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function check_collision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
