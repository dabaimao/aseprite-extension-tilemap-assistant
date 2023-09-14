function InputNumLimitDown(val, limitDown)
    local rs = 0
    rs = limitDown
    local num=0
    if type(val)=="number"then
        num =val
    else
        num=0
    end

    if num <rs then
        return rs
    else
        num = math.floor(num)
    end
    return num
end