local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.start()

local music
local count = 0
local life = 5
local player
local livesText
local scoreText
local bullet2
local isEventListener=true
local hill
local livessuper=3
local enemyGroup
local hillGroup
--local healthBar
local bulletsGroup
local bullet2Group
local supersoldatGroup
local hitpointGroup
local shootTimer
local hilltimer
local enemyTimer
local bulletsuper
local bulletsSuperGroup
local supersoldattimer
local gameEnded = false
local backgroundMusic2;
local flickerTime = 300 -- Время мерцания в миллисекундах
local flickerTimer
local isPlayerFlickering = false
backgroundMusic2 = audio.loadSound( "music/newvistrelplayer.mp3" )
music = audio.loadStream("music/level2fon.mp3")
local vragvistrel = audio.loadSound("music/vistrelvrag.mp3")
local raneni = audio.loadSound("music/raneniplay.mp3")
local Destroit = audio.loadSound("music/DestroitVrag.mp3")
local hillplayer=audio.loadSound("music/musikhill.mp3")
local supervistrel=audio.loadSound("music/vistrelsuper.mp3")
local DeathSuperSoldat=audio.loadSound("music/DeathSuperSoldat.mp3")

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
    local bullet = display.newRect(bulletsGroup, player.x + 25, player.y - 40, 40,40)
    playGunshotSound()
    physics.addBody(bullet, "dynamic", { isSensor = true })
    bullet.gravityScale = 0
    bullet:setLinearVelocity(0, -500)
    bullet.fill = { type = "image", filename = "img/newpuliplayer.png" }
    bullet.ID = "bullet"
end
local function playGunshotvragSound()
    audio.play(vragvistrel)
end
local function playSuperVistrelPlayer()
    audio.play(supervistrel)
    audio.setVolume( 1 )
end
local function playDeathSuperSoldat()
    audio.play(DeathSuperSoldat)
    audio.setVolume(1)
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
            end
        end
    end
    timer.performWithDelay(2000, EnemyShoot,0) -- Первый выстрел
end

local function updateHealthBar(soldat)
    local healthRatio = soldat.lives / 3
    local healthBarWidth = 50
    soldat.healthBar.width = healthBarWidth * healthRatio
    print( soldat.healthBar.width)
end

local function SpawnSuperSoldat()
    local y = math.random(-20, 10)
    local x = math.random(10, 250)
   local supersoldat = display.newRect(supersoldatGroup, x + 5, y, 70, 80)
    physics.addBody(supersoldat, "dynamic", { radius = 15,  isSensor = true  })
    supersoldat.gravityScale = 0
    supersoldat:setLinearVelocity(0, 30)
    supersoldat.fill = { type = "image", filename = "img/SuperSoldat.png" }
    supersoldat.ID = "supersoldat"
    supersoldat.lives=3
    local healthBarWidth = 50
    local healthBarHeight = 5
    local healthBarBackground = display.newRect(hitpointGroup, supersoldat.x, supersoldat.y + 50, healthBarWidth, healthBarHeight)
    healthBarBackground:setFillColor(0.5, 0.5, 0.5)
    local healthBar = display.newRect(hitpointGroup, supersoldat.x, supersoldat.y + 50, healthBarWidth, healthBarHeight)
    healthBar:setFillColor(0, 1, 0)
    physics.addBody(healthBarBackground, "dynamic", { isSensor = true  })
    physics.addBody(healthBar, "dynamic", {  isSensor = true  })
    healthBarBackground.gravityScale = 0
    healthBar.gravityScale=0
    healthBarBackground:setLinearVelocity(0, 30)
    healthBar:setLinearVelocity(0,30)
    supersoldat.healthBar=healthBar
    supersoldat.healthBarBackground=healthBarBackground
    local function EnemySuperShoot()
        if not gameEnded then
            if(supersoldat.x ~= nil and supersoldat.y ~=nil) then
            bulletsuper = display.newRect(bulletsSuperGroup, supersoldat.x, supersoldat.y, 40, 40)
            playSuperVistrelPlayer()
            physics.addBody(bulletsuper, "dynamic", { isSensor = true })
            bulletsuper.gravityScale = 0
            bulletsuper:setLinearVelocity(0, math.random(200, 300))
            bulletsuper.fill = { type = "image", filename = "img/superpyli.png" }
            bulletsuper.ID = "superBullet"
            end
        end
    end
    timer.performWithDelay(4000, EnemySuperShoot,0) -- Первый выстрел
    -- secondShootTimer = timer.performWithDelay(math.random(4000,6000), EnemyShoot) -- Второй выстрел через 1 секунду

end

local function SpawnHeal()
    local y = math.random(-20, 30)
    local x = math.random(10, 280)
    local healthPack = display.newRect(hillGroup, x + 5, y, 40, 40)
    physics.addBody(healthPack, "dynamic", { isSensor = true })
    healthPack.gravityScale = 0
    healthPack:setLinearVelocity(0, 100)
    healthPack.fill = { type = "image", filename = "img/hill.png" }
    healthPack.ID = "heart"
    
end
hilltimer = timer.performWithDelay(8000,SpawnHeal, 0)

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
local function playHillPlayer()
    audio.play(hillplayer,{channel=29})
    audio.setVolume( 1, {channel=1} )
end
local function popalsoldat(x,object1)
            player.alpha = 0
                playGunshotRaneni()
            life = life - x
            livesText.text = "Lives: " .. life
            player.alpha = 0
                    timer.performWithDelay( 200, restorePlayer )
                object1:removeSelf()
            if life == 0 or life<0 then
                enemiesKilled=0
                gameEnded = true
                enemyGroup = nil
                bulletsGroup = nil
                supersoldatGroup=nil
               -- bulletsSuperGroup:removeSelf()
                bullet2Group:removeSelf()
                life=5
                timer.performWithDelay(0, function()
                    composer.setVariable("finalScore", count)
                    composer.gotoScene("scenes.final2", { time = 300, effect = "crossFade" })
                end)
            end
end

local function killedsoldat(object1,object2)
    if(object2.ID=="enemy") then
        playGunshotDestroit()
        object1:removeSelf()
        object2:removeSelf()
        enemiesKilled = enemiesKilled + 1
        scoreText.text = "Killed: " .. enemiesKilled.."/40"
    elseif (object2.ID=="supersoldat")then
        playGunshotDestroit()
        object1:removeSelf()
        object2.lives=object2.lives-1
        updateHealthBar(object2)
        if(object2.lives==0)then
            playDeathSuperSoldat()
            object2:removeSelf()
            object2.healthBarBackground:removeSelf()
            enemiesKilled = enemiesKilled + 1
            scoreText.text = "Killed: " .. enemiesKilled.."/40"
        end
    end
    
if enemiesKilled >= 40 then  -- Проверяем, достигнуто ли необходимое количество убитых врагов
    enemiesKilled=0
    gameEnded = true
    enemyGroup = nil
    bulletsGroup = nil
    supersoldatGroup=nil
    bulletsSuperGroup:removeSelf()
    bullet2Group:removeSelf()
    life=3
    timer.performWithDelay(0, function()
        composer.setVariable("finalScore", count)
        composer.gotoScene("scenes.finalwin2", { time = 300, effect = "crossFade" })
    end)
end
end

local function onCollision(event)
    if event.phase == "began" then
        local object1 = event.object1
        local object2 = event.object2
        if (object1.ID == "player" and object2.ID == "enemyBullet") or
            (object1.ID == "enemyBullet" and object2.ID == "player") then
                popalsoldat(1,object1)
       elseif (object1.ID == "player" and object2.ID == "superBullet")or
       (object1.ID == "superBullet" and object2.ID == "player") then
            popalsoldat(2,object1)
        end
        if (object1.ID == "player" and object2.ID == "heart")or
        (object1.ID == "heart" and object2.ID == "player") then
            playHillPlayer()
            if life < 5 then
                life = life + 2
                if(life>5)then
                    life=5
                    livesText.text = "Lives: " .. life
                end
                livesText.text = "Lives: " .. life
                object1:removeSelf()
            end
            if life >= 5 then
                life=life
                livesText.text = "Lives: " .. life
                object1:removeSelf()
            end
        end
        if (object1.ID == "bullet" and object2.ID == "enemy") or
            (object1.ID == "enemy" and object2.ID == "bullet") then
               killedsoldat(object1,object2)
        end

        if(object1.ID=="bullet" and object2.ID=="supersoldat") or
        (object1.ID=="supersoldat" and object2.ID=="bullet")then
            killedsoldat(object1,object2)
        end
    end

end
function scene:create(event)
    local sceneGroup = self.view
    physics.pause()

    local background = display.newImageRect(sceneGroup, "img/level2phone.jpg", 1400, 867)
    background.x = display.contentCenterX - 250
    background.y = display.contentCenterY - 70
    player = display.newImageRect(sceneGroup, "img/soldat.png", 100, 140)
    physics.addBody(player, { radius = 30, isSensor = true })
    player.x = display.contentCenterX
    player.y = display.contentHeight + 30
    player.gravityScale = 0
    player.ID = "player"
    player:addEventListener("touch", MovePlayer)
-- спавн + жизнь

    livesText = display.newText(sceneGroup, "Lives: " .. life, 55, -20, "IdealGothicBold.otf", 30)
    livesText:setFillColor(1,0,0,1)
    scoreText = display.newText(sceneGroup, "Killed: " .. count.."/40", 245, -20, "IdealGothicBold.otf", 29)
    scoreText:setFillColor(1,0,0,1)
    enemyGroup = display.newGroup()
    bulletsGroup = display.newGroup()
    bullet2Group=display.newGroup()
    hillGroup=display.newGroup()
    supersoldatGroup=display.newGroup()
    bulletsSuperGroup=display.newGroup()
    hitpointGroup=display.newGroup()
    sceneGroup:insert(enemyGroup)
    sceneGroup:insert(bulletsGroup)
    sceneGroup:insert(bullet2Group)
    sceneGroup:insert(hillGroup)
    sceneGroup:insert(supersoldatGroup)
    sceneGroup:insert(bulletsSuperGroup)
    sceneGroup:insert( hitpointGroup)
    shootTimer = timer.performWithDelay(1500, Shoot, 0)
    enemyTimer = timer.performWithDelay(2300, SpawnEnemy, 0)
    supersoldattimer=timer.performWithDelay(10000,SpawnSuperSoldat,0)
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
    for i = hillGroup.numChildren, 1, -1 do
        local hill = hillGroup[i]
        if hill.y > display.contentHeight + hill.height+60 then
            hill:removeSelf()
        end
    end
    for i = supersoldatGroup.numChildren, 1, -1 do
        local supersoldat = supersoldatGroup[i]
        if supersoldat.y > display.contentHeight + supersoldat.height then
            supersoldat:removeSelf()
        end
    end
    for i = hitpointGroup.numChildren, 1, -1 do
        local hitpoint = hitpointGroup[i]
        if hitpoint.y > display.contentHeight + hitpoint.height+90 then--чуть дальше сделай
            hitpoint:removeSelf()
        end
    end
    for i = bulletsSuperGroup.numChildren, 1, -1 do
        local superBullet = bulletsSuperGroup[i]
        if superBullet.y > display.contentHeight + superBullet.height+60 then
            superBullet:removeSelf()
        end
    end
end
end
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif phase == "did" then
        physics.start()
        Runtime:addEventListener("collision", onCollision)
        isEventListener=false
        audio.play(music, { channel = 17, loops = -1 })
        Runtime:addEventListener("enterFrame", removeOutOfBoundsObjects)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
        timer.cancel(shootTimer)
        timer.cancel(enemyTimer)
        timer.cancel(hilltimer)
        timer.cancel(supersoldattimer)
       -- timer.cancel(secondShootTimer)
        display.remove(enemyGroup)
        display.remove(bulletsGroup)
        display.remove(bullet2Group)
        display.remove(hillGroup)
        display.remove(supersoldatGroup)
        display.remove(bulletsSuperGroup)
        display.remove(hitpointGroup)
        audio.stop(17)
        audio.dispose(music)
    elseif phase == "did" then
        Runtime:removeEventListener("collision",onCollision)
        physics.stop()
        audio.stop(1)
        audio.dispose(music)
        composer.removeScene("scenes.level1")
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
