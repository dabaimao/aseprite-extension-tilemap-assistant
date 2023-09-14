

local fileheader = "." .. string.upper(ExtensionName)
local packbit = 8
local fmt = "<i" .. tostring(packbit)
local marginCellNum = 0
local function unpackData(stream, i)
    local binaryValue = string.sub(stream, i + 1, i + packbit)
    local number = string.unpack(fmt, binaryValue)
    return number
end

function TilemapPalette()
    local obj = Object()
    local palette = setmetatable({
        grid = Grid(),
        colorMode = ColorMode.RGB,
        selectedCell=Point(0,0)
    }, { __index = obj })

    function palette:serializeTilePalette()
        local stream = fileheader
        stream = stream .. string.pack(fmt, self.grid.offset.x)
        stream = stream .. string.pack(fmt, self.grid.offset.y)
        stream = stream .. string.pack(fmt, self.grid.cell.x)
        stream = stream .. string.pack(fmt, self.grid.cell.y)
        stream = stream .. string.pack(fmt, self.grid.gap.x)
        stream = stream .. string.pack(fmt, self.grid.gap.y)
        stream = stream .. string.pack(fmt, self.bounds.x)
        stream = stream .. string.pack(fmt, self.bounds.y)
        stream = stream .. string.pack(fmt, self.bounds.width)
        stream = stream .. string.pack(fmt, self.bounds.height)
        stream = stream .. string.pack(fmt, self.colorMode)
        stream = stream .. string.pack(fmt, self.spr.width)
        stream = stream .. string.pack(fmt, self.spr.height)
        stream = stream .. self.spr.bytes
        return stream
    end

    function palette:unserializeTilePalette(binaryStreamData)
        local count = #fileheader

        self.grid.offset.x = unpackData(binaryStreamData, count)
        count = count + packbit
        self.grid.offset.y = unpackData(binaryStreamData, count)
        count = count + packbit
        self.grid.cell.x = unpackData(binaryStreamData, count)
        count = count + packbit
        self.grid.cell.y = unpackData(binaryStreamData, count)
        count = count + packbit
        self.grid.gap.x = unpackData(binaryStreamData, count)
        count = count + packbit
        self.grid.gap.y = unpackData(binaryStreamData, count)
        count = count + packbit
        self.bounds.x = unpackData(binaryStreamData, count)
        count = count + packbit
        self.bounds.y = unpackData(binaryStreamData, count)
        count = count + packbit
        self.bounds.width = unpackData(binaryStreamData, count)
        count = count + packbit
        self.bounds.height = unpackData(binaryStreamData, count)
        count = count + packbit
        self.colorMode = unpackData(binaryStreamData, count)
        count = count + packbit

        local w = unpackData(binaryStreamData, count)
        count = count + packbit
        local h = unpackData(binaryStreamData, count)
        count = count + packbit
        self.spr = Image(w, h, self.colorMode)
        self.spr.bytes = string.sub(binaryStreamData, count + 1)

        return self
    end

    function palette:imageIntoTilePalette(img)
        self.bounds.x = 0
        self.bounds.y = 0

        local pt = TilemapGridSizeCalclation(img.bounds.size, self.grid)

        local stepX=self.grid.cell.x+self.grid.gap.x
        local stepY=self.grid.cell.y+self.grid.gap.y

        self.bounds.width = pt.x + stepX * marginCellNum * 2
        self.bounds.height =pt.y + stepY * marginCellNum * 2
        self.colorMode = img.colorMode
        self.spr = Image(self.bounds.width, self.bounds.height, self.colorMode)

        local p=Point(0,0)
        if  self.grid.offset.x>0 then
            p.x=stepX*marginCellNum-self.grid.offset.x%stepX
        else
            p.x=stepX*marginCellNum+self.grid.offset.x%stepX
        end

        if  self.grid.offset.y>0 then
            p.y=stepY*marginCellNum-self.grid.offset.y%stepY
        else
            p.y=stepY*marginCellNum+self.grid.offset.y%stepY
        end


        self.spr:drawImage(img,p)
        return self
    end

    function palette:copy()

        local cp=TilemapPalette()

        cp.grid.offset.x= self.grid.offset.x
        cp.grid.offset.y= self.grid.offset.y
        cp.grid.cell.x= self.grid.cell.x
        cp.grid.cell.y= self.grid.cell.y
        cp.grid.gap.x= self.grid.gap.x
        cp.grid.gap.y= self.grid.gap.y
        cp.bounds.x=self.bounds.x
        cp.bounds.y=self.bounds.y
        cp.bounds.width=self.bounds.width
        cp.bounds.height=self.bounds.height
        cp.colorMode=self.colorMode

        local w=self.spr.width
        local h=self.spr.height

        cp.spr=Image(w,h,cp.colorMode)
        cp.spr.bytes=self.spr.bytes

        return cp
    end


    function palette:getTile(mousePos)
        local sprPos=self:screenPosToObjPos(mousePos)
        self.selectedCell.x=math.floor(sprPos.x/self.grid.cell.x)
        self.selectedCell.y=math.floor(sprPos.y/self.grid.cell.y)

        local tile=Image(self.grid.cell.x,self.grid.cell.x,self.spr.colorMode)
        local x=-self.selectedCell.x*self.grid.cell.x
        local y=-self.selectedCell.y*self.grid.cell.y
        tile:drawImage(self.spr,Point(x,y))

        return tile
    end


    return palette
end
