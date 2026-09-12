package com.sulake.habbo.communication.messages.parser.inventory.furni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FurniListParser implements IMessageParser 
    {
        var _totalFragments:Int = 0;
        var _fragmentNo:Int = 0;
        var _furniFragment:Map;


        public var totalFragments(get,never):Int;
public function  get_totalFragments():Int
        {
            return this._totalFragments;
        }

        public var fragmentNo(get,never):Int;
public function  get_fragmentNo():Int
        {
            return this._fragmentNo;
        }

        public var furniFragment(get,never):Map;
public function  get_furniFragment():Map
        {
            return this._furniFragment;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:FurniData = null;
            this._totalFragments = k.readInteger();
            this._fragmentNo = k.readInteger();
            this._furniFragment = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new FurniData(k);
                this._furniFragment.add(_local_4.itemId, _local_4);
                _local_3++;
            }
            return true;
        }

        public function flush():Bool
        {
            if (this._furniFragment != null)
            {
                this._furniFragment.dispose();
                this._furniFragment = null;
            }
            return true;
        }

	public function new() {}
    }

