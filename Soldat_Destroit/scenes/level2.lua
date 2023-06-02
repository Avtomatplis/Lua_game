local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.start()

local music
local count = 0
local life = 3
local player
local livesText
local scoreText
local bullet2
local enemyGroup
local bulletsGroup
local bullet2Group
local shootTimer
local enemyTimer
local gameEnded = false
local backgroundMusic2;
local flickerTime = 300 -- Время мерцания в миллисекундах
local flickerTimer
local isPlayerFlickering = false
backgroundMusic2 = audio.loadSound( "music/vistrel.mp3" )
music = audio.loadStream("music/level1.mp3")
local vragvistrel = audio.loadSound("music/vistrelvrag.mp3")
local raneni = audio.loadSound("music/raneniplay.mp3")
local Destroit = audio.loadSound("music/DestroitVrag.mp3")
local function MovePlayer(event)
    local player = event.target
    if (event.phase == "began") then
        display.currentStage:setFocus(player)
        player.touchOffsetX = event.x - player.x
    elseif (event.phase == "moved") then
        local newX = event.x - player.touchOffsetX
        
        -- Ограничиваем движение игрока за левую границу экрана
        if newX < player.width * 0.1 then
            player.x = player.width * 0.1
        elseif newX > display.contentWidth - player.width * 0.3 then
            player.x = display.contentWidth - player.width * 0.3
        else
            player.x = newX
        end
    elseif (event.phase == "ended" or event.phase == "cancelled") then
        display.currentStage:setFocus(nil)
    end
    return true
end

local enemiesKilled = 0  -- Переменная для отслеживания количества убитых врагов
local function playGunshotSound()
    audio.play(backgroundMusic2)
end
local function Shoot()
    local bullet = display.newRect(bulletsGroup, player.x + 25, player.y - 40, 30, 30)
    playGunshotSound()
    physics.addBody(bullet, "dynamic", { isSensor = true })
    bullet.gravityScale = 0
    bullet:setLinearVelocity(0, -500)
    bullet.fill = { type = "image", filename = "img/puly.png" }
    bullet.ID = "bullet"
end
local function playGunshotvragSound()
    audio.play(vragvistrel)
end
local function SpawnEnemy()
    local y = math.random(-20, 30)
    local x = math.random(10, 280)
   local enemy = display.newRect(enemyGroup, x + 5, y, 60, 60)
    physics.addBody(enemy, "dynamic", { radius = 5 })
    enemy.gravityScale = 0
    enemy:setLinearVelocity(0, 50)
    enemy.fill = { type = "image", filename = "img/враг.png" }
    enemy.ID = "enemy"
    local function EnemyShoot()
        if not gameEnded then
            if(enemy.x ~= nil and enemy.y ~=nil) then
            bullet2 = display.newRect(bullet2Group, enemy.x, enemy.y, 30, 30)
            playGunshotvragSound()
            physics.addBody(bullet2, "dynamic", { isSensor = true })
            bullet2.gravityScale = 0
            bullet2:setLinearVelocity(0, math.random(200, 300))
            bullet2.fill = { type = "image", filename = "img/пуля врага.png" }
            bullet2.ID = "enemyBullet"
            --print("ок")
            end
        end
    end
    timer.performWithDelay(2000, EnemyShoot,0) -- Первый выстрел
end

local function restorePlayer()
    player.isBodyActive = false

	transition.to( player, { alpha=1, time=200,
		onComplete = function()
			player.isBodyActive = true
			died = false
		end
	} )
end
local function playGunshotRaneni()
    audio.play(raneni)
end
local function playGunshotDestroit()
    audio.play(Destroit)
end
local function onCollision(event)
    if event.phase == "began" then
        local object1 = event.object1
        local object2 = event.object2
        
        if (object1.ID == "player" and object2.ID == "enemyBullet") or
            (object1.ID == "enemyBullet" and object2.ID == "player") then
                player.alpha = 0
                playGunshotRaneni()
            life = life - 1
            livesText.text = "Lives: " .. life
            player.alpha = 0
                    timer.performWithDelay( 200, restorePlayer )
                object1:removeSelf()
            if life == 0 then
                enemiesKilled=0
                gameEnded = true
                enemyGroup = nil
                bulletsGroup = nil
                bullet2Group:removeSelf()
                life=3
                timer.performWithDelay(0, function()
                    composer.setVariable("finalScore", count)
                    composer.gotoScene("scenes.final", { time = 300, effect = "crossFade" })
                end)
            end
        elseif (object1.ID == "bullet" and object2.ID == "enemy") or
            (object1.ID == "enemy" and object2.ID == "bullet") then
                playGunshotDestroit()
                object1:removeSelf()
                object2:removeSelf()
            enemiesKilled = enemiesKilled + 1
            scoreText.text = "Killed: " .. enemiesKilled.."/20"
            if enemiesKilled >= 20 then  -- Проверяем, достигнуто ли необходимое количество убитых врагов
                enemiesKilled=0
                gameEnded = true
                enemyGroup = nil
                bulletsGroup = nil
                bullet2Group:removeSelf()
                life=3
                audio.stop(10)
                timer.performWithDelay(0, function()
                    composer.setVariable("finalScore", count)
                    composer.gotoScene("scenes.finalwin", { time = 300, effect = "crossFade" })
                end)
            end
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view
    physics.pause()

    local background = display.newImageRect(sceneGroup, "img/phone2.jpg", 1400, 867)
    background.x = display.contentCenterX - 250
    background.y = display.contentCenterY - 70

    player = display.newImageRect(sceneGroup, "img/soldat.png", 100, 140)
    physics.addBody(player, { radius = 30, isSensor = true })
    player.x = display.contentCenterX
    player.y = display.contentHeight + 30
    player.gravityScale = 0
    player.ID = "player"
    player:addEventListener("touch", MovePlayer)

    livesText = display.newText(sceneGroup, "Lives: " .. life, 55, -20, "IdealGothicBold.otf", 30)
    livesText:setFillColor(1,0,0,1)
    scoreText = display.newText(sceneGroup, "Killed: " .. count.."/20", 245, -20, "IdealGothicBold.otf", 29)
    scoreText:setFillColor(1,0,0,1)
    enemyGroup = display.newGroup()
    bulletsGroup = display.newGroup()
    bullet2Group=display.newGroup()
    sceneGroup:insert(enemyGroup)
    sceneGroup:insert(bulletsGroup)
    sceneGroup:insert(bullet2Group)
    shootTimer = timer.performWithDelay(2000, Shoot, 0)
    enemyTimer = timer.performWithDelay(2200, SpawnEnemy, 0)
end
local function removeOutOfBoundsObjects()--уничтожение объектов
    if(enemyGroup ~= nil) then
    for i = enemyGroup.numChildren, 1, -1 do
     enemy = enemyGroup[i]
        if enemy.y > display.contentHeight + enemy.height then
            enemy:removeSelf()
        end
    end

    for i = bulletsGroup.numChildren, 1, -1 do
        local bullet = bulletsGroup[i]
        if bullet.y < -bullet.height then
            bullet:removeSelf()
        end
    end

    for i = bullet2Group.numChildren, 1, -1 do
        local bullet2 = bullet2Group[i]
        if bullet2.y > display.contentHeight + bullet2.height+60 then
            bullet2:removeSelf()
        end
    end
end
end
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "did" then
        physics.start()
        Runtime:addEventListener("collision", onCollision)
        audio.play(music, { channel = 10, loops = -1 })
        Runtime:addEventListener("enterFrame", removeOutOfBoundsObjects)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
        timer.cancel(shootTimer)
        timer.cancel(enemyTimer)
       -- timer.cancel(secondShootTimer)
        display.remove(enemyGroup)
        display.remove(bulletsGroup)
        display.remove(bullet2Group)
        audio.stop(10)
        music=nil
        audio.dispose(music)
    elseif phase == "did" then
        Runtime:removeEventListener("collision",onCollision)
        physics.stop()
        audio.stop(1)
        audio.dispose(music)
        composer.removeScene("scenes.level2")
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
    audio.dispose(music)
    audio.dispose(backgroundMusic2);
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
