local composer = require("composer")
local scene = composer.newScene()
local widget = require ("widget")
local musicwin
music = audio.loadStream("music/level2fon.mp3")
local function ClickLevel2( event )
    if ( "ended" == event.phase ) then
        print( "lev2" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
       -- audio.play(music, { channel = 18, loops = -1 })
        composer.gotoScene( "scenes.level1", { time=300, effect="crossFade" } )
    end
end
local function Clickmenu( event )
    if ( "ended" == event.phase ) then
        print( "Menu" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
        composer.gotoScene( "scenes.menu", { time=300, effect="crossFade" } )
    end
end

function scene:create(event)
	local sceneGroup = self.view
    click = audio.loadSound( "music/click.mp3" )
	local background = display.newImageRect(sceneGroup, "img/phoneWin.jpg", 1000, 750)
	background.x = display.contentCenterX + 100
	background.y = display.contentCenterY

	local sc = display.newImageRect(sceneGroup, "img/Win.png", 380, 120)
	sc.x = 173
	sc.y = 40
	local level2Button = widget.newButton(
        {
            width = 210,
            height = 90,
            defaultFile = "img/butmenu.png",
            label = "Level 2",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 0, 0 }, over={ 1, 1, 1, 0.5 } },
            onEvent = ClickLevel2
        }
    )
    level2Button.x = display.contentCenterX+9
    level2Button.y = display.contentCenterY+100
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
    MenuButton.y = display.contentCenterY+160
	sceneGroup:insert(level2Button)
    sceneGroup:insert(MenuButton)
	local new = composer.getVariable("finalScore")
	composer.setVariable("finalScore", 0)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "did") then
		musicwin = audio.loadStream("music/Wintrek.mp3")
		audio.play(musicwin, {channel = 24,loops = -1 })
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "did") then
		audio.stop(24)
		musicwin = nil
		composer.removeScene("scenes.finalwin")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
    audio.dispose(musicwin);
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
