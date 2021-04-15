rectangle = require("rectangle")

local ACTUAL_SCREEN = "LOGGIN_SCREEN"
local button_x = 75
local button_y = 400
local button_width = 250
local button_height = 50
local border_radius = 10

function love.draw()

    if ACTUAL_SCREEN == "LOGGIN_SCREEN" then
        -- Cores de fundo
        red = 192/255
        green = 195/255
        blue = 195/255
    
        love.graphics.setBackgroundColor( red, green, blue, 0)
        -- to do:
        -- ## limg: shinoPet
        
        rectangle:draw()

        -- ## img: cadastre-se
    end

end

function love.mousepressed(x, y)
    if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
        print("voce clicou no botao")
    end
end