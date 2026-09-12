package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.utils.ChildEntityArray;
    import flash.geom.Rectangle;
    import com.sulake.core.window.utils.IChildEntity;

     class SkinLayout extends ChildEntityArray implements ISkinLayout 
    {
        var _name:String;
        var _width:UInt = 0;
        var _height:UInt = 0;
        var _blendMode:String;
        var _transparent:Bool = false;

        public function new(k:String, _arg_2:Bool, _arg_3:String)
        {
            super();
            this._name = k;
            this._width = 0;
            this._height = 0;
            this._blendMode = _arg_3;
            this._transparent = _arg_2;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var width(get,never):UInt;
public function  get_width():UInt
        {
            return this._width;
        }

        public var height(get,never):UInt;
public function  get_height():UInt
        {
            return this._height;
        }

        public var blendMode(get,never):String;
public function  get_blendMode():String
        {
            return this._blendMode;
        }

        public var transparent(get,never):Bool;
public function  get_transparent():Bool
        {
            return this._transparent;
        }

        public function dispose()
        {
            var k:UInt = 0;
            var _local_2:UInt = numChildren;
            k = 0;
            while (k < _local_2)
            {
                cast(this.removeChildAt(0), SkinLayoutEntity).dispose();
                k++;
            }
        }

        public function calculateActualRect(k:Rectangle)
        {
            var _local_2:Rectangle = null;
            var _local_3:SkinLayoutEntity = null;
            var _local_5:UInt = 0;
            var _local_4:UInt = numChildren;
            k.x = 0xFFFFFFFF;
            k.y = 0xFFFFFFFF;
            k.width = 0;
            k.height = 0;
            _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_3 = Std.downcast(getChildAt(ASCompat.toInt(_local_5)) , SkinLayoutEntity);
                _local_2 = _local_3.region;
                if (_local_2.left < k.left)
                {
                    k.left = _local_2.left;
                }
                if (_local_2.top < k.top)
                {
                    k.top = _local_2.top;
                }
                if (_local_2.right > k.right)
                {
                    k.right = _local_2.right;
                }
                if (_local_2.bottom > k.bottom)
                {
                    k.bottom = _local_2.bottom;
                }
                _local_5++;
            }
        }

        public function isFixedWidth():Bool
        {
            var _local_2:UInt = 0;
            var k:UInt = numChildren;
            if (k == 0)
            {
                return false;
            }
            _local_2 = 0;
            while (_local_2 < k)
            {
                if (cast(getChildAt(ASCompat.toInt(_local_2)), SkinLayoutEntity).scaleH != SkinLayoutEntity.SCALE_TYPE_FIXED)
                {
                    return false;
                }
                _local_2++;
            }
            return true;
        }

        public function calculateWidth():UInt
        {
            var _local_2:Rectangle = null;
            var _local_4:UInt = 0;
            var k:UInt = 0;
            var _local_3:UInt = numChildren;
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_2 = cast(getChildAt(ASCompat.toInt(_local_4)), SkinLayoutEntity).region;
                if (_local_2.right > k)
                {
                    k = Std.int(_local_2.right);
                }
                _local_4++;
            }
            return k;
        }

        public function isFixedHeight():Bool
        {
            var _local_2:UInt = 0;
            var k:UInt = numChildren;
            if (k == 0)
            {
                return false;
            }
            _local_2 = 0;
            while (_local_2 < k)
            {
                if (cast(getChildAt(ASCompat.toInt(_local_2)), SkinLayoutEntity).scaleV != SkinLayoutEntity.SCALE_TYPE_FIXED)
                {
                    return false;
                }
                _local_2++;
            }
            return true;
        }

        public function calculateHeight():UInt
        {
            var _local_2:Rectangle = null;
            var _local_4:UInt = 0;
            var k:UInt = 0;
            var _local_3:UInt = numChildren;
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_2 = cast(getChildAt(ASCompat.toInt(_local_4)), SkinLayoutEntity).region;
                if (_local_2.bottom > k)
                {
                    k = Std.int(_local_2.bottom);
                }
                _local_4++;
            }
            return k;
        }

        public function getDefaultRegion(name:String, region:Rectangle)
        {
            var childEntity= Std.downcast(getChildByName(name) , SkinLayoutEntity);
            if (childEntity == null)
            {
                throw new ASError((("Entity not found: " + name) + "!"));
            }
            region.x = childEntity.region.x;
            region.y = childEntity.region.y;
            region.width = childEntity.region.width;
            region.height = childEntity.region.height;
        }

        override public function addChild(k:IChildEntity):IChildEntity
        {
            var _local_2= cast(k, SkinLayoutEntity);
            this._width = Std.int((_local_2.region.right > this._width) ? Std.int(_local_2.region.right ): this._width);
            this._height = Std.int((_local_2.region.bottom > this._height) ? Std.int(_local_2.region.bottom ): this._height);
            return super.addChild(k);
        }

        override public function addChildAt(k:IChildEntity, _arg_2:Int):IChildEntity
        {
            var _local_3= cast(k, SkinLayoutEntity);
            this._width = Std.int((_local_3.region.right > this._width) ? Std.int(_local_3.region.right ): this._width);
            this._height = Std.int((_local_3.region.bottom > this._height) ? Std.int(_local_3.region.bottom ): this._height);
            return super.addChildAt(k, _arg_2);
        }

        override public function removeChild(k:IChildEntity):IChildEntity
        {
            super.removeChild(k);
            this._width = this.calculateWidth();
            this._height = this.calculateHeight();
            return k;
        }

        override public function removeChildAt(k:Int):IChildEntity
        {
            var _local_2= super.removeChildAt(k);
            this._width = this.calculateWidth();
            this._height = this.calculateHeight();
            return _local_2;
        }
    }

