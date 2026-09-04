package com.sulake.room.renderer.cache
;
     class RoomObjectCacheItem 
    {
        var _objectId:Int = 0;
        var _location:RoomObjectLocationCacheItem = null;
        var _sprites:RoomObjectSortableSpriteCacheItem = null;

        public function new(k:String)
        {
            this._location = new RoomObjectLocationCacheItem(k);
            this._sprites = new RoomObjectSortableSpriteCacheItem();
        }

        public var location(get,never):RoomObjectLocationCacheItem;
function  get_location():RoomObjectLocationCacheItem
        {
            return this._location;
        }

        public var sprites(get,never):RoomObjectSortableSpriteCacheItem;
function  get_sprites():RoomObjectSortableSpriteCacheItem
        {
            return this._sprites;
        }

        public function dispose()
        {
            if (this._location != null)
            {
                this._location.dispose();
                this._location = null;
            }
            if (this._sprites != null)
            {
                this._sprites.dispose();
                this._sprites = null;
            }
        }

        
        public var objectId(get,set):Int;
function  set_objectId(k:Int):Int        {
            return this._objectId = k;
        }
function  get_objectId():Int
        {
            return this._objectId;
        }
    }

