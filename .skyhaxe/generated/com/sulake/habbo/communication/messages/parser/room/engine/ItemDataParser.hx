package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ItemMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ItemDataParser 
    {


        public static function parseItemData(k:IMessageDataWrapper):ItemMessageData
        {
            var _local_14:String = null;
            var _local_15:String = null;
            var _local_16 = 0;
            var _local_17 = 0;
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_20:String = null;
            var _local_21:Array<ASAny> = null;
            var _local_22 = Math.NaN;
            var _local_23 = Math.NaN;
            var _local_24 = Math.NaN;
            var _local_2= ASCompat.toInt(k.readString());
            var _local_3= k.readInteger();
            var _local_4= k.readString();
            var _local_5= k.readString();
            var _local_6= k.readInteger();
            var _local_7= k.readInteger();
            var _local_8= k.readInteger();
            var _local_9 = 0;
            var _local_10= Std.parseFloat(_local_5);
            if (!Math.isNaN(_local_10))
            {
                _local_9 = ASCompat.toInt(_local_5);
            }
            Logger.log(["\n\n PARSING WALL ITEM: "]);
            Logger.log([("wallItemId: " + Std.string(_local_2))]);
            Logger.log([("wallItemTypeId: " + Std.string(_local_3))]);
            Logger.log([("location: " + _local_4)]);
            Logger.log([("dataStr: " + _local_5)]);
            Logger.log([("secondsToExpiration: " + Std.string(_local_6))]);
            Logger.log([("state: " + Std.string(_local_9))]);
            var _local_11:ItemMessageData = null;
            var _local_12:Array<ASAny> = null;
            var _local_13:String = null;
            if (_local_4.indexOf(":") == 0)
            {
                _local_11 = new ItemMessageData(_local_2, _local_3, false);
                _local_12 = (cast _local_4.split(" "));
                if (_local_12.length >= 3)
                {
                    _local_14 = ASCompat.toString(_local_12[0]);
                    _local_15 = ASCompat.toString(_local_12[1]);
                    _local_13 = ASCompat.toString(_local_12[2]);
                    if (((_local_14.length > 3) && (_local_15.length > 2)))
                    {
                        _local_14 = _local_14.substr(3);
                        _local_15 = _local_15.substr(2);
                        _local_12 = (cast _local_14.split(","));
                        if (_local_12.length >= 2)
                        {
                            _local_16 = ASCompat.toInt(_local_12[0]);
                            _local_17 = ASCompat.toInt(_local_12[1]);
                            _local_12 = (cast _local_15.split(","));
                            if (_local_12.length >= 2)
                            {
                                _local_18 = ASCompat.toInt(_local_12[0]);
                                _local_19 = ASCompat.toInt(_local_12[1]);
                                _local_11.wallX = _local_16;
                                _local_11.wallY = _local_17;
                                _local_11.localX = _local_18;
                                _local_11.localY = _local_19;
                                _local_11.dir = _local_13;
                                _local_11.data = _local_5;
                                _local_11.state = _local_9;
                            }
                        }
                    }
                }
            }
            else
            {
                _local_11 = new ItemMessageData(_local_2, _local_3, true);
                _local_12 = (cast _local_4.split(" "));
                if (_local_12.length >= 2)
                {
                    _local_13 = ASCompat.toString(_local_12[0]);
                    if (((_local_13 == "rightwall") || (_local_13 == "frontwall")))
                    {
                        _local_13 = "r";
                    }
                    else
                    {
                        _local_13 = "l";
                    }
                    _local_20 = ASCompat.toString(_local_12[1]);
                    _local_21 = (cast _local_20.split(","));
                    if (_local_21.length >= 3)
                    {
                        _local_22 = 0;
                        _local_23 = Std.parseFloat(_local_21[0]);
                        _local_24 = Std.parseFloat(_local_21[1]);
                        _local_11.y = _local_23;
                        _local_11.z = _local_24;
                        _local_11.dir = _local_13;
                        _local_11.data = _local_5;
                        _local_11.state = _local_9;
                    }
                }
            }
            _local_11.usagePolicy = _local_7;
            _local_11.ownerId = _local_8;
            _local_11.secondsToExpiration = _local_6;
            return _local_11;
        }

	public function new() {}
    }

