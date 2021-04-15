local ACTUAL_SCREEN = "LOGGIN_SCREEN"


function love.draw()

    if ACTUAL_SCREEN == "LOGGIN_SCREEN" then
        red = 192/255
        green = 195/255
        blue = 195/255
    
        love.graphics.setBackgroundColor( red, green, blue, 0)
        -- to do:
        -- ## limg: shinoPet
        -- ## input login
        -- ## input senha
        -- ## input botao
        -- ## img: cadastre-se
    
        love.graphics.rectangle("fill", 100, 200, 250, 50)

    end

end