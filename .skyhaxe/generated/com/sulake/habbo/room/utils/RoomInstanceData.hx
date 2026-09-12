package com.sulake.habbo.room.utils
;
    import com.sulake.core.utils.Map;

     class RoomInstanceData 
    {
        var _roomId:Int = 0;
        var _furniStackingHeightMap:FurniStackingHeightMap = null;
        var _legacyGeometry:LegacyWallGeometry = null;
        var _tileObjectMap:TileObjectMap = null;
        var _roomCamera:RoomCamera = null;
        var _selectedObject:SelectedRoomObjectData = null;
        var _placedObject:SelectedRoomObjectData = null;
        var _worldType:String = null;
        var _isPublic:Bool = false;
        var _furnitureStack:Map;
        var _wallItemStack:Map;
        var _mouseButtonCursorOwners:Array<ASAny>;

        public function new(k:Int)
        {
            this._furnitureStack = new Map();
            this._wallItemStack = new Map();
            this._mouseButtonCursorOwners = [];
            this._roomId = k;
            this._legacyGeometry = new LegacyWallGeometry();
            this._roomCamera = new RoomCamera();
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        
        public var _Str_18267(get,set):FurniStackingHeightMap;
public function  get__Str_18267():FurniStackingHeightMap
        {
            return this._furniStackingHeightMap;
        }
public function  set__Str_18267(k:FurniStackingHeightMap):FurniStackingHeightMap        {
            if (this._furniStackingHeightMap != null)
            {
                this._furniStackingHeightMap.dispose();
            }
            this._furniStackingHeightMap = k;
            if (this._tileObjectMap != null)
            {
                this._tileObjectMap.dispose();
            }
            if (this._furniStackingHeightMap != null)
            {
                this._tileObjectMap = new TileObjectMap(this._furniStackingHeightMap.width, this._furniStackingHeightMap.height);
            }
return k;
        }

        public var legacyGeometry(get,never):LegacyWallGeometry;
public function  get_legacyGeometry():LegacyWallGeometry
        {
            return this._legacyGeometry;
        }

        public var tileObjectMap(get,never):TileObjectMap;
public function  get_tileObjectMap():TileObjectMap
        {
            return this._tileObjectMap;
        }

        public var roomCamera(get,never):RoomCamera;
public function  get_roomCamera():RoomCamera
        {
            return this._roomCamera;
        }

        
        public var _Str_17166(get,set):String;
public function  get__Str_17166():String
        {
            return this._worldType;
        }
public function  set__Str_17166(k:String):String        {
            return this._worldType = k;
        }

        
        public var isPublic(get,set):Bool;
public function  get_isPublic():Bool
        {
            return this._isPublic;
        }
public function  set_isPublic(k:Bool):Bool        {
            return this._isPublic = k;
        }

        
        public var _Str_16852(get,set):SelectedRoomObjectData;
public function  get__Str_16852():SelectedRoomObjectData
        {
            return this._selectedObject;
        }
public function  set__Str_16852(k:SelectedRoomObjectData):SelectedRoomObjectData        {
            if (this._selectedObject != null)
            {
                this._selectedObject.dispose();
            }
            return this._selectedObject = k;
        }

        
        public var _Str_15689(get,set):SelectedRoomObjectData;
public function  get__Str_15689():SelectedRoomObjectData
        {
            return this._placedObject;
        }
public function  set__Str_15689(k:SelectedRoomObjectData):SelectedRoomObjectData        {
            if (this._placedObject != null)
            {
                this._placedObject.dispose();
            }
            return this._placedObject = k;
        }

        public function dispose()
        {
            if (this._furniStackingHeightMap != null)
            {
                this._furniStackingHeightMap.dispose();
                this._furniStackingHeightMap = null;
            }
            if (this._legacyGeometry != null)
            {
                this._legacyGeometry.dispose();
                this._legacyGeometry = null;
            }
            if (this._roomCamera != null)
            {
                this._roomCamera.dispose();
                this._roomCamera = null;
            }
            if (this._selectedObject != null)
            {
                this._selectedObject.dispose();
                this._selectedObject = null;
            }
            if (this._placedObject != null)
            {
                this._placedObject.dispose();
                this._placedObject = null;
            }
            if (this._furnitureStack != null)
            {
                this._furnitureStack.dispose();
                this._furnitureStack = null;
            }
            if (this._wallItemStack != null)
            {
                this._wallItemStack.dispose();
                this._wallItemStack = null;
            }
            if (this._tileObjectMap != null)
            {
                this._tileObjectMap.dispose();
                this._tileObjectMap = null;
            }
        }

        public function addFurnitureData(k:FurnitureData)
        {
            if (k != null)
            {
                this._furnitureStack.remove(k.id);
                this._furnitureStack.add(k.id, k);
            }
        }

        public function getFurnitureData():FurnitureData
        {
            if (this._furnitureStack.length > 0)
            {
                return this.getFurnitureDataWithId(ASCompat.toInt(this._furnitureStack.getKey(0)));
            }
            return null;
        }

        public function getFurnitureDataWithId(k:Int):FurnitureData
        {
            var _local_2:FurnitureData = this._furnitureStack.remove(k);
            return _local_2;
        }

        public function addWallItemData(k:FurnitureData)
        {
            if (k != null)
            {
                this._wallItemStack.remove(k.id);
                this._wallItemStack.add(k.id, k);
            }
        }

        public function getWallItemData():FurnitureData
        {
            if (this._wallItemStack.length > 0)
            {
                return this.getWallItemDataWithId(ASCompat.toInt(this._wallItemStack.getKey(0)));
            }
            return null;
        }

        public function getWallItemDataWithId(k:Int):FurnitureData
        {
            var _local_2:FurnitureData = this._wallItemStack.remove(k);
            return _local_2;
        }

        public function addButtonMouseCursorOwner(k:String):Bool
        {
            var _local_2= this._mouseButtonCursorOwners.indexOf(k);
            if (_local_2 == -1)
            {
                this._mouseButtonCursorOwners.push(k);
                return true;
            }
            return false;
        }

        public function removeButtonMouseCursorOwner(k:String):Bool
        {
            var _local_2= this._mouseButtonCursorOwners.indexOf(k);
            if (_local_2 > -1)
            {
                this._mouseButtonCursorOwners.splice(_local_2, 1);
                return true;
            }
            return false;
        }

        public function hasButtonMouseCursorOwners():Bool
        {
            return this._mouseButtonCursorOwners.length > 0;
        }

        public var mouseButtonCursorOwners(get,never):Array<ASAny>;
public function  get_mouseButtonCursorOwners():Array<ASAny>
        {
            return this._mouseButtonCursorOwners.copy();
        }
    }

