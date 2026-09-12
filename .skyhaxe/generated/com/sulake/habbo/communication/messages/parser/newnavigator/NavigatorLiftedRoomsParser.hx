package com.sulake.habbo.communication.messages.parser.newnavigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.LiftedRoomData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NavigatorLiftedRoomsParser implements IMessageParser 
    {
        var _liftedRooms:Vector<LiftedRoomData>;


        public function flush():Bool
        {
            this._liftedRooms = new Vector<LiftedRoomData>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._liftedRooms.push(new LiftedRoomData(k));
                _local_3++;
            }
            return true;
        }

        public var liftedRooms(get,never):Vector<LiftedRoomData>;
public function  get_liftedRooms():Vector<LiftedRoomData>
        {
            return this._liftedRooms;
        }

	public function new() {}
    }

