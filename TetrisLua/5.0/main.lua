local json = require("/resources/dkjson")

pieces = {
    { -- Square
        {0,0,0,0},
        {0,1,1,0},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- Line
        {0,0,0,0},
        {0,0,0,0},
        {1,1,1,1},
        {0,0,0,0}
    },
    { -- L-shape1
        {0,0,0,0},
        {0,0,1,0},
        {1,1,1,0},
        {0,0,0,0}
    },
    { -- L-shape2
        {0,0,0,0},
        {0,1,0,0},
        {0,1,1,1},
        {0,0,0,0}
    },
    { -- S-shape
        {0,0,0,0},
        {0,0,1,1},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- Z-shape
        {0,0,0,0},
        {1,1,0,0},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- T-shape
        {0,0,0,0},
        {0,0,1,0},
        {0,1,1,1},
        {0,0,0,0}
    }
}

-- UI Sizes
PixelSize = 24
boardW = 10
boardH = 20
shift = 0

-- Board
board = {}
for i=0,boardH do
    line = {}
    for i=0,boardW do 
        table.insert(line, 0)
    end
    table.insert(board, line)
end

-- Colors
BackgroundColor = {0, 0, 0}
FieldColor = {0, 0, 0}
FieldBorderColor = {1, 0, 0}
PieceColor = {1, 1, 1}

-- Pieces management
currentPiece = pieces[love.math.random(#pieces)]
pieceFallen = false
pieceX = love.math.random(3, boardW - 4)
pieceY = -1
nextPiece = pieces[love.math.random(#pieces)]

-- Rotation and Move
dx = 0
rotation = false
makeFall = false


-- GameStatus
isAlive = true
points = 0
animationSteps = 0

-- Time
delta = 0
timeStep = 1

-- Sound
soundLocked = false


-- ---------------------------------------------------------------------
--MAIN

-- General Love load
function love.load(arg)

	-- Window size
    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
	
	-- Background color
    love.graphics.setBackgroundColor(BackgroundColor)
	
	-- Sound effects
    soundCorrect = love.audio.newSource('resources/correct.mp3', "static")
    soundWrong = love.audio.newSource('resources/wrong.mp3', "static")
    soundLose = love.audio.newSource('resources/lose.mp3', "static")
    soundPoints = love.audio.newSource('resources/points.mp3', "static")
	
	-- Font
    mainFont = love.graphics.newFont("resources/bebas.ttf", 20);
    smallFont = love.graphics.newFont("resources/bebas.ttf", 12);

    shift = (windowHeight - 20 * 24) / 2
end

-- Key Pressed
function love.keypressed(key, unicode)
    if key == 'escape' then
        if isAlive then
            saveGame()
        end
        r = love.event.quit()
    elseif key == 'w' or key == 'up' then			-- start rotating piece
        rotation = true
    elseif key == 'a' or key == 'left' then			-- start moving left
        dx = -1
    elseif key == 'd' or key == 'right' then		-- start moving right
        dx = 1
    elseif key == 's' or key == 'down' then			-- start dropping piece
        makeFall = true
    end
end

-- Key Released
function love.keyreleased(key, unicode)
    if key == 'a' or key == 'left' then			    -- stops moving left
        dx = 0
    elseif key == 'd' or key == 'right' then		-- stops moving right
        dx = 0
    elseif key == 's' or key == 'down' then			-- stops dropping piece
        makeFall = false
    end
end

-- Touch pressed - same as keypressed
function love.touchpressed(id, x, y, dxa, dya, pressure)
    if x / PixelSize > pieceX and x / PixelSize < pieceX + 4 and (y - shift) / PixelSize > pieceY and (y - shift) / PixelSize < pieceY + 4 then
        rotation = true
    elseif x / PixelSize < pieceX then
        dx = -1
    elseif x / PixelSize > pieceX + 4 then
        dx = 1
    elseif x / PixelSize > pieceX and x / PixelSize < pieceX + 4 and (y - shift) / PixelSize > pieceY then
        makeFall = true
    end
end

-- Touch released - stop everything
function love.touchreleased(id, x, y, dxa, dya, pressure)
    rotation = false
    dx = 0
    makeFall = false
end

-- Update
function love.update(dt)

    animatePoints(animationSteps)

	-- Game Lost
    if not isAlive then
        playSound(soundLose)
        soundLocked = true
        return true
    end

    delta = delta + dt
    if math.floor((delta / dt) % 3) == 0 then
        -- Rotate if possible
        if rotation then
            rotation = false

            if isRotationPossible() then
                currentPiece = rotate(currentPiece)
            else
                playSound(soundWrong)
            end
        end
        
        -- Move if possible
        mx = canMove()
        pieceX = pieceX + dx * mx
        
        -- Fall quicker
        if makeFall then
            pieceY = Drop()
        end
    end

	
	-- Gravity and connecting pieces
    if delta > timeStep then
        pieceFallen = Gravity()

        if pieceFallen then
            mergePiece()
			
			-- Remove lines
            gainedPoints = removeFilled()
            if gainedPoints > 0 then
                playSound(soundPoints)

                points = points + gainedPoints
                animationSteps = 15
                if points > 1000 / timeStep then
                    timeStep = timeStep * 0.9
                end
            else
                playSound(soundCorrect)
            end
			
			-- Next Piece Generation
            currentPiece = nextPiece
            pieceX = love.math.random(3, boardW - 4)
            pieceY = -1
            isAlive = checkAlive()
            nextPiece = pieces[love.math.random(#pieces)]
        end

        delta = 0
    end
end

-- Drawing to screen
function love.draw()
    drawInterface()
    drawBoard()

    drawPiece()
    drawNextPiece()
    if not isAlive then
        love.graphics.print('YOU LOST!', (boardW) * PixelSize / 3, 7.5 * PixelSize, 0, 1.5, 1.5)
    end
end

-- ---------------------------------------------------------------------

-- Make piece drop
function Drop()
    for y=1,4 do
        for x=1,4 do
            if currentPiece[y][x] == 1 then
                if pieceY + y >= 20 or board[pieceY + y + 1][pieceX + x] == 1 then
                    return pieceY
                end
            end
        end
    end

    return pieceY + 1
end

-- Check if player died
function checkAlive()
    for y=1,4 do
        for x=1,4 do
            if currentPiece[y][x] == 1 and board[pieceY + y][pieceX + x] == 1 then
                return false
            end
        end
    end
    return true
end

-- Remove line if filled
function removeFilled()
    removedLines = 0

    y = boardH
    while y > 0 do
        filled = 0
        for x = 1, boardW do
            filled = filled + board[y][x]
        end
        if filled == boardW then
            i = y
            while i > 0 do
                if i > 1 then
                    board[i] = board[i-1]
                else
                    board[i] = {0,0,0,0,0,0,0,0,0,0}
                end
                i = i - 1
            end
            removedLines = removedLines + 1
        else
            y = y - 1
        end
    end

    return calculatePoints(removedLines)
end

-- Calculate scores based on lines
function calculatePoints(lines)
    if lines == 0 then
        return 0
    else
        return lines + calculatePoints(lines - 1)
    end
end

-- Check rotation possible
function isRotationPossible()

    if pieceY == -1 then
        return false
    end

    afterRotation = rotate(currentPiece)

    for y = 1, 4 do
        for x = 1, 4 do
            if afterRotation[y][x] == 1 then
                if pieceX + x > boardW or pieceX + x < 1 or board[pieceY+y][pieceX+x] == 1 then
                    return false
                end
            end
        end
    end

    return true
end

-- Piece rotation
function rotate(pieceIn)
    pieceOut = {
        {},{},{},{}
    }

    for j = 1, 4 do
        for i = 1, 4 do
            pieceOut[j][5-i] = pieceIn[i][j]
        end
    end

    return pieceOut
end

-- Play Sound
function playSound(sound)
    if not soundLocked then
        soundLocked = true
        love.audio.play(sound)
        soundLocked = false
    end
end

-- Check movement possible 
function canMove()
    for y = 1, 4 do
        for x = 1, 4 do
            if currentPiece[y][x] == 1 then
                if pieceX + x + dx > boardW or pieceX + x + dx < 1 or board[pieceY + y][pieceX + x + dx] == 1 then
                    return 0
                end
            end
        end
    end

    return 1
end

-- Place pieces
function mergePiece()
    for y = 1, 4 do
        for x = 1, 4 do
            if currentPiece[y][x] == 1 then
                board[pieceY + y][pieceX + x] = 1
            end
        end
    end
end

-- Gravity simulation
function Gravity()

    for y = 1, 4 do
        for x = 1, 4 do
            if currentPiece[y][x] == 1 then
                if pieceY + y + 1 > boardH or board[pieceY + y + 1][pieceX + x] == 1 then
                    return true
                end
            end
        end
    end

    pieceY = pieceY + 1
    return false
end

-- Board draw
function drawBoard()
    for y = 1, boardH do
        for x = 1, boardW do
            if board[y][x] == 1 then
                posxd = x * PixelSize
                posyd = y * PixelSize + shift
                drawBlock(posxd, posyd, FieldBorderColor)
            end
        end
    end
end

-- Piece draw
function drawPiece()
    for y = 1, 4 do
        for x = 1, 4 do
            if currentPiece[y][x] == 1 then
                posxd = (pieceX + x) * PixelSize
                posyd = (pieceY + y) * PixelSize + shift
                drawBlock(posxd, posyd, PieceColor)
            end
        end
    end
end

-- Next piece draw
function drawNextPiece()
    for y = 1, 4 do
        for x = 1, 4 do
            if nextPiece[y][x] == 1 then
                posxd = (boardW + x + 0.5) * PixelSize
                posyd = (y + 0.5) * PixelSize + shift
                drawBlock(posxd, posyd, PieceColor)
            end
        end
    end
end

-- Block draw
function drawBlock(posx, posy, color)
    drawX = posx - PixelSize
    drawY = posy - PixelSize
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", drawX, drawY, PixelSize, PixelSize)
end

-- UI draw
function drawInterface()
    love.graphics.setColor(FieldColor)
    love.graphics.rectangle("fill", 0, 0, boardW * PixelSize, boardH * PixelSize)

    love.graphics.setColor(FieldBorderColor)
    
    for y = 0, boardH * PixelSize, PixelSize do
        for x = 0, boardW * PixelSize, PixelSize do
            love.graphics.line(x, shift, x, boardH * PixelSize + shift)
            love.graphics.line(0, y + shift, boardW * PixelSize, y + shift)
        end
    end

    love.graphics.setColor(FieldBorderColor)
    love.graphics.rectangle("line", (boardW + 0.5) * PixelSize, 0.5 * PixelSize + shift, 4 * PixelSize, 4 * PixelSize)

    love.graphics.setFont(mainFont);
    love.graphics.printf( 'Score: \n' .. points*1000, (boardW + 0.5) * PixelSize, 5.5 * PixelSize + shift, 128, 'left')

    love.graphics.setFont(smallFont);
    love.graphics.printf('Controls:\n\nA or left screen side - left\nD or right screen side - right\nW or block touch - rotate\nS or area under block - drop\n\nESC - exit', (boardW + 0.5) * PixelSize, 8.5 * PixelSize + shift, 128, 'left')
end    

function compareTable(a, b)
    return table.concat(a) == table.concat(b)
end

function swapColors()
    if compareTable(FieldBorderColor, {1, 0, 0}) then
        FieldBorderColor = {0, 1, 0}
    elseif compareTable(FieldBorderColor, {0, 1, 0}) then
        FieldBorderColor = {0, 0, 1}
    else
        FieldBorderColor = {1, 0, 0}
    end
end

function animatePoints()
    if animationSteps <= 0 then
        animationSteps = 0
    elseif animationSteps == 7 or animationSteps == 15 then
       swapColors()
    end
    animationSteps = animationSteps - 1
end

-- -----------------------------------------------------------------------------
-- Save and Load

function saveGame()
    data = {
        current = currentPiece,
        currentX = pieceX,
        currentY = pieceY,
        next = nextPiece,
        pts = points,
        color = FieldBorderColor,
        gameStatus = board
    }
    local serializedData = json.encode(data)
    success, message = love.filesystem.write("save.json", serializedData)
end

function loadGame()
    if love.filesystem.getInfo("save.json") then
        local serializedData = love.filesystem.read("save.json")
        local loadedData = json.decode(serializedData)
        currentPiece = loadedData.current
        pieceX = loadedData.currentX
        pieceY = loadedData.currentY
        nextPiece = loadedData.next
        points = loadedData.pts
        FieldBorderColor = loadedData.color
        board = loadedData.gameStatus
    end
end
