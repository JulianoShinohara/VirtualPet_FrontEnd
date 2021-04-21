background_login = love.graphics.newImage('login_screen.png')
background_cadastro = love.graphics.newImage('cadastro_screen.png')

-- Dependencias SUIT
local suit = require 'suit'
local utf8 = require 'utf8'

-- Depencias JSON
local JSON = assert(loadfile "C:/VirtualPet_FrontEnd/json.lua")()
local http = require("socket.http")
local data = ""
local ltn12 = require("ltn12")

-- Qual tela estou
--[[
    LOGGIN_SCREEN
    CADASTRO_SCREEN
    LISTAGEM_SCREEN
    GAME_SCREEN
]]
local ACTUAL_SCREEN = "LOGGIN_SCREEN"

-- Variáveis do botão
--[[
    lg = login_screen
    cs = cadastro_screen
]]
local ls_x_b = 175
local ls_y_b = 417
local cs_x_b = 165
local cs_y_b = 417

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

-- Inputs Texts
local login_user = {text = ""}
local password_user = {text = ""}
local form_login_user = {text = ""}
local form_password_user = {text = ""}
local button = {}

-- Funcao que coleta o retorno das requisições
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
    if ACTUAL_SCREEN == "LOGGIN_SCREEN" then
        love.graphics.setColor(red, green, blue)
        suit.Input(login_user, x, y, w, h)
        suit.Input(password_user, x, y+100, w, h)
        --suit.Button(button, x, y+200, w, h)

        validate(login_user)
        validate(password_user)
    end
    if ACTUAL_SCREEN == "CADASTRO_SCREEN" then
        love.graphics.setColor(red, green, blue)
        suit.Input(form_login_user, x, y, w, h)
        suit.Input(form_password_user, x, y+100, w, h)
        --suit.Button(button, x, y+200, w, h)

        validate(form_login_user)
        validate(form_password_user)
    end
end

-- Desenha na tela
function love.draw(dt)
    if ACTUAL_SCREEN == "LOGGIN_SCREEN" then
        love.graphics.draw(background_login)
        love.graphics.setBackgroundColor(red, green, blue, 0)
        suit.draw()

        love.graphics.setColor(0, 255, 0)
        -- botao:
        --suit.Button(button, x, y+200, w, h)
        love.graphics.rectangle("fill", x, y+200, w, h, border_radius)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print("ENTRAR", ls_x_b, ls_y_b)
    end
    if ACTUAL_SCREEN == "CADASTRO_SCREEN" then
        love.graphics.draw(background_cadastro)
        love.graphics.setBackgroundColor(red, green, blue, 0)
        suit.draw()

        love.graphics.setColor(0, 255, 0)
        -- botao:
        --suit.Button(button, x, y+200, w, h)
        love.graphics.rectangle("fill", x, y+200, w, h, border_radius)
        
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("CADASTRAR", cs_x_b, cs_y_b)

        love.graphics.setColor(255, 0, 0)
        love.graphics.polygon("fill", 5, 580, 40, 600, 40, 560)
    end
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
function verify_login(login, senha, T)
    for k, user in ipairs(T) do
        if login == user["login"] and senha == user["senha"] then
            return true
        end
    end

    return false
end

function verify_user(user_v, T)
    for k, user in ipairs(T) do
        if user_v == user["login"] then
            return false
        end
    end

    return true
end

function get_users()
    -- Faço a requisição
    local ok = http.request {
        method = "GET",
        url = "http://localhost:3000/users.json",
        sink = collect
    }

    --** Passo o JSON para uma tabela
    data = JSON:decode(data)
end

function post_user()
    user = {}
    user["login"] = form_login_user["text"]
    user["senha"] = form_password_user["text"]
    
    local payload = JSON:encode(user)
    local response_body = { }

    local res, code, response_headers, status = http.request
    {
      url = "http://localhost:3000/users.json",
      method = "POST",
      headers =
      {
        ["Authorization"] = "Maybe you need an Authorization header?",
        ["Content-Type"] = "application/json",
        ["Content-Length"] = payload:len()
      },
      source = ltn12.source.string(payload),
      sink = ltn12.sink.table(response_body)
    }
    
    if code ~= 201 then
        return false
    end

    return true
end

function login()
    get_users()
    --print("login:           ", login_user["text"])
    --print("password:        ", password_user["text"])
    --print("data:        ", data)

    return verify_login(login_user["text"], password_user["text"], data)
end

function cadastro()
    get_users()

    if verify_user(form_login_user["text"], data) then
        return post_user()
    else
        form_login_user["text"] = "ERRO!"
        return false
    end
end

-- Funcao do click do mouse
function love.mousepressed(x, y)
    --** Se o cara estiver na tela de login
    if ACTUAL_SCREEN == "LOGGIN_SCREEN" then
        --** Se clicou no botão de logar
        if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
            --** Se os campos não estiverem vazios
            if login_user["text"] ~= "" and password_user["text"] ~= "" then
                --** Verifico o login
                login_result = login()

                if login_result == true then
                    print("voce entrou!")
                else
                    login_user["text"] = "ERRO!"
                    password_user["text"] = "ERRO!"
                end

            elseif login_user["text"] == "" and password_user["text"] == "" then
                login_user["text"] = "ERRO!"
                password_user["text"] = "ERRO!"
            elseif login_user["text"] == "" then
                --error("O login_user nao pode ser vazio")
                login_user["text"] = "ERRO!"
            elseif password_user["text"] == "" then
                --error("A senha nao pode ser vazia")
                password_user["text"] = "ERRO!"
            end
        end

        if x >= button_x and x <= button_x + button_width and y >= (button_y + 50) and y <= (button_y + 50) + button_height then
            ACTUAL_SCREEN = "CADASTRO_SCREEN"
        end
    elseif ACTUAL_SCREEN == "CADASTRO_SCREEN" then
        if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
            
            if form_login_user["text"] ~= "" and form_password_user["text"] ~= "" then
                cadastro_result = cadastro()

                if cadastro_result == true then
                    ACTUAL_SCREEN = "LOGGIN_SCREEN"
                else
                    form_login_user["text"] = "ERRO!"
                    form_password_user["text"] = "ERRO!"
                end
            end

        end
        if x >= 5 and x <= 40 and y >= 560 and y <= 600 then
            ACTUAL_SCREEN = "LOGGIN_SCREEN"
        end
    end
end