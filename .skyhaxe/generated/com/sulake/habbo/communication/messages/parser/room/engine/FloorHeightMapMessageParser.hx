package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.room.object.RoomPlaneParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.room.engine.AreaHideMessageData;

     class FloorHeightMapMessageParser implements IMessageParser 
    {
        var _text:String = "";
        var _heightMap:Array<ASAny>;
        var _width:Int = 0;
        var _height:Int = 0;
        var _scale:Float = 0;
        var _fixedWallsHeight:Int = -1;
        var _areaHideData:Vector<AreaHideMessageData>;
        var _cameraInitX:Int = 0;
        var _cameraInitY:Int = 0;
        var _cameraInitZ:Float = Math.NaN;
        var _hasExtendedData:Bool = false;

        public function new()
        {
            this._heightMap = [];
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._height;
        }

        public var fixedWallsHeight(get,never):Int;
public function  get_fixedWallsHeight():Int
        {
            return this._fixedWallsHeight;
        }

        public var scale(get,never):Float;
public function  get_scale():Float
        {
            return this._scale;
        }

        public function getTileHeight(k:Int, _arg_2:Int):Int
        {
            if (((((k < 0) || (k >= this.width)) || (_arg_2 < 0)) || (_arg_2 >= this.height)))
            {
                return RoomPlaneParser.TILE_BLOCKED;
            }
            var _local_3:Array<ASAny> = ASCompat.dynamicAs(this._heightMap[_arg_2] , Array);
            return ASCompat.toInt(_local_3[k]);
        }

        public function flush():Bool
        {
            this._heightMap = [];
            this._width = 0;
            this._height = 0;
            this._text = "";
            this._fixedWallsHeight = -1;
            this._areaHideData = null;
            this._cameraInitX = 0;
            this._cameraInitY = 0;
            this._cameraInitZ = 0;
            this._hasExtendedData = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
var _local_12 = 0;            var _local_11:String = null;
            if (k == null)
            {
                return false;
            }
            var _local_2= k.readBoolean();
            this._fixedWallsHeight = k.readInteger();
            this._text = k.readString();
            var _local_3:Array<ASAny> = (cast this._text.split("\r"));
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:Array<ASAny> = null;
            var _local_8= _local_3.length;
            if (((_local_8 > 0) && (_local_3[(_local_8 - 1)] == "")))
            {
                _local_8--;
            }
            var _local_9 = 0;
            var _local_10:String = null;
            _local_5 = 0;
            while (_local_5 < _local_8)
            {
                _local_10 = ASCompat.asString(_local_3[_local_5] );
                if (_local_10.length > _local_9)
                {
                    _local_9 = _local_10.length;
                }
                _local_5++;
            }
            this._heightMap = [];
            _local_5 = 0;
            while (_local_5 < _local_8)
            {
                _local_7 = [];
                _local_4 = 0;
                while (_local_4 < _local_9)
                {
                    _local_7.push(RoomPlaneParser.TILE_BLOCKED);
                    _local_4++;
                }
                this._heightMap.push(_local_7);
                _local_5++;
            }
            this._width = _local_9;
            this._height = _local_8;
            _local_5 = 0;
            while (_local_5 < _local_8)
            {
                _local_7 = ASCompat.dynamicAs(this._heightMap[_local_5] , Array);
                _local_10 = ASCompat.asString(_local_3[_local_5] );
                if (_local_10.length > 0)
                {
                    _local_4 = 0;
                    while (_local_4 < _local_10.length)
                    {
                        _local_11 = _local_10.charAt(_local_4);
                        if (((!(_local_11 == "x")) && (!(_local_11 == "X"))))
                        {
                            _local_6 = ASCompat.parseInt(_local_11, 36);
                        }
                        else
                        {
                            _local_6 = RoomPlaneParser.TILE_BLOCKED;
                        }
                        _local_7[_local_4] = _local_6;
                        _local_4++;
                    }
                }
                _local_5++;
            }
            this._scale = (_local_2 ? 32 : 64);
            if (k.bytesAvailable > 0)
            {
                this._hasExtendedData = true;
                this._areaHideData = new Vector<AreaHideMessageData>();
_local_12= k.readInteger();
                _local_5 = 0;
                while (_local_5 < _local_12)
                {
                    this._areaHideData.push(new AreaHideMessageData(k));
                    _local_5++;
                }
                this._cameraInitX = k.readInteger();
                this._cameraInitY = k.readInteger();
                this._cameraInitZ = k.readFloat();
            }
            return true;
        }

        public var areaHideData(get,never):Vector<AreaHideMessageData>;
public function  get_areaHideData():Vector<AreaHideMessageData>
        {
            return this._areaHideData;
        }

        public var cameraInitX(get,never):Int;
public function  get_cameraInitX():Int
        {
            return this._cameraInitX;
        }

        public var cameraInitY(get,never):Int;
public function  get_cameraInitY():Int
        {
            return this._cameraInitY;
        }

        public var cameraInitZ(get,never):Float;
public function  get_cameraInitZ():Float
        {
            return this._cameraInitZ;
        }

        public var hasExtendedData(get,never):Bool;
public function  get_hasExtendedData():Bool
        {
            return this._hasExtendedData;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }
    }

