package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetInventoryMessageParser implements IMessageParser
    {
        var _totalFragments:Int = 0;
        var _fragmentNo:Int = 0;
        var _petListFragment:Map;


        public function flush():Bool
        {
            if (this._petListFragment != null)
            {
                this._petListFragment.dispose();
                this._petListFragment = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:Pet;
            this._totalFragments = k.readInteger();
            this._fragmentNo = k.readInteger();
            this._petListFragment = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new Pet(k);
                this._petListFragment.add(_local_4.id, _local_4);
                _local_3++;
            }
            return true;
        }

        public var _Str_24388(get,never):Map;
function  get__Str_24388():Map
        {
            return this._petListFragment;
        }

        public var totalFragments(get,never):Int;
function  get_totalFragments():Int
        {
            return this._totalFragments;
        }

        public var fragmentNo(get,never):Int;
function  get_fragmentNo():Int
        {
            return this._fragmentNo;
        }

	public function new() {}
    }

