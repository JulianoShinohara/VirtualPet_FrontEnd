--** Backgrounds
background_login = love.graphics.newImage('login_screen.png')
background_cadastro = love.graphics.newImage('cadastro_screen.png')
background_listagem_0 = love.graphics.newImage('nenhumPet.png')
background_listagem_1 = love.graphics.newImage('onePet.png')
background_listagem_2 = love.graphics.newImage('twoPet.png')
background_listagem_3 = love.graphics.newImage('threePet.png')
background_listagem_4 = love.graphics.newImage('fourPet.png')
background_cadastro_pets = love.graphics.newImage('Logo.png')
background_pets = love.graphics.newImage('game_screen.png')
background_pets_dark = love.graphics.newImage('game_screen_dark.png')

--** PETS images
pet_amarelo = love.graphics.newImage('amarelo.png')
pet_roxo = love.graphics.newImage('roxo.png')

pet_amarelo_feliz = love.graphics.newImage('feliz_01.png')
pet_roxo_feliz = love.graphics.newImage('feliz_02.png')

pet_amarelo_dormindo =  love.graphics.newImage('dormindo_01.png')
pet_roxo_dormindo =  love.graphics.newImage('dormindo_02.png')

pet_amarelo_morto =  love.graphics.newImage('morto_01.png')
pet_roxo_morto =  love.graphics.newImage('morto_02.png')

pet_amarelo_doente = love.graphics.newImage('doente_01.png')
pet_roxo_doente = love.graphics.newImage('doente_02.png')

pet_amarelo_fome = love.graphics.newImage('fome_01.png')
pet_roxo_fome = love.graphics.newImage('fome_02.png')

pet_amarelo_sono = love.graphics.newImage('sono_01.png')
pet_roxo_sono = love.graphics.newImage('sono_02.png')

pet_amarelo_sujo = love.graphics.newImage('sujo_01.png')
pet_roxo_sujo = love.graphics.newImage('sujo_02.png')

pet_amarelo_sono = love.graphics.newImage('sono_01.png')
pet_roxo_sono = love.graphics.newImage('sono_02.png')

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
    PET_SCREEN
]]
local ACTUAL_SCREEN = "LOGGIN_SCREEN"
local usuario_logado = {}
local pet_atual = {}
local actual_user_pet = {}
local att = 0

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

--** Variáveis do pet
local font_x
local font_y
--local pet_x
--local pet_y

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
local login_user = {text = ""}
local password_user = {text = ""}
local form_login_user = {text = ""}
local form_password_user = {text = ""}
local form_nome_pet = {text = ""}
local button = {}

--[[
    VARIÁVEIS TELA DE CADASTRO DE PET
]]
local pet1 = true

--[[
    VARIÁVEIS TELA DE lISTAGEM DE PET
]]
local qtd_pet = 0

--[[
    VARIÁVEIS TELA DO PET
]]
local light = true
local dead = false 

local healthRate =  0.05
local happyRate = 0.07
local hungerRate = 0.09
local sleepRate = 0.075
local cleanRate = 0.025

local state_pet = 200

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

local align = "center"
local default = love.graphics.newFont(30)
local norm = love.graphics.newFont(13)
local test = 5
--** Desenha na tela
function love.draw(dt)
    if ACTUAL_SCREEN == "LOGGIN_SCREEN" then
        love.graphics.draw(background_login)
        suit.draw()

        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", x, y+200, w, h, border_radius)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print("ENTRAR", ls_x_b, y_b)
    end
    if ACTUAL_SCREEN == "CADASTRO_USUARIO_SCREEN" then
        love.graphics.draw(background_cadastro)
        suit.draw()

        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", x, y+200, w, h, border_radius)
        
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("CADASTRAR", cs_x_b, y_b)

        love.graphics.setColor(255, 0, 0)
        love.graphics.polygon("fill", 5, 580, 40, 600, 40, 560)
    end
    if ACTUAL_SCREEN == "LISTAGEM_SCREEN" then
        update_qtd_pet() 

        if qtd_pet == 0 then
            love.graphics.draw(background_listagem_0)
        elseif qtd_pet == 1 then
            love.graphics.draw(background_listagem_1)
        elseif qtd_pet == 2 then
            love.graphics.draw(background_listagem_2)
        elseif qtd_pet == 3 then
            love.graphics.draw(background_listagem_3)
        else
            love.graphics.draw(background_listagem_4)
        end
        
        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", x, y+200, w, h, border_radius)
        
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("CADASTRAR NOVO PET", lt_x_b, y_b)

        --love.graphics.setColor(255, 0, 0)
        love.graphics.polygon("fill", 5, 575, 40, 595, 40, 555)
    end 
    if ACTUAL_SCREEN == "CADASTRO_PET_SCREEN" then
        love.graphics.draw(background_cadastro_pets)
        suit.draw()

        if pet1 == true then
            love.graphics.draw(pet_amarelo_feliz, 0, 270)
            love.graphics.draw(pet_roxo, 200, 270)
        else
            love.graphics.draw(pet_amarelo, 0, 270)
            love.graphics.draw(pet_roxo_feliz, 200, 270)
        end

        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", x, y+300, w, h, border_radius)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print("CADASTRAR", cs_x_b, cp_y_b)

        --love.graphics.setColor(255, 0, 0)
        love.graphics.polygon("fill", 5, 575, 40, 595, 40, 555)
    end
    if ACTUAL_SCREEN == "PET_SCREEN" then
        if light == true then
            love.graphics.draw(background_pets)
        elseif light == false then
            love.graphics.draw(background_pets_dark)
        end

        if pet_atual["atual_state"] == "STATE_NORMAL" then
            if pet_atual["skin"] == 1 then
                love.graphics.draw(pet_amarelo_feliz, 135, 200)
            elseif pet_atual["skin"] == 2 then
                love.graphics.draw(pet_roxo_feliz, 135, 200)
            end
        elseif pet_atual["atual_state"] == "STATE_SLEEP" then
            if pet_atual["skin"] == 1 then
                love.graphics.draw(pet_amarelo_dormindo, 135, 200)
            elseif pet_atual["skin"] == 2 then
                love.graphics.draw(pet_roxo_dormindo, 135, 200)
            end
        elseif pet_atual["atual_state"] == "STATE_DEAD" then
            if pet_atual["skin"] == 1 then
                love.graphics.draw(pet_amarelo_morto, 135, 200)
            elseif pet_atual["skin"] == 2 then
                love.graphics.draw(pet_roxo_morto, 135, 200)
            end
        elseif pet_atual["atual_state"] == "STATE_SICK" then
            if pet_atual["skin"] == 1 then
                love.graphics.draw(pet_amarelo_doente, 135, 200)
            elseif pet_atual["skin"] == 2 then
                love.graphics.draw(pet_roxo_doente, 135, 200)
            end
        elseif pet_atual["atual_state"] == "STATE_HUNGRY" then
            if pet_atual["skin"] == 1 then
                love.graphics.draw(pet_amarelo_fome, 135, 200)
            elseif pet_atual["skin"] == 2 then
                love.graphics.draw(pet_roxo_fome, 135, 200)
            end
        elseif pet_atual["atual_state"] == "STATE_CLEAN" then
            if pet_atual["skin"] == 1 then
                love.graphics.draw(pet_amarelo_sujo, 135, 200)
            elseif pet_atual["skin"] == 2 then
                love.graphics.draw(pet_roxo_sujo, 135, 200)
            end
        elseif pet_atual["atual_state"] == "STATE_TIRED" then
            if pet_atual["skin"] == 1 then
                love.graphics.draw(pet_amarelo_sono, 135, 200)
            elseif pet_atual["skin"] == 2 then
                love.graphics.draw(pet_roxo_sono, 135, 200)
            end
        end

        love.graphics.setFont(default)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(pet_atual["nome"], 91, 52)
        
        love.graphics.setFont(norm)
        love.graphics.print(math.ceil(pet_atual["helthy"]) .. "%", 40, 157)
        love.graphics.print(math.ceil(pet_atual["happiness"]) .. "%", 40, 210)
        love.graphics.print(math.ceil(pet_atual["hungry"]) .. "%", 40, 273)
        love.graphics.print(math.ceil(pet_atual["sleep"]) .. "%", 40, 333)
        love.graphics.print(math.ceil(pet_atual["clean"]) .. "%", 40, 393)

        love.graphics.setColor(255, 255, 255)
        love.graphics.polygon("fill", 5, 465, 40, 485, 40, 445)

        if dead == false then
            motor_jogo()
        end
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


function verifica_estado()
    if state_pet == 0 then
        if (pet_atual["helthy"] < pet_atual["happiness"]) and (pet_atual["helthy"] < pet_atual["hungry"]) and (pet_atual["helthy"] < pet_atual["clean"]) and pet_atual["helthy"] < 50 then
            pet_atual["atual_state"] = "STATE_SICK"
        elseif (pet_atual["happiness"] < pet_atual["helthy"]) and (pet_atual["happiness"] < pet_atual["hungry"]) and (pet_atual["happiness"] < pet_atual["clean"]) and pet_atual["happiness"] < 50 then
            pet_atual["atual_state"] = "STATE_NORMAL"
        elseif (pet_atual["hungry"] < pet_atual["helthy"]) and (pet_atual["hungry"] < pet_atual["happiness"]) and (pet_atual["hungry"] < pet_atual["clean"]) and pet_atual["hungry"] < 50 then
            pet_atual["atual_state"] = "STATE_HUNGRY"
        elseif (pet_atual["clean"] < pet_atual["helthy"]) and (pet_atual["clean"] < pet_atual["hungry"]) and (pet_atual["clean"] < pet_atual["happiness"]) and pet_atual["clean"] < 50 then
            pet_atual["atual_state"] = "STATE_CLEAN"
        elseif (pet_atual["sleep"] < pet_atual["helthy"]) and (pet_atual["sleep"] < pet_atual["hungry"]) and (pet_atual["sleep"] < pet_atual["happiness"]) and pet_atual["sleep"] < 50 then
            pet_atual["atual_state"] = "STATE_TIRED"
        end
        state_pet = 200
    else
        state_pet = state_pet - 1
    end
end

--** Motor do jogo Acesso
function motor_jogo()
    pet_atual["helthy"] = ((pet_atual["helthy"] - healthRate) <= 0 and 0 or (pet_atual["helthy"] - healthRate))
    pet_atual["happiness"] = ((pet_atual["happiness"] - happyRate) <= 0 and 0 or (pet_atual["happiness"] - happyRate))
    pet_atual["hungry"] = ((pet_atual["hungry"] - hungerRate) <= 0 and 0 or (pet_atual["hungry"] - hungerRate))
    pet_atual["clean"] = ((pet_atual["clean"] - cleanRate) <= 0 and 0 or (pet_atual["clean"] - cleanRate))
    
    if light == true then
        pet_atual["sleep"] = ((pet_atual["sleep"] - sleepRate) <= 0 and 0 or (pet_atual["sleep"] - sleepRate))
    elseif light == false then
        pet_atual["sleep"] = ((pet_atual["sleep"] + sleepRate) >= 100 and 100 or (pet_atual["sleep"] + sleepRate))
    end
    
    if pet_atual["helthy"] == 0 or pet_atual["happiness"] == 0 or pet_atual["hungry"] == 0 or pet_atual["sleep"] == 0 or pet_atual["clean"] == 0 then
        pet_atual["atual_state"] = "STATE_DEAD"
        dead = true
    end

    verifica_estado()
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

--** Pego o *index* pet do usuario
function get_user_pet_by_index(T, index)
    local flag = 0

    for k, data in ipairs(T) do
        if data["user_id"] == usuario_logado["id"] then
            if flag == index then
                actual_user_pet["id"] = data["id"]
                actual_user_pet["user_id"] = data["user_id"]
                actual_user_pet["pet_id"] = data["pet_id"]
                return data["pet_id"]
            end
            flag = flag + 1
        end
    end

    return false
end

--** Faz o GET USUARIO
function get_users()
    local ok = http.request {
        method = "GET",
        url = "http://localhost:3000/users.json",
        sink = collect
    }

    data = JSON:decode(data)
end

--** Faz o GET PETS
function get_pets()
    local ok = http.request {
        method = "GET",
        url = "http://localhost:3000/pets.json",
        sink = collect
    }

    data = JSON:decode(data)
end

--** Faz o GET de um PET
function get_pet(id)
    local ok = http.request {
        method = "GET",
        url = "http://localhost:3000/pets/" .. id .. ".json",
        sink = collect
    }

    pet_atual = JSON:decode(data)
end

--** Faz o GET USERS_PET
function get_user_pets()
    local ok = http.request {
        method = "GET",
        url = "http://localhost:3000/user_pets.json",
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

--** Função login
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

--** Função que cadastra um novo pet
function cadastrar_pet()
    get_pets()
    
    pet = {}
    pet["nome"] = form_nome_pet["text"]
    pet["skin"] = 1

    if pet1 == false then
        pet["skin"] = 2
    end

    local payload = JSON:encode(pet)
    local response_body = { }

    local res, code, response_headers, status = http.request
    {
      url = "http://localhost:3000/pets.json",
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

    att = att + 1

    user_pet = {}
    user_pet["user_id"] = usuario_logado["id"]
    user_pet["pet_id"] = att

    local payload = JSON:encode(user_pet)
    local response_body = { }

    local res, code, response_headers, status = http.request
    {
      url = "http://localhost:3000/user_pets.json",
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

function update_qtd_pet()
    get_user_pets()

    local qtd = 0

    for k, pets in ipairs(data) do
        if pets["user_id"] == usuario_logado["id"] then
            qtd = qtd + 1
        end
    end

    if qtd > qtd_pet or qtd < qtd_pet then
        qtd_pet = qtd
    end
end
--** Funcao que pega o pet
function pega_pet(index)
    --** Pego o pet numero *index* do usuario
    get_user_pets()

    local id = get_user_pet_by_index(data, index)

    if id ~= false then
        get_pet(id)
        if pet_atual["atual_state"] == "STATE_DEAD" then
            dead = true 
        else
            dead = false
        end
        if pet_atual["atual_state"] == "STATE_SLEEP" then
            sleep = true
        else
            sleep = false
        end
        return true
    end

    return false
end

--** funcao que deleta o pet
function delete_pet()
    local payload = JSON:encode(actual_user_pet)
    local response_body = { }

    local res, code, response_headers, status = http.request
    {
      url = "http://localhost:3000/user_pets/" .. actual_user_pet["id"] .. ".json",
      method = "DELETE",
      headers =
      {
        ["Authorization"] = "Maybe you need an Authorization header?",
        ["Content-Type"] = "application/json",
        ["Content-Length"] = payload:len()
      },
      source = ltn12.source.string(payload),
      sink = ltn12.sink.table(response_body)
    }
    
    if code ~= 204 then
        return false
    end

    local payload = JSON:encode(pet_atual)
    local response_body = { }

    local res, code, response_headers, status = http.request
    {
      url = "http://localhost:3000/pets/" .. pet_atual["id"] .. ".json",
      method = "DELETE",
      headers =
      {
        ["Authorization"] = "Maybe you need an Authorization header?",
        ["Content-Type"] = "application/json",
        ["Content-Length"] = payload:len()
      },
      source = ltn12.source.string(payload),
      sink = ltn12.sink.table(response_body)
    }

    if code ~= 204 then
        return false
    end

    return true
end

--** funcao que seta o rating
function seting_rating(flag)
    if flag == 1 then
        healthRate =  0.05
        happyRate = 0.07
        hungerRate = 0.09
        sleepRate = 0.075
        cleanRate = 0.025    
    elseif flag == 2 then
        healthRate =  0.1
        happyRate = 0.14
        hungerRate = 0.18
        sleepRate = 0.4
        cleanRate = 0.05
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
            login_user["text"] = ""
            password_user["text"] = ""
            ACTUAL_SCREEN = "CADASTRO_USUARIO_SCREEN"
        end
    --** Se estiver na tela de cadastro
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
            form_login_user["text"] = ""
            form_password_user["text"] = ""
            ACTUAL_SCREEN = "LOGGIN_SCREEN"
        end
    
    --** Se estiver na tela de listagem
    elseif ACTUAL_SCREEN == "LISTAGEM_SCREEN" then
        if x >= button_x and x <= button_x + button_width and y >= button_y and y <= button_y + button_height then
            if qtd_pet <= 3 then
                ACTUAL_SCREEN = "CADASTRO_PET_SCREEN"
            end
        end

        if x >= 5 and x <= 40 and y >= 560 and y <= 600 then
            login_user["text"] = ""
            password_user["text"] = ""
            ACTUAL_SCREEN = "LOGGIN_SCREEN"
        end

        if x >= 79 and x <= 180 and y >= 150 and y <= 250 then
            if qtd_pet > 0 then
                if pega_pet(0) == true then
                    ACTUAL_SCREEN = "PET_SCREEN"
                end
            end
        end

        if x >= 219 and x <= 320 and y >= 150 and y <= 250 then
            if qtd_pet > 1 then
                if pega_pet(1) == true then
                    ACTUAL_SCREEN = "PET_SCREEN"
                end
            end
        end

        if x >= 79 and x <= 180 and y >= 279 and y <= 379 then
            if qtd_pet > 2 then
                if pega_pet(2) == true then
                    ACTUAL_SCREEN = "PET_SCREEN"
                end
            end
        end

        if x >= 219 and x <= 320 and y >= 279 and y <= 379 then
            if qtd_pet > 3 then
                if pega_pet(3) == true then
                    ACTUAL_SCREEN = "PET_SCREEN"
                end
            end
        end
    --** Se estiver na tela de cadastro de pet
    elseif ACTUAL_SCREEN == "CADASTRO_PET_SCREEN" then
        if x >= 0 and x <= 200 and y >= 270 and y <= 270 + 200 then
            pet1 = true
        end
        if x >= 200 and x <= 400 and y >= 270 and y <= 270 + 200 then
            pet1 = false
        end
        if x >= 75 and x <= 75 + w and y >= 500 and y <= 500 + h then
            if form_nome_pet["text"] ~= "" then
                if cadastrar_pet() == true then
                    form_nome_pet["text"] = ""
                    pet1 = true
                    ACTUAL_SCREEN = "LISTAGEM_SCREEN"
                else
                    form_nome_pet["text"] = "ERRO!"
                end
            else
                form_nome_pet["text"] = "ERRO!"
            end
        end
        if x >= 5 and x <= 40 and y >= 560 and y <= 600 then
            form_nome_pet["text"] = ""
            pet1 = true
            ACTUAL_SCREEN = "LISTAGEM_SCREEN"
        end
    --** Se estiver na tela do pet
    elseif ACTUAL_SCREEN == "PET_SCREEN" then
        if x >= 5 and x <= 40 and y >= 435 and y <= 470 then
            seting_rating(1)
            light = true
            dead = false 
            ACTUAL_SCREEN = "LISTAGEM_SCREEN"
        end
        --** EXCLUIR
        if  x >= 376 and x <= (376 + 23) and y >= 4 and y <= (4 + 20) then
            if delete_pet() == true then
                update_qtd_pet()
                ACTUAL_SCREEN = "LISTAGEM_SCREEN"
            end
        end
        if dead == false then
            --** COMER
            if x >= 6 and x <= (6 + 69) and y >= 512 and y <= (512 + 70) then
                if light == true then
                    if pet_atual["hungry"] <= 75 then
                        pet_atual["helthy"] = ((pet_atual["helthy"] + 1) >= 100 and 100 or (pet_atual["helthy"] + 1))
                        pet_atual["happiness"] = ((pet_atual["happiness"] + 10) >= 100 and 100 or (pet_atual["happiness"] + 10))
                        pet_atual["hungry"] = ((pet_atual["hungry"] + 15)  >= 100 and 100 or (pet_atual["hungry"] + 15))
                        pet_atual["clean"] = pet_atual["clean"] - 15
                    elseif pet_atual["hungry"] >= 100 then
                        pet_atual["helthy"] = pet_atual["helthy"] - 1
                        pet_atual["hungry"] = 100
                    else
                        pet_atual["hungry"] = ((pet_atual["hungry"] + 15)  >= 100 and 100 or (pet_atual["hungry"] + 15))
                    end
                end
            end
            --** LAVAR
            if x >= 86 and x <= (86 + 69) and y >= 512 and y <= (512 + 70) then
                if light == true then
                    if pet_atual["clean"] < 75 then
                        pet_atual["helthy"] = ((pet_atual["helthy"] + 20) >= 100 and 100 or (pet_atual["helthy"] + 40))
                        pet_atual["happiness"] = ((pet_atual["happiness"] + 10) >= 100 and 100 or (pet_atual["happiness"] + 10))
                        pet_atual["hungry"] = pet_atual["hungry"] - 5 
                        pet_atual["clean"] = 100
                        pet_atual["sleep"] = pet_atual["sleep"] - 3
                    elseif pet_atual["clean"] >= 100 then
                        pet_atual["clean"] = 100
                        pet_atual["sleep"] = pet_atual["sleep"] - 3
                        pet_atual["hungry"] = pet_atual["hungry"] - 5 
                    else
                        pet_atual["clean"] = ((pet_atual["clean"] + 1) >= 100 and 100 or (pet_atual["clean"] + 1))
                    end
                end
            end
            --** VACINAR
            if x >= 164 and x <= (164 + 69) and y >= 512 and y <= (512 + 70) then
                if light == true then
                    if pet_atual["helthy"] <= 50 then
                        pet_atual["helthy"] = ((pet_atual["helthy"] + 40) >= 100 and 100 or (pet_atual["helthy"] + 40))
                        pet_atual["happiness"] = pet_atual["happiness"] - 15
                        pet_atual["hungry"] = pet_atual["hungry"] - 5 
                        pet_atual["clean"] = pet_atual["clean"] - 10
                        pet_atual["sleep"] = pet_atual["sleep"] - 3
                    elseif pet_atual["helthy"] >= 100 then
                        pet_atual["helthy"] = 100
                        pet_atual["sleep"] = pet_atual["sleep"] - 5
                    else
                        pet_atual["helthy"] = ((pet_atual["helthy"] + 40) >= 100 and 100 or (pet_atual["helthy"] + 40))
                    end
                end
            end
            --** BRINCAR
            if x >= 247 and x <= (247 + 69) and y >= 512 and y <= (512 + 70) then
                if light == true then
                    if pet_atual["happiness"] <= 75 then
                        pet_atual["helthy"] = ((pet_atual["helthy"] + 1) >= 100 and 100 or (pet_atual["helthy"] + 1))
                        pet_atual["happiness"] = ((pet_atual["happiness"] + 15) >= 100 and 100 or (pet_atual["happiness"] + 15))
                        pet_atual["hungry"] = pet_atual["hungry"] - 5 
                        pet_atual["clean"] = pet_atual["clean"] - 15
                        pet_atual["sleep"] = pet_atual["sleep"] - 3
                    elseif pet_atual["happiness"] >= 100 then
                        pet_atual["hungry"] = pet_atual["hungry"] - 5 
                        pet_atual["clean"] = pet_atual["clean"] - 15
                        pet_atual["sleep"] = pet_atual["sleep"] - 3
                        pet_atual["happiness"] = 100
                    else
                        pet_atual["happiness"] = ((pet_atual["happiness"] + 1) >= 100 and 100 or (pet_atual["happiness"] + 1))
                    end
                end
            end
            --** DORMIR
            if x >= 337 and x <= (337 + 69) and y >= 512 and y <= (512 + 70) then
                if light == true then
                    light = false
                    seting_rating(2)
                    pet_atual["atual_state"] = "STATE_SLEEP"
                    pet_atual["sleep"] = ((pet_atual["sleep"] + 15) >= 100 and 100 or (pet_atual["sleep"] + 1))
                elseif light == false then
                    light = true
                    seting_rating(1)
                    -- get estado atual pet
                    pet_atual["atual_state"] = "STATE_NORMAL"
                end

            end
        end
    end
end