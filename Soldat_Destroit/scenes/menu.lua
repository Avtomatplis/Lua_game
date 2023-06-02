
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ("widget")

local click;
local backgroundMusic;
local function ClickLevel1( event )
    if ( "ended" == event.phase ) then
        print( "lev1" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
        composer.gotoScene( "scenes.level1", { time=300, effect="crossFade" } )
    end
end
local function ClickLevel2( event )
    if ( "ended" == event.phase ) then
        print( "lev2" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
        composer.gotoScene( "scenes.level2", { time=300, effect="crossFade" } )
    end
end
local function ClickLevelclose( event )
    if ( "ended" == event.phase ) then
        print( "Close" )
        audio.play( click, {channel=1} )
        audio.setVolume( 1, {channel=1} )
        os.exit()
    end
end
function scene:create( event )

	local sceneGroup = self.view
    click = audio.loadSound( "music/click.mp3" )
    local background = display.newImageRect(sceneGroup,"img/phonesoldat.jpg", 1000, 750);
    background.x = display.contentCenterX+100
    background.y = display.contentCenterY
    local lev = display.newImageRect(sceneGroup,"img/txtfon.png",500, 200);
    lev.x = 175;
    lev.y = 40;
    backgroundMusic = audio.loadSound( "music/menufon.mp3" )
    local buttonLev1 = widget.newButton(
        {
            width = 300,
            height = 90,
            defaultFile = "img/butmenu.png",
            label = "Level 1",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 0, 0 }, over={ 1, 1, 1, 0.5 } },
            onEvent = ClickLevel2
        }
    )
    buttonLev1.x = display.contentCenterX+5
    buttonLev1.y = display.contentCenterY-90
    local buttonLev2 = widget.newButton(
        {
            width = 300,
            height = 90,
            defaultFile = "img/butmenu.png",
            label = "Level 2",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 0, 0 }, over={ 1, 1, 1, 0.5 } },
            onEvent = ClickLevel1
        }
    )
    buttonLev2.x = display.contentCenterX+5
    buttonLev2.y = display.contentCenterY-30
    local buttonLevclose = widget.newButton(
        {
            width = 300,
            height = 90,
            defaultFile = "img/butmenu.png",
            label = "Выйти из игры",
            font = "IdealGothicBold.otf",
            fontSize = 28,
            labelColor = { default={ 1, 0, 0 }, over={ 1, 1, 1, 0.5 } },
            onEvent = ClickLevelclose
        }
    )
    buttonLevclose.x = display.contentCenterX+5
    buttonLevclose.y = display.contentCenterY+30
    sceneGroup:insert(buttonLev1)
    sceneGroup:insert(buttonLev2)
    sceneGroup:insert(buttonLevclose)
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
