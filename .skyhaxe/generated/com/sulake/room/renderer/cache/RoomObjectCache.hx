package com.sulake.room.renderer.cache
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.renderer.utils.SortableSprite;
    import com.sulake.room.data.RoomObjectSpriteData;
    import com.sulake.room.object._enum.RoomObjectSpriteType;
    import com.sulake.habbo.utils.StringUtil;
    import com.sulake.habbo.utils.Canvas;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class RoomObjectCache 
    {
        static inline final _Str_14703= 200;

        var _data:Map = null;
        var _roomObjectVariableAccurateZ:String = "";

        public function new(k:String)
        {
            this._roomObjectVariableAccurateZ = k;
            this._data = new Map();
        }

        public function dispose()
        {
            var k = 0;
            var _local_2:RoomObjectCacheItem = null;
            if (this._data != null)
            {
                k = 0;
                while ((k : UInt) < this._data.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._data.getWithIndex(k) , RoomObjectCacheItem);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._data.dispose();
                this._data = null;
            }
        }

        public function getObjectCache(k:String):RoomObjectCacheItem
        {
            var _local_2= ASCompat.dynamicAs(this._data.getValue(k) , RoomObjectCacheItem);
            if (_local_2 == null)
            {
                _local_2 = new RoomObjectCacheItem(this._roomObjectVariableAccurateZ);
                this._data.add(k, _local_2);
            }
            return _local_2;
        }

        public function removeObjectCache(k:String)
        {
            var _local_2= ASCompat.dynamicAs(this._data.remove(k) , RoomObjectCacheItem);
            if (_local_2 != null)
            {
                _local_2.dispose();
            }
        }

        public function _Str_15625():Vector<RoomObjectSpriteData>
        {
            var _local_3:RoomObjectCacheItem = null;
            var _local_4:SortableSprite = null;
            var _local_5:RoomObjectSpriteData = null;
            var _local_6 = false;
            var k= new Vector<RoomObjectSpriteData>();
            var _local_2= this._data.getValues();
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                final _iter_ = _local_3.sprites.sprites; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    if (((!(_local_4.sprite.spriteType == RoomObjectSpriteType.ROOM_PLANE)) && (!(_local_4.sprite.libraryAssetName == ""))))
                    {
                        _local_5 = new RoomObjectSpriteData();
                        _local_5.objectId = _local_3.objectId;
                        _local_5.x = _local_4.x;
                        _local_5.y = _local_4.y;
                        _local_5.z = _local_4.z;
                        _local_5.name = StringUtil._Str_25429(_local_4.sprite.libraryAssetName);
                        _local_5.flipH = _local_4.sprite.flipH;
                        _local_5.alpha = _local_4.sprite.alpha;
                        _local_5.color = Std.string(_local_4.sprite.color);
                        _local_5.blendMode = _local_4.sprite.blendMode;
                        _local_5.width = _local_4.sprite.width;
                        _local_5.height = _local_4.sprite.height;
                        _local_5.objectType = _local_4.sprite.objectType;
                        _local_5.posture = _local_4.sprite.assetPosture;
                        _local_6 = this._Str_23710(_local_4.sprite);
                        if (_local_6)
                        {
                            _local_5.skew = (((_local_4.sprite.direction % 4) == 0) ? -0.5 : 0.5);
                        }
                        if (((((_local_6 || (_local_5.name.indexOf("%image.library.url%") >= 0)) || (_local_5.name.indexOf("%group.badge.url%") >= 0)) && (_local_5.width <= _Str_14703)) && (_local_5.height <= _Str_14703)))
                        {
                            _local_5.color = Std.string(Canvas._Str_23439(_local_4.sprite.asset));
                            if (_local_4.sprite.objectType.indexOf("external_image_wallitem") == 0)
                            {
                                _local_5.frame = true;
                            }
                        }
                        k.push(_local_5);
                    }
                }
            }
            return k;
        }

        function _Str_23710(k:IRoomObjectSprite):Bool
        {
            if (!ASCompat.stringAsBool(k.objectType))
            {
                return false;
            }
            if (((k.objectType.indexOf("external_image_wallitem") == 0) && (k.tag == "THUMBNAIL")))
            {
                return true;
            }
            if (((k.objectType.indexOf("guild_forum") == 0) && (k.tag == "THUMBNAIL")))
            {
                return true;
            }
            return false;
        }

        public function _Str_14588():Array<ASAny>
        {
            var _local_3:RoomObjectCacheItem = null;
            var _local_4:SortableSprite = null;
            var k:Array<ASAny> = [];
            var _local_2= this._data.getValues();
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                final _iter_ = _local_3.sprites.sprites; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    if (_local_4.sprite.spriteType == RoomObjectSpriteType.ROOM_PLANE)
                    {
                        k.push(_local_4);
                    }
                }
            }
            return k;
        }
    }

