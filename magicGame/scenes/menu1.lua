
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ("widget")

local click;
local backgroundMusic;
--local buttonLev1;
--local buttonLev2;
local function ClickLevel1( event )
    if ( "ended" == event.phase ) then
        print( "lev1" )
        audio.play( click, {channel=1} )
        audio.setVolume( 0.5, {channel=1} )
        composer.gotoScene( "scenes.level1", { time=200, effect="crossFade" } )
        --event.target:setEnabled(false)
    end
end
local function ClickLevel2( event )
    if ( "ended" == event.phase ) then
        print( "lev2" )
        audio.play( click, {channel=1} )
        audio.setVolume( 0.5, {channel=1} )
        composer.gotoScene( "scenes.level2", { time=200, effect="crossFade" } )
        --event.target:setEnabled(false)
    end
end
-- create()
function scene:create( event )

	local sceneGroup = self.view
    click = audio.loadSound( "music/click.mp3" )
    local background = display.newImageRect(sceneGroup,"img/phone.jpg", 1000, 750);
    background.x = display.contentCenterX+100
    background.y = display.contentCenterY
    local lev = display.newImageRect(sceneGroup,"img/txt.png",650, 250);
    lev.x = 160;
    lev.y = 40;
    backgroundMusic = audio.loadSound( "music/menu.mp3" )
    
    local buttonLev1 = widget.newButton(
        {
            width = 300,
            height = 90,
            defaultFile = "img/but.png",
            label = "1 Laboratory",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 0.5 } },
            onEvent = ClickLevel2
        }
    )
    buttonLev1.x = display.contentCenterX
    buttonLev1.y = display.contentCenterY+70
    local buttonLev2 = widget.newButton(
        {
            width = 300,
            height = 90,
            defaultFile = "img/but.png",
            label = "2 Outside",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 0.5 } },
            onEvent = ClickLevel1
        }
    )
    buttonLev2.x = display.contentCenterX
    buttonLev2.y = display.contentCenterY+150
    sceneGroup:insert(buttonLev1)
    sceneGroup:insert(buttonLev2)
end
-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
        audio.play( backgroundMusic,{channel = 2, loops = -1 })
	end
end
-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
        audio.stop(1)
        audio.stop(2)
        --buttonLev1:removeEventListener('touch', buttonLev1.onEvent)
        --buttonLev2:removeEventListener('touch', buttonLev2.onEvent)
        --composer.removeScene( "levels" )
	end
end
-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
    audio.dispose(click);
    audio.dispose(backgroundMusic);
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
