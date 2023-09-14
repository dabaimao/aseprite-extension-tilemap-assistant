require("Constant")

-- Get Specify Extension Name Files
function GetDocumentFiles(path, extension)
    local fileList = app.fs.listFiles(path)
    local list = {}
    for i = 1, #fileList, 1 do
        if app.fs.fileExtension(fileList[i]) == extension then
            list[#list + 1] = app.fs.fileTitle(fileList[i])
        end
    end
    return list
end

-- Same Name Files Check
function SameNameFilesCheck(list, name)
    for i = 1, #list, 1 do
        if list[i] == name then
            return true
        end
    end
    return false
end

-- Remove Specified File
function RemoveSpecFile(filepath)
    if OsName == "Windows_NT" then
        --execute remove on windows
        os.execute("del /s/q " ..
        "\"" ..filepath.. "\"")
    elseif OsName == "Linux" then
        --execute remove on Linux
        os.execute("rm " ..
        "\"" ..filepath.. "\"")
    elseif OsName == "MacOS" then
        --execute remove on MacOS
        os.execute("rm " ..
        "\"" ..filepath.. "\"")
    end
end

-- Get File Stream
function GetFileStream(filepath)
    local file=io.open(filepath,"rb")
    local stream=""
    if file~=nil then
        stream=file:read("a")
        file:close()
    end
    return stream
end

-- Set File Stream
function SetFileStream(filepath,stream)
    local file=io.open(filepath,"w+b")
    if file~=nil then
        file:write(stream)
        file:close()
    end
end