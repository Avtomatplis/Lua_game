local composer = require("composer")
local scene = composer.newScene()
local widget = require ("widget")
local musicwin2

local function Clickmenu( event )
    if ( "ended" == event.phase ) then
        print( "Menu" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
        composer.gotoScene( "scenes.menu", { time=200, effect="crossFade" } )
    end
end

function scene:create(event)
	local sceneGroup = self.view
    click = audio.loadSound( "music/click.mp3" )
	local background = display.newImageRect(sceneGroup, "img/Pobedafinal.jpg", 500, 700)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local sc = display.newImageRect(sceneGroup, "img/gamefinal.png", 350, 100)
	sc.x = 165
	sc.y = 40
	
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
    MenuButton.x = display.contentCenterX
    MenuButton.y = display.contentCenterY+260
    sceneGroup:insert(MenuButton)
	local new = composer.getVariable("final2Score")
	composer.setVariable("final2Score", 0)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "did") then
		musicwin2 = audio.loadStream("music/Wintrek.mp3")
		audio.play(musicwin2, {channel = 21,loops = -1 })
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "did") then
		audio.stop(21)
		musicwin2 = nil
		composer.removeScene("scenes.finalwin2")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
    audio.dispose(musicwin2);
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
