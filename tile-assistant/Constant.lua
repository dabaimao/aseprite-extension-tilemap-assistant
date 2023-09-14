Sep = app.fs.pathSeparator

-- Tilemap Header
ExtensionName = "tilemap"

-- Binary Header Message ".TILEMAP"
BinaryHeader="."..string.upper(ExtensionName)

-- Data Files Directiory Name
DataDirectioryName = "tilemap_assistant"

-- Data Files Directiory Full Path
DataDirectioryNameFullPath =app.fs.joinPath(app.fs.currentPath,DataDirectioryName)

-- Data Files Tilemap Directiory Name
DataTilemapsDirName="maps"

-- Data Files Tilemap Directiory Full Name
DataTilemapsDirFullPath= app.fs.joinPath(DataDirectioryNameFullPath,DataTilemapsDirName)

-- Color Mode 
ColorModeBit = { [ColorMode.RGB] = 4, [ColorMode.GRAY] = 2, [ColorMode.INDEXED] = 1 }

-- Operation System Name
OsName=os.getenv("OS")
