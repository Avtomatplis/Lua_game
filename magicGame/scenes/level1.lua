local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
physics.start()
local music;
local count = 0
local life = 3
local died = false
local player;
local livesText;
local scoreText;
local dementor;--500
local letter;--1000
local heart;--7000
local snitch;--5000
local spawnDemT;
local spawnLetT;
local spawnSnT;
local spawnHT;
local function updateText()
	livesText.text = "Lives: " .. life
	scoreText.text = "Score: " .. count
end
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
local function restorePlayer()
    player.isBodyActive = false
	player.x = display.contentCenterX
	player.y = display.contentHeight +30

	transition.to( player, { alpha=1, time=200,
		onComplete = function()
			player.isBodyActive = true
			died = false
		end
	} )
end
local function sumCount()--письмо
    count = count +1
    scoreText.text = "Score: " .. count
end
local function sumCountFive()--снитч
    count = count+5
    scoreText.text = "Score: " .. count
end
local function minLife()--дементор
    life = life -1
    livesText.text = "Lives: " .. life
end
local function sumLife()--жизнь
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
        if (object1.ID == "player" and object2.ID == "letter") then
            sumCount()
            display.remove(object2)
        end
        if (object1.ID == "player" and object2.ID == "heart") then
            sumLife()
            display.remove(object2)
        end
        if (object1.ID == "player" and object2.ID == "snitch") then
            sumCountFive()
            display.remove(object2)
        end
        if(object1.ID == "player" and object2.ID == "dementor")then
            if ( died == false ) then
				died = true
                minLife()
                display.remove(object2)
                if ( life == 0 ) then
                    display.remove( player )
                    timer.performWithDelay( 100, endGame )
                else
                    player.alpha = 0
                    timer.performWithDelay( 200, restorePlayer )
                end
            end
        end
    end
end
-- create()
function scene:create( event )
	local sceneGroup = self.view
    physics.pause()
    local background = display.newImageRect(sceneGroup,"img/phone1.jpg", 1000, 750);
    background.x = display.contentCenterX-50
    background.y = display.contentCenterY
    player = display.newImageRect(sceneGroup,"img/harry.png", 60, 170);
    physics.addBody( player, { radius=40, isSensor=true } )
    player.x = display.contentCenterX
    player.y = display.contentHeight +30
    player.gravityScale = 0
	player.ID = "player"
    player:addEventListener( "touch", MovePlayer )
	livesText = display.newText( sceneGroup, "Lives: " .. life, 80, 0,"IdealGothicBold.otf", 30 )
	scoreText = display.newText( sceneGroup, "Score: " .. count, 230, 0, "IdealGothicBold.otf", 30 )
    music = audio.loadSound( "music/level1.mp3" )
    local function spawnDementor()
        local dementor = display.newImageRect(sceneGroup,"img/dementor.png", 100, 70)
        dementor.x = math.random(10,310)
        dementor.y = -150
        --")
        dementor.ID = "dementor"
        physics.addBody(dementor, "dynamic", {radius = 20, isSensor = true})
        --return dementor
    end
    spawnDemT = timer.performWithDelay(500,spawnDementor, 0)
    
    -- спавн +1 очко
    local function spawnLetter()
        local letter = display.newImageRect(sceneGroup,"img/letter.png", 100,36)
        letter.x = math.random(10, 310)
        letter.y = -200
        letter.ID= "letter"
        physics.addBody(letter, "dynamic", {radius = 40, isSensor = true})
    end
    spawnLetT = timer.performWithDelay(1000,spawnLetter,0)
    -- спавн +5 очков
    local function spawnSnitch()
        local snitch = display.newImageRect(sceneGroup,"img/snitch.png", 70,70)
        snitch.x = math.random(10, 310)
        snitch.y = -200
        snitch.ID = "snitch"
        physics.addBody(snitch, "dynamic", {radius = 30, isSensor = true})
    end
    spawnSnT = timer.performWithDelay(5000,spawnSnitch, 0)
    -- спавн + жизнь
    local function spawnHeart()
        local heart = display.newImageRect(sceneGroup,"img/life.png", 60,60)
        heart.x = math.random(10, 310)
        heart.y = -200
        heart.ID = "heart"
        physics.addBody(heart, "dynamic", {radius = 30, isSensor = true})
    end
    spawnHT = timer.performWithDelay(7000,spawnHeart, 0)
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
        timer.cancel( spawnDemT )
        timer.cancel( spawnLetT )
        timer.cancel( spawnSnT )
        timer.cancel( spawnHT )
	elseif ( phase == "did" ) then
        physics.stop()
        audio.stop(1)
        composer.removeScene( "scenes.level1" )
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