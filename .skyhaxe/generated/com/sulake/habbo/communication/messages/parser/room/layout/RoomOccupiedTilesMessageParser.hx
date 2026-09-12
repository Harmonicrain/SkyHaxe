package com.sulake.habbo.communication.messages.parser.room.layout
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomOccupiedTilesMessageParser implements IMessageParser
    {
        var _occupiedTiles:Array<ASAny>;


        public var occupiedTiles(get,never):Array<ASAny>;
public function  get_occupiedTiles():Array<ASAny>
        {
            return this._occupiedTiles;
        }

        public function flush():Bool
        {
            this._occupiedTiles = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                this._occupiedTiles.push({
                    "x":_local_4,
                    "y":_local_5
                });
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

