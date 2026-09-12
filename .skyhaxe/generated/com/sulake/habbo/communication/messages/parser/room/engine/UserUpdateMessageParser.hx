package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserUpdateMessageData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.AvatarActionMessageData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserUpdateMessageParser implements IMessageParser 
    {
        var _users:Array<ASAny>;

        public function new()
        {
            this._users = [];
        }

        public var userUpdateCount(get,never):Int;
public function  get_userUpdateCount():Int
        {
            return this._users.length;
        }

        public function flush():Bool
        {
            this._users = [];
            return true;
        }

        public function _Str_24400(k:Int):UserUpdateMessageData
        {
            if (((k < 0) || (k >= this.userUpdateCount)))
            {
                return null;
            }
            return this._users[k];
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5 = Math.NaN;
            var _local_6 = Math.NaN;
            var _local_7 = Math.NaN;
            var _local_8 = Math.NaN;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11:String = null;
            var _local_12 = false;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15:Array<ASAny> = null;
            var _local_16 = Math.NaN;
            var _local_17 = Math.NaN;
            var _local_18 = Math.NaN;
            var _local_19 = false;
            var _local_20:Array<ASAny> = null;
            var _local_21 = 0;
            var _local_22:UserUpdateMessageData = null;
            var _local_23:String = null;
            var _local_24:Array<ASAny> = null;
            var _local_25:String = null;
            var _local_26:String = null;
            var _local_27:Array<ASAny> = null;
            var _local_28 = Math.NaN;
            var _local_29 = Math.NaN;
            if (k == null)
            {
                return false;
            }
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                _local_6 = k.readInteger();
                _local_7 = ASCompat.toNumber(k.readString());
                _local_8 = 0;
                _local_9 = k.readInteger();
                _local_10 = k.readInteger();
                _local_11 = k.readString();
                _local_12 = false;
                _local_13 = ((_local_9 % 8) * 45);
                _local_14 = ((_local_10 % 8) * 45);
                _local_15 = [];
                _local_16 = 0;
                _local_17 = 0;
                _local_18 = 0;
                _local_19 = false;
                _local_20 = (cast _local_11.split("/"));
                _local_21 = 0;
                while (_local_21 < _local_20.length)
                {
                    _local_23 = ASCompat.asString(_local_20[_local_21] );
                    _local_24 = (cast _local_23.split(" "));
                    _local_25 = ASCompat.toString(_local_24[0]);
                    _local_26 = "";
                    if (_local_25 == "")
                    {
                    }
                    else
                    {
                        if (_local_24.length >= 2)
                        {
                            _local_26 = ASCompat.toString(_local_24[1]);
                            switch (_local_25)
                            {
                                case "mv":
                                    _local_27 = (cast _local_26.split(","));
                                    if (_local_27.length >= 3)
                                    {
                                        _local_16 = ASCompat.toInt(_local_27[0]);
                                        _local_17 = ASCompat.toInt(_local_27[1]);
                                        _local_18 = ASCompat.toNumber(_local_27[2]);
                                        _local_19 = true;
                                    }
                                    
                                case "sit":
                                    _local_28 = ASCompat.toNumber(_local_26);
                                    if (_local_24.length >= 3)
                                    {
                                        _local_12 = (_local_24[2] == "1");
                                    }
                                    _local_8 = _local_28;
                                    
                                case "lay":
                                    _local_29 = ASCompat.toNumber(_local_26);
                                    if (_local_29 < 0)
                                    {
                                    }
                                    _local_8 = Math.abs(_local_29);
                                    
                            }
                        }
                        _local_15.push(new AvatarActionMessageData(_local_25, _local_26));
                    }
                    _local_21++;
                }
                _local_22 = new UserUpdateMessageData(_local_4, _local_5, _local_6, _local_7, _local_8, _local_14, _local_13, _local_16, _local_17, _local_18, _local_19, _local_12, _local_15);
                this._users.push(_local_22);
                _local_3++;
            }
            return true;
        }
    }

