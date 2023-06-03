local composer = require( "composer" )
local scene = composer.newScene()
local function gotoMenu()
	composer.gotoScene( "scenes.menu1", { time=800, effect="crossFade" } )
end
-- create()
function scene:create( event )
	local sceneGroup = self.view
    local background = display.newImageRect(sceneGroup,"img/phone.jpg", 1000, 750);
    background.x = display.contentCenterX+100
    background.y = display.contentCenterY
    local sc = display.newImageRect(sceneGroup,"img/score.png",650, 250);
    sc.x = 160;
    sc.y = 40;
    local menuButton = display.newText( sceneGroup, "Menu",160,400, "IdealGothicBold.otf", 30 )
	menuButton:addEventListener( "tap", gotoMenu )
    local new = composer.getVariable( "finalScore" )
    local Record = display.newText( sceneGroup,"" .. new,160,90, "IdealGothicBold.otf", 50 )
    Record:setFillColor(100/255,149/255,237/255)
    composer.setVariable( "finalScore", 0 )
end
-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end
-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "did" ) then
        composer.removeScene( "scenes.final" )
	end
end
-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
return scene
