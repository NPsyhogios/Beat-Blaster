--[[ functions defined in this .lua file:
DialogButtonClicked
DiscardDialog
DialogSwitchFocus
EnterOnDialog
NewDialog
]]


--[[
Dialog boxes work as such:
-name:				The name of the dialog box which the draw and input methods detect.
-background:		An image file that serves as the background for the dialog box.
-choice:			Buttons that you can click, that serve as things to do after the dialog box is terminated.
	-[name of choice]
		img:		The image file for the button.
		x:			X coordinate of the button.
		y:			Y coordinate of the button.
		(Width and Height are automatically determined from the image and also serve as the clickable area.)

-textbox:			When focused, you can type into the box.
	-[name of textbox]
		-text:		The current text of the textbox stored as a string.
		-hasFocus:	Boolean variable. If true, typing changes the text.
		-range:		Can be nil. If not, it is a table of two values; a lower and an upper byte range. Only characters within this byte range (inclusive) are allowed. If nil, any character is allowed. Multiple ranges are allowed.
		-x:			X coordinate of the button.
		-y:			Y coordinate of the button.
		-width:		Width of the textbox (length is automatic).
		-maxLength:	Maximum length of the string.

-checkbox: (OBSOLETE)
	-[name of checkbox]
		-checked:	Boolean variable.
		-x:			X coordinate of the button.
		-y:			Y coordinate of the button.
		(Width/Height are automatic, 16x16)

-dropmenu:
	-[name of dropmenu]
		-x:			X coordinate of the dropmenu.
		-y:			Y coordinate of the dropmenu.
		-width:		Width of the dropmenu, determined by the physical length of the longest string.
		-offset:	If 0, the menu cascades down when expanded. If not, it cascades up. Determined by checking if
						there is enough space to display all items of the textbox.
		-text:		The text/decision currently displayed at the base of the dropmenu.
		-expanded:	Boolean value checking if the dropmenu is expanded or not.
		-options:	A table of strings that serve as the options for the dropmenu.
		-curOption:	The currently selected option from the options table (integer value).
]]
function NewDialog(s)

	local t;
	local dir = 'dialog/'..s..'/';
	local g = love.graphics;
	
	
	
	if s == "BulletRequirements" then
		t = {
			name = s,
			title = "Set Loop and Boss Health Reqirements",
			background = g.newImage(dir..'background.png'),
			choice = {
				cancel = {
					img = g.newImage(dir..'cancel.png'),
					x = SCREENW/2+240,
					y = SCREENH/2+25
				},
				editing = {
					img = g.newImage(dir..'editing.png'),
					x = SCREENW/2-170,
					y = SCREENH/2+25
				},
				done = {
					img = g.newImage(dir..'done.png'),
					x = SCREENW/2-240,
					y = SCREENH/2+25
				},
				queue = {
					img = g.newImage(dir..'queue.png'),
					x = SCREENW/2,
					y = SCREENH/2+25
				}
			},
			dropmenu = {
				loopreq = {
					x = SCREENW/2-120,
					y = SCREENH/2-47,
					options = {"(no condition)","Less than or equal to","Greater than or equal to","Exactly","Every"}
				},
				healthreq = {
					x = SCREENW/2-120,
					y = SCREENH/2-22,
					options = {"(no condition)","Less than or equal to","Greater than or equal to","Between"}
				}
			},
			textbox = {
				loopmod = {
					text = "",
					hasFocus = true,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+90,
					y = SCREENH/2-47,
					width = 45,
					maxLength = 3
				},
				loopstart = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+290,
					y = SCREENH/2-47,
					width = 45,
					maxLength = 3
				},
				loopless = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+90,
					y = SCREENH/2-47,
					width = 45,
					maxLength = 3
				},
				loopgreater = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+90,
					y = SCREENH/2-47,
					width = 45,
					maxLength = 3
				},
				loopequal = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+90,
					y = SCREENH/2-47,
					width = 45,
					maxLength = 3
				},
				healthlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+90,
					y = SCREENH/2-22,
					width = 60,
					maxLength = 4
				},
				healthupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+195,
					y = SCREENH/2-22,
					width = 60,
					maxLength = 4
				},
				healthless = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+90,
					y = SCREENH/2-22,
					width = 60,
					maxLength = 4
				},
				healthgreater = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))}},
					x = SCREENW/2+90,
					y = SCREENH/2-22,
					width = 60,
					maxLength = 4
				}
			}
		};
		
------- BULLET ATTRIBUTES -------

elseif s == "BulletAttributes" then

		t = {
			name = s,
			title = "Set Starting Attributes",
			background = g.newImage(dir..'background.png'),
			choice = {
				cancel = {
					img = g.newImage(dir..'cancel.png'),
					x = SCREENW/2+200,
					y = SCREENH/2+265
				},
				editing = {
					img = g.newImage(dir..'editing.png'),
					x = SCREENW/2-80,
					y = SCREENH/2+265
				},
				requirements = {
					img = g.newImage(dir..'requirements.png'),
					x = SCREENW/2-205,
					y = SCREENH/2+265
				}
			},
			dropmenu = {
				start = {
					x = SCREENW/2-45,
					y = SCREENH/2-245,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				x = {
					x = SCREENW/2-140,
					y = SCREENH/2-195,
					options = {"Increment","Variance","Random"}
				},
				xorigin = {
					x = SCREENW/2-140,
					y = SCREENH/2-195+25,
					options = {"Screen","Boss","Player"}
				},
				xvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2-195+25,
					options = {"Sine","Cosine"}
				},
				xvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2-195,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				y = {
					x = SCREENW/2-140,
					y = SCREENH/2-120,
					options = {"Increment","Variance","Random"}
				},
				yorigin = {
					x = SCREENW/2-140,
					y = SCREENH/2-120+25,
					options = {"Screen","Boss","Player"}
				},
				yvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2-120+25,
					options = {"Sine","Cosine"}
				},
				yvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2-120,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				angle = {
					x = SCREENW/2-140,
					y = SCREENH/2-45,
					options = {"Increment","Variance","Random"}
				},
				anglevariance = {
					x = SCREENW/2+130,
					y = SCREENH/2-45+25,
					options = {"Sine","Cosine"}
				},
				anglevariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2-45,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				angletype = {
					x = SCREENW/2-140,
					y = SCREENH/2-45+25,
					options = {"Right","Player"}
				},
				speed = {
					x = SCREENW/2-140,
					y = SCREENH/2+30,
					options = {"Increment","Variance","Random"}
				},
				speedvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2+30+25,
					options = {"Sine","Cosine"}
				},
				speedvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2+30,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				xaccel = {
					x = SCREENW/2-140,
					y = SCREENH/2+105,
					options = {"Increment","Variance","Random"}
				},
				xaccelvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2+105+25,
					options = {"Sine","Cosine"}
				},
				xaccelvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2+105,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				xaccelbase = {
					x = SCREENW/2-140,
					y = SCREENH/2+105+25,
					options = {"Normal","Bullet"}
				},
				yaccel = {
					x = SCREENW/2-140,
					y = SCREENH/2+180,
					options = {"Increment","Variance","Random"}
				},
				yaccelvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2+180+25,
					options = {"Sine","Cosine"}
				},
				yaccelvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2+180,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				yaccelbase = {
					x = SCREENW/2-140,
					y = SCREENH/2+180+25,
					options = {"Normal","Bullet"}
				}
			},
			textbox = {
				startbase = {
					text = gEditValues.curSecond,
					hasFocus = true,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-245,
					width = 70,
					maxLength = 6
				},
				startincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+30,
					y = SCREENH/2-245,
					width = 70,
					maxLength = 6
				},
				bullets = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+170,
					y = SCREENH/2-245,
					width = 35,
					maxLength = 3
				},
				-- X attributes
				xbase = {
					text = gMouse.x,
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				-- Y attributes
				ybase = {
					text = gMouse.y,
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				-- Angle attributes
				anglebase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				angleincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglevariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglevariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglerandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglerandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				-- Speed attributes
				speedbase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				-- X Accel attributes
				xaccelbase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				-- Y Accel attributes
				yaccelbase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				}
			}
		};
		

------- BULLET QUEUE -------
	
elseif s == "BulletQueue" then

		t = {
			name = s,
			title = "Add a Queue to the Pattern",
			background = g.newImage(dir..'background.png'),
			choice = {
				cancel = {
					img = g.newImage(dir..'cancel.png'),
					x = SCREENW/2+200,
					y = SCREENH/2+268
				},
				done = {
					img = g.newImage(dir..'done.png'),
					x = SCREENW/2-205,
					y = SCREENH/2+268
				},
				editing = {
					img = g.newImage(dir..'editing.png'),
					x = SCREENW/2-130,
					y = SCREENH/2+268
				},
				queue = {
					img = g.newImage(dir..'queue.png'),
					x = SCREENW/2-20,
					y = SCREENH/2+268
				}
			},
			dropmenu = {
				queuediff = {
					x = SCREENW/2-55,
					y = SCREENH/2-220,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				sign = {
					x = SCREENW/2+100,
					y = SCREENH/2-220,
					options = {"Add","Subtract"}
				},
				x = {
					x = SCREENW/2-140,
					y = SCREENH/2-195,
					options = {"(no change)","Increment","Variance","Random","Bullet"}
				},
				xorigin = {
					x = SCREENW/2-140,
					y = SCREENH/2-195+25,
					options = {"Screen","Boss","Player"}
				},
				xvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2-195+25,
					options = {"Sine","Cosine"}
				},
				xvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2-195,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				y = {
					x = SCREENW/2-140,
					y = SCREENH/2-120,
					options = {"(no change)","Increment","Variance","Random","Bullet"}
				},
				yorigin = {
					x = SCREENW/2-140,
					y = SCREENH/2-120+25,
					options = {"Screen","Boss","Player"}
				},
				yvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2-120+25,
					options = {"Sine","Cosine"}
				},
				yvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2-120,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				angle = {
					x = SCREENW/2-140,
					y = SCREENH/2-45,
					options = {"(no change)","Increment","Variance","Random","Bullet"}
				},
				anglevariance = {
					x = SCREENW/2+130,
					y = SCREENH/2-45+25,
					options = {"Sine","Cosine"}
				},
				anglevariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2-45,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				angletype = {
					x = SCREENW/2-140,
					y = SCREENH/2-45+25,
					options = {"Right","Player"}
				},
				speed = {
					x = SCREENW/2-140,
					y = SCREENH/2+30,
					options = {"(no change)","Increment","Variance","Random","Bullet"}
				},
				speedvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2+30+25,
					options = {"Sine","Cosine"}
				},
				speedvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2+30,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				xaccel = {
					x = SCREENW/2-140,
					y = SCREENH/2+105,
					options = {"(no change)","Increment","Variance","Random","Bullet"}
				},
				xaccelvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2+105+25,
					options = {"Sine","Cosine"}
				},
				xaccelvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2+105,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				xaccelbase = {
					x = SCREENW/2-140,
					y = SCREENH/2+105+25,
					options = {"Normal","Bullet"}
				},
				yaccel = {
					x = SCREENW/2-140,
					y = SCREENH/2+180,
					options = {"(no change)","Increment","Variance","Random","Bullet"}
				},
				yaccelvariance = {
					x = SCREENW/2+130,
					y = SCREENH/2+180+25,
					options = {"Sine","Cosine"}
				},
				yaccelvariancenotation = {
					x = SCREENW/2+130,
					y = SCREENH/2+180,
					options = {"Custom","Whole","Half","4th","8th","12th","16th","24th","32nd","48th","64th"}
				},
				yaccelbase = {
					x = SCREENW/2-140,
					y = SCREENH/2+180+25,
					options = {"Normal","Bullet"}
				}
			},
			textbox = {
				-- Base queue attributes
				queuebase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-150,
					y = SCREENH/2-245,
					width = 70,
					maxLength = 6
				},
				queuediff = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+20,
					y = SCREENH/2-220,
					width = 70,
					maxLength = 6
				},
				
				-- X attributes
				xbase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				xrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195,
					width = 70,
					maxLength = 6
				},
				-- Y attributes
				ybase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				yrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+75,
					width = 70,
					maxLength = 6
				},
				-- Angle attributes
				anglebase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				angleincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglevariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglevariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglerandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				anglerandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+150,
					width = 70,
					maxLength = 6
				},
				-- Speed attributes
				speedbase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				speedrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+225,
					width = 70,
					maxLength = 6
				},
				-- X Accel attributes
				xaccelbase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				xaccelrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+300,
					width = 70,
					maxLength = 6
				},
				-- Y Accel attributes
				yaccelbase = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-215,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelincrement = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelvariance = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelvariancespeed = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+200,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelrandomlower = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2-45,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				},
				yaccelrandomupper = {
					text = "",
					hasFocus = false,
					visible = true,
					range = {{tonumber(string.byte('0')),tonumber(string.byte('9'))},{tonumber(string.byte('-')),tonumber(string.byte('-'))},{tonumber(string.byte('.')),tonumber(string.byte('.'))}},
					x = SCREENW/2+55,
					y = SCREENH/2-195+375,
					width = 70,
					maxLength = 6
				}
			}
		};
	end
	
	
	if t.dropmenu then
		for i,v in pairs(t.dropmenu) do
			-- First, initialize all common values.
			t.dropmenu[i].width = 1;
			t.dropmenu[i].offset = 0;
			t.dropmenu[i].text = "";
			t.dropmenu[i].expanded = false;
			t.dropmenu[i].visible = true;
			t.dropmenu[i].curOption = 1;
			
			-- The default cascades the choices down from the base. If the dropmenu is too low where
			-- choices will be cut off, cascade upward from the base instead.
			if v.y + #v.options*20 > SCREENH then
				t.dropmenu[i].offset = #t.dropmenu[i].options*20+20;
			end
			t.dropmenu[i].text = v.options[v.curOption];
			for k,w in ipairs(v.options) do
				Trace("width = "..font:getWidth(w)*1.25)
				if v.width < font:getWidth(w)*1.25 then t.dropmenu[i].width = Round(font:getWidth(w)*1.25); end
			end
		end
	end
	
	if t.choice then
		for i,v in pairs(t.choice) do
			if gEditing then
				if i == "editing" or i == "cancel" then
					t.choice[i].visible = true;
				end
			else
				if i ~= "editing" then
					t.choice[i].visible = true;
				end
			end
		end
	end
	
	CheckVisibility(t);
	
	return t;

end

function DiscardDialog()
	gDialog = nil;
end



function DialogButtonClicked(d)
	local name;
	if d.choice then
		for i,v in pairs(d.choice) do
			if gMouse.x > v.x-v.img:getWidth()/2 and gMouse.x < v.x+v.img:getWidth()/2 and
			gMouse.y > v.y-v.img:getHeight()/2 and gMouse.y < v.y+v.img:getHeight()/2 then
			name = i; break end
		end
	end
	if not name then return; end
	
	
	if d.name == "BulletRequirements" then
		if name == "done" and not gEditing then
			StoreRequirements(gDialog,gTempPattern);
			FinalizePattern(gTempPattern,gEditValues.difficulty);
			SortPatterns(gEditValues.difficulty);
			gPatternSelected = nil;
			DiscardDialog();
	elseif name == "cancel" then
			gEditing = false;
			gPatternSelected = nil;
			DiscardDialog();
	elseif name == "queue" and not gEditing then
			StoreRequirements(gDialog,gTempPattern);
			DiscardDialog();
			gTempPatternText = gTempPatternText..'queue = {';	-- first time adding a queue
			gTempPattern.tbl.queue = {};
			gDialog = NewDialog("BulletQueue");
	elseif name == "editing" and gEditing then
			-- finalize edited pattern here
			gEditing = false;
			gPatternSelected = nil;
			DiscardDialog();
		end
			-- Before discarding the old dialog box, store the data the user entered into a
			-- temporary table that will be stored both into the temp level lua file and into
			-- gBullets (for instant level design pattern feedback)
			
elseif d.name == "BulletAttributes" then
		if name == "requirements" and not gEditing then
			gTempPattern = {};
			gTempPatternText = "\t\t\t";
			StoreAttributes(gDialog,gTempPattern);
			DiscardDialog();
			gDialog = NewDialog("BulletRequirements");
	elseif name == "cancel" then
			DiscardDialog();
			gEditing = false;
	elseif name == "editing" and gEditing then
			-- finalize edited pattern here
			gEditing = false;
			gPatternSelected = nil;
			DiscardDialog();
		end

elseif d.name == "BulletQueue" then
		if name == "done" and not gEditing then
			StoreQueue(gDialog,gTempPattern);
			gTempPatternText = string.sub(gTempPatternText,1,-3) -- get rid of the extra comma
			gTempPatternText = gTempPatternText..'}}  ';	-- close the queue table, extra whitespace for the FinalizePattern function
			FinalizePattern(gTempPattern,gEditValues.difficulty);
			SortPatterns(gEditValues.difficulty);
			gPatternSelected = nil;
			DiscardDialog();
	elseif name == "cancel" then
			gEditing = false;
			gPatternSelected = nil;
			DiscardDialog();
	elseif name == "queue" and not gEditing then
			StoreQueue(gDialog,gTempPattern);
			DiscardDialog();
			gDialog = NewDialog("BulletQueue");
	elseif name == "editing" and gEditing then
			-- finalize edited pattern here
			gEditing = false;
			gPatternSelected = nil;
			DiscardDialog();
		end
	end
	
end

function TextBoxClicked(d)
	local name;
	
	-- find the textbox that was clicked, if any
	if d.textbox then
		
		for i,v in pairs(d.textbox) do
			--Trace(i);
			if v.visible then
				if gMouse.x > v.x and gMouse.x < v.x+v.width and
				gMouse.y > v.y and gMouse.y < v.y+25 then
				name = i; break end
			end
		end
	end
	if not name then return; end
	
	-- switch focus ONLY if a textbox was clicked
	for i,v in pairs(d.textbox) do
		if name == i then d.textbox[i].hasFocus = true;
		else d.textbox[i].hasFocus = false; end -- always iterate through entire table, make sure all but one textbox is unfocused
	end
	
end

function DropMenuClicked(d)
	if not d.dropmenu then
		DialogButtonClicked(gDialog);
		if gDialog then TextBoxClicked(gDialog); end
		--if gDialog then CheckBoxClicked(gDialog); end
		return
	end
	
	local flag = false
	local expandedMenu = nil;
	
	for i,v in pairs(d.dropmenu) do
		if v.visible then
			if v.expanded then expandedMenu = i; end
		end
	end
	
	if expandedMenu then
		flag = true;
		for i,v in ipairs(d.dropmenu[expandedMenu].options) do
			if gMouse.x > d.dropmenu[expandedMenu].x and gMouse.x < d.dropmenu[expandedMenu].x + d.dropmenu[expandedMenu].width and
				gMouse.y > d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset and gMouse.y < d.dropmenu[expandedMenu].y+i*20-d.dropmenu[expandedMenu].offset+20 then
				d.dropmenu[expandedMenu].curOption = i;
				d.dropmenu[expandedMenu].text = v;
				d.dropmenu[expandedMenu].expanded = false;
				break;
			else
				d.dropmenu[expandedMenu].expanded = false;
			end
		end
	else
		for i,v in pairs(d.dropmenu) do
			if v.visible then
				if gMouse.x >= v.x and gMouse.x <= v.x + v.width and gMouse.y >= v.y and gMouse.y <= v.y+20 then
					d.dropmenu[i].expanded = true;
				end
			end
		end
	end
	
	CheckVisibility(d);
	
	if not flag then	-- if any dropmenu is expanded, bypass the rest of the mouse click checks
		DialogButtonClicked(gDialog);
		if gDialog then TextBoxClicked(gDialog); end
	end
end

function KeyTyped(d,key)
	local inRange, name;
	
	if key == "backspace" then key = -1;
	else key = tonumber(string.byte(key)); end
	
	if d.textbox then
		for i,v in pairs(d.textbox) do
			if v.hasFocus then name = i; end
		end
	end
	if not name then return; end	-- name should NEVER be nil
	
	
	if d.textbox[name].range then
		for i,v in ipairs(d.textbox[name].range) do
			if key >= v[1] and key <= v[2] then
				inRange = true; break; end
		end
	else inRange = true; end
	if not inRange and key ~= -1 then return; end	-- deny input if the key entered is illegal for this textbox
	
	if key == -1 then
		if string.len(d.textbox[name].text) > 1 then
			d.textbox[name].text = string.sub(d.textbox[name].text,0,string.len(d.textbox[name].text)-1);
		elseif string.len(d.textbox[name].text) == 1 then
			d.textbox[name].text = "";
		end
	else
		if string.len(d.textbox[name].text) < d.textbox[name].maxLength then
		d.textbox[name].text = d.textbox[name].text..string.char(key); end
	end
	
	
end

function CheckVisibility(d)
	-- This will check the visibility of all textboxes and buttons so that they only show under certain conditions.
	
	if d.name == "BulletAttributes"  or d.name == "BulletQueue" then
		
		if d.dropmenu.start then
			if d.dropmenu.start.text == "Custom" then d.textbox.startincrement.visible = true; else d.textbox.startincrement.visible = false; end
		end
		
		if d.dropmenu.queuediff then
			if d.dropmenu.queuediff.text == "Custom" then d.textbox.queuediff.visible = true; else d.textbox.queuediff.visible = false; end
		end
		
		local t = {"x","y","angle","speed","xaccel","yaccel"}
		for i,v in ipairs(t) do
			for j,w in ipairs(d.dropmenu[v].options) do
				if w ~= "(no change)" and w ~= "Bullet" then
					if d.dropmenu[v].text == w then
						if w == "Random" then
							d.textbox[v..string.lower(w)..'lower'].visible = true;
							d.textbox[v..string.lower(w)..'upper'].visible = true;
						else
							if w == "Variance" then
								d.textbox[v..string.lower(w)..'speed'].visible = true;
								d.dropmenu[v..string.lower(w)].visible = true;
								d.dropmenu[v..string.lower(w)..'notation'].visible = true;
								if d.dropmenu[v..'variancenotation'].text == "Custom" then
									d.textbox[v..'variancespeed'].visible = true;
								else
									d.textbox[v..'variancespeed'].visible = false;
								end
							end
							--Trace(v..string.lower(w));
							d.textbox[v..string.lower(w)].visible = true;
						end
					else
						if w == "Random" then
							d.textbox[v..string.lower(w)..'lower'].visible = false;
							d.textbox[v..string.lower(w)..'upper'].visible = false;
						else
							if w == "Variance" then
								d.textbox[v..string.lower(w)..'speed'].visible = false;
								d.dropmenu[v..string.lower(w)].visible = false;
								Trace(v..string.lower(w)..'notation')
								d.dropmenu[v..string.lower(w)..'notation'].visible = false;
								d.textbox[v..'variancespeed'].visible = false;
							end
							d.textbox[v..string.lower(w)].visible = false;
						end
					end
				end
			end
		end
	
elseif d.name == "BulletRequirements" then
		for i,v in pairs(d.textbox) do
			d.textbox[i].visible = false;
		end
		
		for i,v in ipairs(d.dropmenu.healthreq.options) do
			if d.dropmenu.healthreq.text == v then
				if i == 2 then
					d.textbox.healthless.visible = true;
			elseif i == 3 then
					d.textbox.healthgreater.visible = true;
			elseif i == 4 then
					d.textbox.healthlower.visible = true;
					d.textbox.healthupper.visible = true;
				end
				break;
			end
		end
		
		for i,v in ipairs(d.dropmenu.loopreq.options) do
			if d.dropmenu.loopreq.text == v then
				if i == 2 then
					d.textbox.loopless.visible = true;
			elseif i == 3 then
					d.textbox.loopgreater.visible = true;
			elseif i == 4 then
					d.textbox.loopequal.visible = true;
			elseif i == 5 then
					d.textbox.loopmod.visible = true;
					d.textbox.loopstart.visible = true;
				end
				break;
			end
		end
	end
	
	
	if gEditing then
		
	else
	
	end
	
end


function FillDialogValues(d,num)
	if d.name == "BulletAttributes" then
	
elseif d.name == "BulletQueue" then

elseif d.name == "BulletRequirements" then

	end




end
