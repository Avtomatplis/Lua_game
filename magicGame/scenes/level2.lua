local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
physics.start()
local music;
local count = 0
local life = 3
local player;
local livesText;
local scoreText;
local die;
local blue;
local yellow;
local heart;
local spawnBT;
local spawnDT;
local spawnYT;
local spawnHT;
local function MovePlayer(event)
    local player = event.target
    if(event.phase == "began") then
        display.currentStage:setFocus(player)
        player.touchOfsetX = event.x-player.x

    elseif(event.phase == "moved") then
        player.x = event.x-player.touchOfsetX
    elseif(event.phase == "ended" or "cancelled" == event.phase) then
        display.currentStage:setFocus(nil)
    end
    return true
end
local function sumCount()--blue
    count = count +1
    scoreText.text = "Score: " .. count
end
local function sumCountFive()--yellow
    count = count+5
    scoreText.text = "Score: " .. count
end
local function minLife()--die
    life = life -1
    livesText.text = "Lives: " .. life
end
local function sumLife()--pink
    life = life +1
    livesText.text = "Lives: " .. life
end
local function endGame()
	composer.setVariable( "finalScore", count )
	composer.gotoScene( "scenes.final", { time=100, effect="crossFade" } )
end

local function onCollision( event )
    if ( event.phase == "began" ) then
        local object1 = event.object1
        local object2 = event.object2
        if (object1.ID == "player" and object2.ID == "blue") then
            sumCount()
            display.remove(object2)
        end
        if (object1.ID == "player" and object2.ID == "heart") then
            sumLife()
            display.remove(object2)
        end
        if (object1.ID == "player" and object2.ID == "yellow") then
            sumCountFive()
            display.remove(object2)
        end
        if(object1.ID == "player" and object2.ID == "die")then
            minLife()
            display.remove(object2)
            if ( life == 0 ) then
                display.remove( player )
                timer.performWithDelay( 100, endGame )
            end
        end
    end
end
-- create()
function scene:create( event )
	local sceneGroup = self.view
    physics.pause()
    local background = display.newImageRect(sceneGroup,"img/phone2.jpg", 1400, 867);
    background.x = display.contentCenterX-250
    background.y = display.contentCenterY-70
    player = display.newImageRect(sceneGroup,"img/kotel.png", 120, 140);
    physics.addBody( player, { radius=40, isSensor=true } )
    player.x = display.contentCenterX
    player.y = display.contentHeight +30
    
    player.gravityScale = 0
	player.ID = "player"
    player:addEventListener( "touch", MovePlayer )
    livesText = display.newText( sceneGroup, "Lives: " .. life, 80, 0,"IdealGothicBold.otf", 30 )
	scoreText = display.newText( sceneGroup, "Score: " .. count, 230, 0, "IdealGothicBold.otf", 30 )
    music = audio.loadSound( "music/level2.mp3" )
    local function spawnDie()
        local die = display.newImageRect(sceneGroup,"img/die.png", 60, 80)
        die.x = math.random(10,210)
        die.y = -150
        die.ID = "die"
        physics.addBody(die, "dynamic", {radius = 20, isSensor = true})
        --return die
    end
    spawnDT = timer.performWithDelay(500,spawnDie, 0)
    
    -- спавн +1 очко
    local function spawnBlue()
        local blue = display.newImageRect(sceneGroup,"img/blue.png", 50,71)
        blue.x = math.random(10, 310)
        blue.y = -200
        blue.ID= "blue"
        physics.addBody(blue, "dynamic", {radius = 40, isSensor = true})
    end
    spawnBT = timer.performWithDelay(1000,spawnBlue,0)
    -- спавн +5 очков
    local function spawnYellow()
        local yellow = display.newImageRect(sceneGroup,"img/yellow.png", 54,80)
        yellow.x = math.random(10, 310)
        yellow.y = -200
        yellow.ID = "yellow"
        physics.addBody(yellow, "dynamic", {radius = 30, isSensor = true})
    end
    spawnYT = timer.performWithDelay(4500,spawnYellow, 0)
    -- спавн + жизнь
    local function spawnHeart()
        local heart = display.newImageRect(sceneGroup,"img/pink.png", 40,80)
        heart.x = math.random(10, 310)
        heart.y = -200
        heart.ID = "heart"
        physics.addBody(heart, "dynamic", {radius = 30, isSensor = true})
    end
    spawnHT = timer.performWithDelay(6000,spawnHeart, 0)
end
-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
        physics.start()
		Runtime:addEventListener( "collision", onCollision )
        audio.play( music,{channel = 1, loops = -1 })
	end
end
-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
        timer.cancel( spawnDT )
        timer.cancel( spawnBT )
        timer.cancel( spawnYT )
        timer.cancel( spawnHT )
	elseif ( phase == "did" ) then
        physics.stop()
        audio.stop(1)
        composer.removeScene( "scenes.level2" )
	end
end
-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
    audio.dispose(music);
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
