local suit = require 'suit'
local utf8 = require 'utf8'

local ACTUAL_SCREEN = "LOGGIN_SCREEN"
local button_x = 75
local button_y = 400
local button_width = 250
local button_height = 50
local border_radius = 10

local x = 75
local y = 200
local w = 250
local h = 50
local border_radius = 10

local red = 192/255
local green = 195/255
local blue = 195/255

local input1 = {text = ""}
local input2 = {text = ""}
local button = {}

local function validate(input)
    local len = utf8.len(input.text)

    input.cursor = input.cursor - (len - utf8.len(input.text))
end

function love.update(dt)
    love.graphics.setColor(red, green, blue)
    suit.Input(input1, x, y, w, h)
    suit.Input(input2, x, y+100, w, h)

    
    --suit.Button(button, x, y+200, w, h)

    validate(input1)
    validate(input2)

end

function love.draw(dt)
    love.graphics.setBackgroundColor(red, green, blue, 0)
    suit.draw()

    love.graphics.setColor(0, 255, 0)
    --suit.Button(button, x, y+200, w, h)
    love.graphics.rectangle("fill", x, y+200, w, h, border_radius)
    --[[
        -- Cores de fundo

    
        
        -- to do:
        -- ## limg: shinoPet
        
        rectangle:draw()

        -- ## img: cadastre-se
    ]]
end

function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)
    suit.keypressed(key)
end

-- if you want IME input, requires a font that can display the characters
function love.textedited(text, start, length)
    suit.textedited(text, start, length)
end

function love.mousepressed(x, y)
    if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
        print("voce clicou no botao")
        print("login        ", input1["text"])
        print("senha        ", input2["text"])
    end
end