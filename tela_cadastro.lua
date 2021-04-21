-- Dependencias SUIT
local suit = require 'suit'
local utf8 = require 'utf8'

-- Depencias JSON
local JSON = assert(loadfile "C:/VirtualPet_FrontEnd/json.lua")()
local http = require("socket.http")
local data = ""

-- Qual tela estou
local ACTUAL_SCREEN = "REGISTER_SCREEN"
local Cadastro = {}

-- Variáveis inputs
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

-- Input Text
local login_user = {text = "TESTE"}
local password_user = {text = "TESTE"}
local button = {}

-- Funcao que coleta o retorno do GET
local function collect(chunk)
    if chunk ~= nil then
        data = ""
        data = data .. chunk
    end
    
    return true
end

-- Funcao que valida os campos dos inputs
local function validate(input)
    local len = utf8.len(input.text)

    input.cursor = input.cursor - (len - utf8.len(input.text))
end

-- Atualiza os inputs cada vez que escreve algo
function love.update(dt)
    love.graphics.setColor(red, green, blue)
    suit.Input(login_user, x, y, w, h)
    suit.Input(password_user, x, y+100, w, h)
    --suit.Button(button, x, y+200, w, h)

    validate(login_user)
    validate(password_user)

end

-- Desenha na tela
function love.draw(dt)
    love.graphics.setBackgroundColor(red, green, blue, 0)
    suit.draw()

    love.graphics.setColor(0, 255, 0)
    -- botao:
    --suit.Button(button, x, y+200, w, h)
    love.graphics.rectangle("fill", x, y+200, w, h, border_radius)
end

-- TextInput
function love.textinput(t)
    suit.textinput(t)
end

-- KeyPressed
function love.keypressed(key)
    suit.keypressed(key)
end

-- if you want IME input, requires a font that can display the characters
function love.textedited(text, start, length)
    suit.textedited(text, start, length)
end

-- Verifica se o usuario está na base de dados
function verify_user(login, T)
    for k, user in ipairs(T) do
        if login == user["login"] then
            return true
        end
    end

    return false
end

-- Funcao do click do mouse
function love.mousepressed(x, y)
    if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
        print("TO NO REGISTRAR")
        if login_user["text"] ~= "" and password_user["text"] ~= "" then
            local ok = http.request {
                method = "GET",
                url = "http://localhost:3000/users.json",
                sink = collect
            }

            data = JSON:decode(data)
            --print("login:           ", login_user["text"])
            --print("password:        ", password_user["text"])
            --print("data:        ", data)

            login = verify_login(login_user["text"], data)

            if login == true then
                print("usuario ja existente")
            else
                print("usuario não existente")
            end

        elseif login_user["text"] == "" then
            --error("O login_user nao pode ser vazio")
            login_user["text"] = "ESTE CAMPO NÃO PODE SER VAZIO"
        elseif password_user["text"] == "" then
            --error("A senha nao pode ser vazia")
            password_user["text"] = "ESTE CAMPO NÃO PODE SER VAZIO"
        end
    end
end