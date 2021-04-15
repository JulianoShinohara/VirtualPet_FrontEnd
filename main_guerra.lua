
local anim8 = require 'anim8'

local image, animation

local STATE_NORMAL = 1
local STATE_SAD = 2
local STATE_SICK = 3
local STATE_HUNGRY = 4
local STATE_DEAD = 5
local STATE_TRIED = 5  --alterar para o index correto

local state = STATE_NORMAL

local happy = 100
local health = 100
local hunger = 100
local energy = 100

local happyRate = 1.4
local healthRate = 1
local hungerRate = 1.8
local energyRate = 1.5

local age = 0
local ageRate = 0.1

local dead = 0

local indexCall = 1;

local time = 0;

local clikedAction = 0


local load = {}

local sleeping = 0;

function love.load()

 exists = love.filesystem.exists("save.txt")
 
 if(exists == true)then    
   for line in love.filesystem.lines("save.txt") do
   	table.insert(load,line)
   end
   happy = load[1];
   hunger = load[2];
   health = load[3];
   newtime = love.timer.getTime() - load[4]
   age = load[5];
   energy = 100;
 end

 

 love.graphics.setFont(love.graphics.newFont(15))
  

  image = love.graphics.newImage('spritesheet1.png') --spritesheet contendo emoções do tamagotchi
  background = love.graphics.newImage('images.jpg') --imagem de fundo



  callmsg = {"","Não há ninguem doente", "AAAAAAAAAAAAAAAIIIIIIIIIIII", "AHHHH CARA QUE DELICIA", "IHAAAAAA", "Estou sem fome!", "morreu", "Não quero brincar!","ZZzzzZZZzzz", "Não estou com sono"}


 
  hungryIcon = love.graphics.newImage("hungry.png")
  happyIcon = love.graphics.newImage("happy.png")


  --definindo botões
  buttonPlay = love.graphics.newImage("playgame.png") -- botão de brincar
  buttonPlayX = 5; buttonPlayY = 355;

  buttonHealth = love.graphics.newImage("injection.png")
  buttonHealthX = 67; buttonHealthY = 355;

  buttonFood= love.graphics.newImage("food.png")
  buttonFoodX = 129; buttonFoodY = 355;

  buttonSleep= love.graphics.newImage("sleep.png")
  buttonSleepX = 191; buttonSleepY = 355;

  buttonReset= love.graphics.newImage("reset.png")
  buttonResetX = 75; buttonResetY = 360;

  buttonWake= love.graphics.newImage("wake.png")
  buttonWakeX = 75; buttonWakeY = 360;

  buttonExit = love.graphics.newImage("exit.png")
  buttonExitX = 210; buttonExitY = 10;
  

  local g = anim8.newGrid(32,32, image:getWidth(), image:getHeight())
  
  anims = {
    anim8.newAnimation(g('1-2',1), 0.1),
    anim8.newAnimation(g('3-4',1), 0.1),
    anim8.newAnimation(g('5-6',1), 0.1),
    anim8.newAnimation(g('7-8',1), 0.1),
    anim8.newAnimation(g('9-10',1), 0.1)
  }

  love.update(newtime)
end

function love.update(dt)
  if dt == NULL then
    dt = 0
  end

  if dead == 0 then
    age = age + ageRate * dt
  end

   if clickedAction == 9 then
   	dead = 0;
   	age = 0;
    happy = 100;
    hunger = 100;
    health = 100;
    energy = 100;
    state = STATE_NORMAL;
    indexCall = 1;
    clickedAction = 0;
  end

if clickedAction == 5 or sleeping == 1 then
    if energy < 80 then
      happy = happy + 1;
      hunger = hunger -1;
      health = health - 0.1;
      energy = energy + 20;
      indexCall = 9;
      sleeping = 1;

      if  energy > 100 then
        energy = 100;
      end 
    else 
      indexCall = 10;
    end
      time = 0;
      clickedAction = 0;     
end

  if clickedAction == 1 then
    if happy < 75 then
      happy = happy + 15;
      hunger = hunger - 5;
      energy = energy -3;
      indexCall = 5;    
      if happy > 100 then
        happy = 100;
      end 
    else 
      indexCall = 8;
    end
      time = 0;
     clickedAction = 0;
  end

  if clickedAction == 2 then
    if health < 50 then
      happy = happy - 10;
      health = health + 50;
      indexCall = 3;
      if health > 100 then
        health = 100;
      end
    else     
      indexCall = 2;
    end
      time = 0;
     clickedAction = 0;
  end

  if clickedAction == 3 then
    if hunger < 75 then
      hunger = hunger + 15;
      happy = happy + 1;
      health = health + 1;
      indexCall = 4;
      if hunger > 100 then
        hunger = 100;
      end
    else     
      indexCall = 6;
    end
      time = 0;
     clickedAction = 0;
  end


  if clickedAction == 4 then
    file = love.filesystem.newFile("save.txt")
    file:open("w");

    local timer = love.timer.getTime()
    
    love.filesystem.append("save.txt", happy);
    love.filesystem.append("save.txt", "\n");
    love.filesystem.append("save.txt", hunger);
    love.filesystem.append("save.txt", "\n");
    love.filesystem.append("save.txt", health);
    love.filesystem.append("save.txt", "\n");
    love.filesystem.append("save.txt", love.timer.getTime())
    love.filesystem.append("save.txt", "\n");
    love.filesystem.append("save.txt", age);
    love.filesystem.append("save.txt", "\n");
    love.filesystem.append("save.txt", energy);
    love.filesystem.append("save.txt", "\n");

    file:close();
    love.event.quit()
  end
  
  --
  -- máquina de estados do vpet
  --se o estado for normal atualização padrão
    if sleeping == 1 then
    	happ = happy;
    	health = health;
    	hunger = hunger;
    	energy = energy;
    else
    happy  = happy - happyRate * dt;
    health = health - healthRate * dt;
    hunger = hunger - hungerRate * dt;
    energy = energy - energyRate *dt;
	end
 

  --se o estado for triste, perde menos felicidade e mais saúde mais rapido
  	if state == STATE_SAD then
    	happyRate = 1.7
    	healthRate = 1.3   
  	end

  -- se o estado for doente, perde felicidade e saúde mais rápido, contanto diminui a tava de perda da fome
  	if state == STATE_SICK then
    	happyRate = 1.6
    	healthRate = 1.4
    	hungerRate = 1.2

 	end

  -- se o estado for faminto, perde felicidade e saúde mais rápido
  	if state == STATE_HUNGRY then
    	happyRate = 1.6
    	healthRate = 1.2
	end

	if state == STATE_TRIED then
    	happyRate = 1.6
    	healthRate = 1.3	     
  	end

	if state == STATE_DEAD then
    	happy  = 0;
    	health = 0;
    	hunger = 0;
    	energy = 0;
    	age = age;
    	dead = 1;
    end



if happy <= 0 or health <= 0 or hunger <= 0 or energy <= 0 then
	state = STATE_DEAD
	love.system.vibrate(1)		        
	elseif health < 25 then 
		state = STATE_SICK       
	elseif happy < 40 then 
		state = STATE_SAD
	elseif energy < 20 then 
		state = STATE_TRIED
	else
		state = STATE_NORMAL 
end


  anims[state]:update(dt)
end



function love.draw()
  love.graphics.draw(background, 0, 0)

  anims[state]:draw(image, love.graphics.getWidth()/2 - 80, love.graphics.getHeight()/2 - 80, 0, 5, 5)

	if sleeping == 1 then
		love.graphics.draw(buttonWake, buttonWakeX, buttonWakeY)
	  	function love.mousepressed(x, y, button)
	  		if button == 1 then
	  		if x >=  buttonWakeX and x <=  buttonWakeX+buttonWake:getWidth() and y >= buttonWakeY and y <= buttonWakeY+buttonWake:getHeight() then --Detect if the click was inside the buttonPlay
	   			sleeping = 0; --This is what triggers the pop-up image

			end
		end
		end
	else 

  if state == STATE_DEAD then
  	love.graphics.draw(buttonExit, buttonExitX, buttonExitY)
  	love.graphics.draw(buttonReset, buttonResetX, buttonResetY)

  	function love.mousepressed(x, y, button)
	  	if button == 1 then
	  		if x >=  buttonExitX and x <=  buttonExitX+buttonExit:getWidth() and y >= buttonExitY and y <= buttonExitY+buttonExit:getHeight() then --Detect if the click was inside the buttonPlay
	       		clickedAction = 4; --This is what triggers the pop-up image
	      	end
	      	if x >=  buttonResetX and x <=  buttonResetX+buttonReset:getWidth() and y >= buttonResetY and y <= buttonResetY+buttonReset:getHeight() then --Detect if the click was inside the buttonPlay
	       		clickedAction = 9; --This is what triggers the pop-up image
	      	end
	    end
	end
  else
  love.graphics.draw(buttonPlay, buttonPlayX, buttonPlayY)
  love.graphics.draw(buttonHealth, buttonHealthX, buttonHealthY)
  love.graphics.draw(buttonFood, buttonFoodX, buttonFoodY)
  love.graphics.draw(buttonExit, buttonExitX, buttonExitY)
  love.graphics.draw(buttonSleep, buttonSleepX, buttonSleepY)

  function love.mousepressed(x, y, button)
    if button == 1 then --Left click
      if x >=  buttonPlayX and x <=  buttonPlayX+buttonPlay:getWidth() and y >= buttonPlayY and y <= buttonPlayY+buttonPlay:getHeight() then --Detect if the click was inside the buttonPlay
       clickedAction = 1; --This is what triggers the pop-up image  
      end

      if x >=  buttonHealthX and x <=  buttonHealthX+buttonHealth:getWidth() and y >= buttonHealthY and y <= buttonHealthY+buttonHealth:getHeight() then --Detect if the click was inside the buttonPlay
       clickedAction = 2; --This is what triggers the pop-up image
      end

      if x >=  buttonFoodX and x <=  buttonFoodX+buttonFood:getWidth() and y >= buttonFoodY and y <= buttonFoodY+buttonFood:getHeight() then --Detect if the click was inside the buttonPlay
       clickedAction = 3; --This is what triggers the pop-up image
      end
      if x >=  buttonExitX and x <=  buttonExitX+buttonExit:getWidth() and y >= buttonExitY and y <= buttonExitY+buttonExit:getHeight() then --Detect if the click was inside the buttonPlay
       clickedAction = 4; --This is what triggers the pop-up image
      end
       if x >=  buttonSleepX and x <=  buttonSleepX+buttonSleep:getWidth() and y >= buttonSleepY and y <= buttonSleepY+buttonSleep:getHeight() then --Detect if the click was inside the buttonPlay
       	clickedAction = 5; --This is what triggers the pop-up image
   		
      end
    end
  end
end
end



  if dead == 1 then 
    indexCall = 7;
  end
  love.graphics.setColor(255, 0, 0)
  love.graphics.print(callmsg[indexCall],50, 80) 

  time = time + 1;
  if time == 50 then
    indexCall = 1;
    time = 0;
  end
  

  if sleeping == 0 then
  love.graphics.setColor(255, 0, 0)
  love.graphics.print(math.floor(health), 28, 19)  
  
  love.graphics.print(math.floor(happy),77, 19)
  
  love.graphics.print(math.floor(hunger),128, 19)

  love.graphics.print(math.floor(energy),173, 19)
  
  love.graphics.print(math.floor(age), 5, 50)
  love.graphics.setColor(255, 255, 255)
	else

	love.graphics.setColor(255, 0, 0)
  love.graphics.print(math.floor(health), 28, 19)  
  
  love.graphics.print(math.floor(happy),77, 19)
  
  love.graphics.print(math.floor(hunger),128, 19)

  love.graphics.print(math.floor(energy),173, 19)
  
  love.graphics.print(math.floor(age), 5, 50)
  love.graphics.setColor(50, 50, 50)

end
end

