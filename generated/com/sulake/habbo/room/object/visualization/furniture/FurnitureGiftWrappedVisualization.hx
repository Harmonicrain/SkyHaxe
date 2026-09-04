package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureGiftWrappedVisualization extends FurnitureVisualization 
    {
        var _packetType:Int = 0;
        var _ribbonType:Int = 0;


        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            this._Str_16942();
            super.update(k, _arg_2, _arg_3, _arg_4);
        }

        function _Str_16942()
        {
            var _local_2:IRoomObjectModel;
            var _local_3:Int;
            var _local_4:String;
            var _local_5:Int;
            var k= object;
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    _local_3 = 1000;
                    _local_4 = _local_2.getString(RoomObjectVariableEnum.FURNITURE_EXTRAS);
                    _local_5 = ASCompat.parseInt(_local_4);
                    this._packetType = Math.floor((_local_5 / _local_3));
                    this._ribbonType = (_local_5 % _local_3);
                }
            }
        }

        override function getFrameNumber(k:Int, _arg_2:Int):Int
        {
            if (_arg_2 <= 1)
            {
                return this._packetType;
            }
            return this._ribbonType;
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            var _local_3= _Str_3033(k);
            var _local_4= type;
            var _local_5= "";
            if (_arg_2 < (spriteCount - 1))
            {
                _local_5 = String.fromCharCode(("a".charCodeAt(0) + _arg_2));
            }
            else
            {
                _local_5 = "sd";
            }
            var _local_6= this.getFrameNumber(k, _arg_2);
            _local_4 = (_local_4 + ((((("_" + _local_3) + "_") + _local_5) + "_") + direction));
            _local_4 = (_local_4 + ("_" + _local_6));
            return _local_4;
        }

	public function new() { super(); }
    }

