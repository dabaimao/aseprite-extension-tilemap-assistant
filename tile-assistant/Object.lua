--Scene Sprite Object
function Object()
    local obj = {
        bounds = Rectangle(0, 0, 0, 0),
        spr = Image(0, 0, ColorMode.RGB)
    }
    function obj:move(newPos)
        self.bounds.origin = newPos
    end

    function obj:zoom(dleta)
        local ratio = self.spr.height / self.spr.width
        self.bounds.width = self.bounds.width - dleta
        if self.bounds.width < 1 then
            self.bounds.width = 1
        end
        self.bounds.height = self.bounds.width * ratio
        if self.bounds.height < 1 then
            self.bounds.height = 1
        end
    end

    function obj:screenPosToObjPos(pos)
        local relPos =  pos-self.bounds.origin 
        local rX = self.spr.width / self.bounds.width
        local rY = self.spr.height / self.bounds.height
        local objPos = Point(0, 0)
        objPos.x = relPos.x * rX
        objPos.y = relPos.y * rY
        return objPos
    end

    function obj:objPosToScreenPos(pos)
        local rX = self.bounds.width / self.spr.width
        local rY = self.bounds.height / self.spr.height
        local canvasPos = Point(0, 0)
        canvasPos.x = pos.x * rX
        canvasPos.y = pos.y * rY
        return canvasPos
    end

    return obj
end
