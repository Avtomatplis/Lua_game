local composer = require("composer")
local scene = composer.newScene()
local music=audio.loadSound("music/level1.mp3")
local musicdefeat
local defeatCount = 0
local widget = require ("widget")

local function ClickLevel2( event )
    if ( "ended" == event.phase ) then
        print( "lev1" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
	    defeatCount = defeatCount + 1 -- Увеличиваем счетчик поражений
        audio.stop(30) -- Останавливаем музыку
		audio.stop(18) 
		--audio.play(music, { channel = 18, loops = -1 })
        composer.gotoScene( "scenes.level2", { time=200, effect="crossFade" } )
    end
end
local function Clickmenu( event )
    if ( "ended" == event.phase ) then
        print( "Menu" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
		defeatCount = 0 -- Сбрасываем счетчик поражений при переходе в меню
        audio.stop(30) -- Останавливаем музыку
        composer.gotoScene( "scenes.menu", { time=200, effect="crossFade" } )
    end
end

function scene:create(event)
    local sceneGroup = self.view
    click = audio.loadSound( "music/click.mp3" )
    local background = display.newImageRect(sceneGroup, "img/DefeatFon.jpg", 550, 700)
    background.x = display.contentCenterX + 100
    background.y = display.contentCenterY

    local sc = display.newImageRect(sceneGroup, "img/DefeatTxt.png", 350, 130)
    sc.x = 170
    sc.y = 70
	local level2Button = widget.newButton(
        {
            width = 210,
            height = 90,
            defaultFile = "img/butmenu.png",
            label = "Again",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 0, 0 }, over={ 1, 1, 1, 0.5 } },
            onEvent = ClickLevel2
        }
    )
    level2Button.x = display.contentCenterX+9
    level2Button.y = display.contentCenterY+50
	local MenuButton = widget.newButton(
        {
            width = 210,
            height = 90,
            defaultFile = "img/butmenu.png",
            label = "Menu",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 0, 0 }, over={ 1, 1, 1, 0.5 } },
            onEvent = Clickmenu
        }
    )
    MenuButton.x = display.contentCenterX+9
    MenuButton.y = display.contentCenterY+110
	sceneGroup:insert(level2Button)
    sceneGroup:insert(MenuButton)
    local new = composer.getVariable("finalDefeatScore")
    composer.setVariable("finalDefeatScore", 0)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        musicdefeat = audio.loadStream("music/Defeatfinal.mp3")
		audio.stop(18)
        audio.play(musicdefeat, { channel = 30, loops = -1 })
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        audio.stop(30)
        audio.dispose(musicdefeat)
        musicdefeat = nil
        composer.removeScene("scenes.final")
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
