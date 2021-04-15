local Rectangle = {}

function Rectangle:draw() 
    --  DEFINIÇÃO POSIÇÃO DOS INPUTS
    x = 75
    y = 200
    width = 250
    height = 50
    border_radius = 10

    --  DEFINIÇÃO CORES DO INPUT
    red = 230/255
    green = 232/255
    blue = 233/255

    -- mudo a cor e desenho os retangulos
    love.graphics.setColor(red, green, blue)
    love.graphics.rectangle("fill", x, y, width, height, border_radius)
    love.graphics.rectangle("fill", x, y+100, width, height, border_radius)

    -- mudo a cor novamente, e desenho o "botão"
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", x, y+200, width, height, border_radius)
end

return Rectangle