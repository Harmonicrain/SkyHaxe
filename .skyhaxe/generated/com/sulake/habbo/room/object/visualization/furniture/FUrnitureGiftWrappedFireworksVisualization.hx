package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FUrnitureGiftWrappedFireworksVisualization extends FurnitureFireworksVisualization 
    {
        static inline final PRESENT_DEFAULT_STATE= 0;
        static inline final MAX_PACKET_TYPE_VALUE= 9;
        static inline final MAX_RIBBON_TYPE_VALUE= 11;

        var _packetType:Int = 0;
        var _ribbonType:Int = 0;
        var _state__com_sulake_habbo_room_object_visualization_furniture_FUrnitureGiftWrappedFireworksVisualization/*redefined private*/:Int = 0;


        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            this._Str_16942();
            super.update(k, _arg_2, _arg_3, _arg_4);
        }

        function _Str_16942()
        {
            var _local_2:IRoomObjectModel = null;
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var k= object;
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    _local_3 = 1000;
                    _local_4 = _local_2.getString(RoomObjectVariableEnum.FURNITURE_EXTRAS);
                    _local_5 = ASCompat.parseInt(_local_4);
                    _local_6 = Std.int(Math.ffloor((_local_5 / _local_3)));
                    _local_7 = (_local_5 % _local_3);
                    this._packetType = ((_local_6 > MAX_PACKET_TYPE_VALUE) ? 0 : _local_6);
                    this._ribbonType = ((_local_7 > MAX_RIBBON_TYPE_VALUE) ? 0 : _local_7);
                }
            }
        }

        override function getFrameNumber(k:Int, _arg_2:Int):Int
        {
            if (this._state__com_sulake_habbo_room_object_visualization_furniture_FUrnitureGiftWrappedFireworksVisualization == PRESENT_DEFAULT_STATE)
            {
                if (_arg_2 <= 1)
                {
                    return this._packetType;
                }
                if (_arg_2 == 2)
                {
                    return this._ribbonType;
                }
            }
            return super.getFrameNumber(k, _arg_2);
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            var _local_3= _Str_3033(k);
            var _local_4= type;
            var _local_5= "";
            if (_arg_2 < (spriteCount - 1))
            {
                _local_5 = ASCompat.stringFromCharCode(("a".charCodeAt(0) + _arg_2));
            }
            else
            {
                _local_5 = "sd";
            }
            var _local_6= this.getFrameNumber(k, _arg_2);
            _local_4 = (_local_4 + ((((("_" + Std.string(_local_3)) + "_") + _local_5) + "_") + Std.string(direction)));
            _local_4 = (_local_4 + ("_" + Std.string(_local_6)));
            return _local_4;
        }

        override function setAnimation(k:Int)
        {
            this._state__com_sulake_habbo_room_object_visualization_furniture_FUrnitureGiftWrappedFireworksVisualization = k;
            super.setAnimation(k);
        }

	public function new() { super(); }
    }

