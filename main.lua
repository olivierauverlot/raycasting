
require("libs.gradient")

function love.load() 

    px = 9 * 1024
    py = 11 * 1024
    stride = 5
    heading = 0
    turn = 2

    map = {
        { 8,7,8,7,8,7,8,7,8,7,8,7 },
        { 7,0,0,0,0,0,0,0,13,0,0,8 },
        { 8,0,0,0,12,0,0,0,14,0,9,7 },
        { 7,0,0,0,12,0,4,0,13,0,0,8 },
        { 8,0,4,11,11,0,3,0,0,0,0,7 },
        { 7,0,3,0,12,3,4,3,4,3,0,8 },
        { 8,0,4,0,0,0,3,0,3,0,0,7 },
        { 7,0,3,0,0,0,4,0,4,0,9,8 },
        { 8,0,4,0,0,0,0,0,0,0,0,7 },
        { 7,0,5,6,5,6,0,0,0,0,0,8 },
        { 8,0,0,0,0,0,0,0,0,0,0,7 },
        { 8,7,8,7,8,7,8,7,8,7,8,7 },
    }

    ctable = {}
    for i=0,(359 + 180) do 
        v = ((math.cos(math.rad(i)) * 1024) / 10)
        table.insert(ctable,math.floor(v))
    end

    colors = {
        {0,0,128} , {0,128,0} , {0,128,128} ,
        {0,0,128} , {128,0,128} , {128,128,0} , {192,192,192} ,
        {128,128,128} , {0,0,255} , {0,255,0} , {255,255,0} ,
        {0,0,255} , {255,0,255} , {0,255,255} , {255,255,255}
    }
end

function getAngle(a) 
    return ctable[a + 1]
end

function movePlayer(mul)
    newpx = px - (getAngle(heading + 90) * stride * mul)
    newpy = py - (getAngle(heading) * stride * mul)
    c = math.floor(newpx / 1024)
    l = math.floor(newpy / 1024)
    if map[l][c] == 0 then
        px = newpx
        py = newpy
    end
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        movePlayer(1)
    end
    if love.keyboard.isDown("down") then
        movePlayer(-1)
    end
    if love.keyboard.isDown("left") then
        heading = math.fmod((heading + (360 - turn)),360)
    end
    if love.keyboard.isDown("right") then
        heading = math.fmod((heading + turn),360)
    end
end

function love.draw()
    
    local x = 0
    local y = 0

    local color1 = {205, 255, 0, 255}
    local color2 = {0, 205, 255, 255}
    
    love.graphics.setColor(255,0,0,1)
    love.graphics.line(0,200,720,200)

    local f = function()
		love.graphics.rectangle("fill", 0, 0, 720, 200)
	end
	love.gradient.draw(f, "linear", 360, 100, 720, 200, color1, color2)
    
    angle = math.fmod((heading - 44),360)
    if angle < 0 then
        angle = angle + 360
    end

    for a=angle,(angle + 89) do
        local xx = px
        local yy = py
        stepx = getAngle(a + 90)
        stepy = getAngle(a)
        l = 0
        repeat 
            xx = xx - stepx
            yy = yy - stepy
            l = l + 1
            column = math.floor(xx / 1024)
            line = math.floor(yy / 1024)
        until(map[line][column] ~= 0)
       
        h = math.floor(900 / l)
        y = 200 - h
        color = colors[map[line][column]]
        love.graphics.setColor(color[1],color[2],color[3])
        love.graphics.rectangle("fill",x,y,8,(h * 2))
        x = x + 8
    end

end