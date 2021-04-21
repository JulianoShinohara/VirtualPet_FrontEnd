--** Backgrounds
background_login = love.graphics.newImage('login_screen.png')
background_cadastro = love.graphics.newImage('cadastro_screen.png')
pet_amarelo = love.graphics.newImage('amarelo.png')
pet_roxo =love.graphics.newImage('roxo.png')

--** Dependencias SUIT
local suit = require 'suit'
local utf8 = require 'utf8'

--** Depencias JSON
local JSON = assert(loadfile "C:/VirtualPet_FrontEnd/json.lua")()
local http = require("socket.http")
local data = ""
local ltn12 = require("ltn12")

--** Qual tela estou
--[[
    LOGGIN_SCREEN
    CADASTRO_USUARIO_SCREEN
    CADASTRO_PET_SCREEN
    LISTAGEM_SCREEN
    GAME_SCREEN
]]
local ACTUAL_SCREEN = "CADASTRO_PET_SCREEN"
local usuario_logado = {}

--** Variáveis do botão
--[[
    ls = login_screen
    cs = CADASTRO_USUARIO_SCREEN
    cp = CADASTRO_pet_SCREEN
    lt = listagem_screen
]]
local y_b = 417
local cp_y_b = 517
local ls_x_b = 175
local cs_x_b = 165
local lt_x_b = 130

--** Variáveis inputs
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

--** Inputs Texts
local login_user = {text = "c"}
local password_user = {text = "c"}
local form_login_user = {text = ""}
local form_password_user = {text = ""}
local form_nome_pet = {text = ""}
local button = {}

--** Funcao que coleta o retorno das requisições
local function collect(chunk)
    if chunk ~= nil then
        data = ""
        data = data .. chunk
    end
    
    return true
end

--** Funcao que valida os campos dos inputs
local function validate(input)
    local len = utf8.len(input.text)

    input.cursor = input.cursor - (len - utf8.len(input.text))
end

--** Atualiza os inputs cada vez que escreve algo
function love.update(dt)
    if ACTUAL_SCREEN == "LOGGIN_SCREEN" then
        love.graphics.setColor(red, green, blue)
        suit.Input(login_user, x, y, w, h)
        suit.Input(password_user, x, y+100, w, h)
        --suit.Button(button, x, y+200, w, h)

        validate(login_user)
        validate(password_user)
    end
    if ACTUAL_SCREEN == "CADASTRO_USUARIO_SCREEN" then
        love.graphics.setColor(red, green, blue)
        suit.Input(form_login_user, x, y, w, h)
        suit.Input(form_password_user, x, y+100, w, h)
        --suit.Button(button, x, y+200, w, h)

        validate(form_login_user)
        validate(form_password_user)
    end
    if ACTUAL_SCREEN == "CADASTRO_PET_SCREEN" then
        love.graphics.setColor(red, green, blue)
        suit.Input(form_nome_pet, x, y, w, h)

        validate(form_nome_pet)
    end
end

--** Desenha na tela
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
        love.graphics.print("ENTRAR", ls_x_b, y_b)
    end
    if ACTUAL_SCREEN == "CADASTRO_USUARIO_SCREEN" then
        love.graphics.draw(background_cadastro)
        love.graphics.setBackgroundColor(red, green, blue, 0)
        suit.draw()

        love.graphics.setColor(0, 255, 0)
        -- botao:
        --suit.Button(button, x, y+200, w, h)
        love.graphics.rectangle("fill", x, y+200, w, h, border_radius)
        
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("CADASTRAR", cs_x_b, y_b)

        love.graphics.setColor(255, 0, 0)
        love.graphics.polygon("fill", 5, 580, 40, 600, 40, 560)
    end
    if ACTUAL_SCREEN == "LISTAGEM_SCREEN" then
        love.graphics.setBackgroundColor(red, green, blue, 0)

        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", x, y+200, w, h, border_radius)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print("CADASTRAR NOVO PET", lt_x_b, y_b)

        love.graphics.setColor(255, 0, 0)
        love.graphics.polygon("fill", 5, 575, 40, 595, 40, 555)
    end 
    if ACTUAL_SCREEN == "CADASTRO_PET_SCREEN" then
        love.graphics.setBackgroundColor(red, green, blue, 0)
        suit.draw()

        love.graphics.draw(pet_amarelo, 0, 270)
        love.graphics.draw(pet_roxo, 200, 270)

        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", x, y+300, w, h, border_radius)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print("CADASTRAR", cs_x_b, cp_y_b)
    end
end

--** TextInput
function love.textinput(t)
    suit.textinput(t)
end

--** KeyPressed
function love.keypressed(key)
    suit.keypressed(key)
end

--** if you want IME input, requires a font that can display the characters
function love.textedited(text, start, length)
    suit.textedited(text, start, length)
end

--** Verifica se o usuario está na base de dados
function verify_login(login, senha, T)
    for k, user in ipairs(T) do
        if login == user["login"] and senha == user["senha"] then
            usuario_logado["id"] = user["id"]
            return true
        end
    end

    return false
end

--** Verifico se o login já existe
function verify_user(user_v, T)
    for k, user in ipairs(T) do
        if user_v == user["login"] then
            return false
        end
    end

    return true
end

--** Faz o GET
function get_users()
    local ok = http.request {
        method = "GET",
        url = "http://localhost:3000/users.json",
        sink = collect
    }

    data = JSON:decode(data)
end

--** Faz o POST
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

--** Função loguin
function login()
    get_users()
    --print("login:           ", login_user["text"])
    --print("password:        ", password_user["text"])
    --print("data:        ", data)

    return verify_login(login_user["text"], password_user["text"], data)
end

--** Função que cadastra
function cadastro()
    --** Pego os usuarios
    get_users()

    --** Verifico se não tem login igual
    if verify_user(form_login_user["text"], data) then
        --** Cadastro
        return post_user()
    --** Deu erro
    else
        form_login_user["text"] = "ERRO!"
        return false
    end

    return false
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

                --** logou
                if login_result == true then
                    ACTUAL_SCREEN = "LISTAGEM_SCREEN"
                else
                    login_user["text"] = "ERRO!"
                    password_user["text"] = "ERRO!"
                end
            
            --** tratar erros
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

        --** Caso clique no botão de cadastrar
        if x >= button_x and x <= button_x + button_width and y >= (button_y + 50) and y <= (button_y + 50) + button_height then
            ACTUAL_SCREEN = "CADASTRO_USUARIO_SCREEN"
        end
    --** Se eu ja estiver na tela de cadastro
    elseif ACTUAL_SCREEN == "CADASTRO_USUARIO_SCREEN" then
        --** Se apertou o botão
        if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
            --** Se não mandou dados vazios
            if form_login_user["text"] ~= "" and form_password_user["text"] ~= "" then
                --** Cadastro a pessoa
                cadastro_result = cadastro()

                --** Se der certo, ela volta para o login
                if cadastro_result == true then
                    ACTUAL_SCREEN = "LOGGIN_SCREEN"
                --** Se der errado, avisa que deu errado
                else
                    form_login_user["text"] = "ERRO!"
                    form_password_user["text"] = "ERRO!"
                end
            end

        end
        if x >= 5 and x <= 40 and y >= 560 and y <= 600 then
            ACTUAL_SCREEN = "LOGGIN_SCREEN"
        end
    elseif ACTUAL_SCREEN == "LISTAGEM_SCREEN" then
        if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
            ACTUAL_SCREEN = "CADASTRO_PET_SCREEN"
        end

        if x >= 5 and x <= 40 and y >= 560 and y <= 600 then
            ACTUAL_SCREEN = "LOGGIN_SCREEN"
        end
    end
end