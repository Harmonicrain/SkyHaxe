package com.sulake.room.renderer.cache
;
    import com.sulake.room.renderer.utils.SortableSprite;

     class RoomObjectSortableSpriteCacheItem 
    {
        var _layersInUse:Array<ASAny>;
        var _updateId1:Int = -1;
        var _updateId2:Int = -1;
        var _isEmpty:Bool = false;

        public function new()
        {
            this._layersInUse = [];
        }

        public var spriteCount(get,never):Int;
function  get_spriteCount():Int
        {
            return this._layersInUse.length;
        }

        public var isEmpty(get,never):Bool;
function  get_isEmpty():Bool
        {
            return this._isEmpty;
        }

        public function dispose()
        {
            this.setSpriteCount(0);
        }

        public function addSprite(k:SortableSprite)
        {
            this._layersInUse.push(k);
        }

        public function getSprite(k:Int):SortableSprite
        {
            return this._layersInUse[k];
        }

        public var sprites(get,never):Array<ASAny>;
function  get_sprites():Array<ASAny>
        {
            return this._layersInUse;
        }

        public function _Str_17574(k:Int, _arg_2:Int):Bool
        {
            if (((!(k == this._updateId1)) || (!(_arg_2 == this._updateId2))))
            {
                this._updateId1 = k;
                this._updateId2 = _arg_2;
                return true;
            }
            return false;
        }

        public function setSpriteCount(k:Int)
        {
            var _local_2:Int;
            var _local_3:SortableSprite;
            if (k < this._layersInUse.length)
            {
                _local_2 = k;
                while (_local_2 < this._layersInUse.length)
                {
                    _local_3 = this._layersInUse[_local_2];
                    if (_local_3 != null)
                    {
                        _local_3.dispose();
                    }
                    _local_2++;
                }
                this._layersInUse.splice(k, (this._layersInUse.length - k));
            }
            if (this._layersInUse.length == 0)
            {
                this._isEmpty = true;
            }
            else
            {
                this._isEmpty = false;
            }
        }
    }

