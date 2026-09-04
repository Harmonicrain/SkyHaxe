package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredUserMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredFurniMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredWallItemMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredUserDirectionData;

     class WiredMovementsMessageParser implements IMessageParser
    {
        var _userMoves:Array<ASAny>;
        var _furniMoves:Array<ASAny>;
        var _wallItemMoves:Array<ASAny>;
        var _userDirectionUpdates:Array<ASAny>;

        public function flush():Bool
        {
            this._userMoves = [];
            this._furniMoves = [];
            this._wallItemMoves = [];
            this._userDirectionUpdates = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3:Int;
            this._userMoves = [];
            this._furniMoves = [];
            this._wallItemMoves = [];
            this._userDirectionUpdates = [];
            if (k == null)
            {
                return false;
            }
            var _local_2= k.readInteger();
            var _local_4 = 0;
            while (_local_4 < _local_2)
            {
                _local_3 = k.readInteger();
                switch (_local_3)
                {
                    case 0:
                        this._userMoves.push(this.parseUserMove(k));
                        
                    case 1:
                        this._furniMoves.push(this.parseFurniMove(k));
                        
                    case 2:
                        this._wallItemMoves.push(this.parseWallItemMove(k));
                        
                    case 3:
                        this._userDirectionUpdates.push(this.parseUserDirUpdate(k));
                        
                }
                _local_4++;
            }
            return true;
        }

        function parseFurniMove(k:IMessageDataWrapper):WiredFurniMovementData
        {
            var _local_2= k.readInteger();
            var _local_3= k.readInteger();
            var _local_4= k.readInteger();
            var _local_5= k.readInteger();
            var _local_6= ASCompat.toNumber(k.readString());
            var _local_7= ASCompat.toNumber(k.readString());
            var _local_8= k.readInteger();
            var _local_9= k.readInteger();
            var _local_10= k.readInteger();
            var _local_11= Math.NaN;
            if (k.readBoolean())
            {
                _local_11 = k.readInteger();
            }
            var _local_12= Math.NaN;
            if (k.readBoolean())
            {
                _local_12 = k.readInteger();
            }
            return new WiredFurniMovementData(_local_8, new Vector3d(_local_2, _local_3, _local_6), new Vector3d(_local_4, _local_5, _local_7), _local_10, _local_9, _local_11, _local_12);
        }

        function parseUserMove(k:IMessageDataWrapper):WiredUserMovementData
        {
            var _local_2= k.readInteger();
            var _local_3= k.readInteger();
            var _local_4= k.readInteger();
            var _local_5= k.readInteger();
            var _local_6= ASCompat.toNumber(k.readString());
            var _local_7= ASCompat.toNumber(k.readString());
            var _local_8= k.readInteger();
            var _local_9= k.readInteger();
            var _local_10= k.readInteger();
            var _local_11= k.readInteger();
            var _local_12= k.readInteger();
            var _local_13= Math.NaN;
            if (k.readBoolean())
            {
                _local_13 = k.readInteger();
            }
            return new WiredUserMovementData(_local_8, new Vector3d(_local_2, _local_3, _local_6), new Vector3d(_local_4, _local_5, _local_7), ((_local_9 == 0) ? "mv" : "sld"), _local_10, _local_11, _local_12, _local_13);
        }

        function parseWallItemMove(k:IMessageDataWrapper):WiredWallItemMovementData
        {
            var _local_2= k.readInteger();
            var _local_3= k.readBoolean();
            var _local_4= k.readInteger();
            var _local_5= k.readInteger();
            var _local_6= k.readInteger();
            var _local_7= k.readInteger();
            var _local_8= k.readInteger();
            var _local_9= k.readInteger();
            var _local_10= k.readInteger();
            var _local_11= k.readInteger();
            var _local_12= k.readInteger();
            return new WiredWallItemMovementData(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10, _local_11, _local_12);
        }

        function parseUserDirUpdate(k:IMessageDataWrapper):WiredUserDirectionData
        {
            var _local_2= k.readInteger();
            var _local_3= k.readInteger();
            var _local_4= k.readInteger();
            return new WiredUserDirectionData(_local_2, _local_3, _local_4);
        }

        public var userMoves(get,never):Array<ASAny>;
function  get_userMoves():Array<ASAny>
        {
            return this._userMoves;
        }

        public var furniMoves(get,never):Array<ASAny>;
function  get_furniMoves():Array<ASAny>
        {
            return this._furniMoves;
        }

        public var wallItemMoves(get,never):Array<ASAny>;
function  get_wallItemMoves():Array<ASAny>
        {
            return this._wallItemMoves;
        }

        public var userDirectionUpdates(get,never):Array<ASAny>;
function  get_userDirectionUpdates():Array<ASAny>
        {
            return this._userDirectionUpdates;
        }

	public function new() {}
    }

