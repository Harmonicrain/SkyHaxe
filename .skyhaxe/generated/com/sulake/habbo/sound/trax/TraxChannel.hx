package com.sulake.habbo.sound.trax
;
     class TraxChannel 
    {
        var _id:Int = 0;
        var _items:Array<ASAny>;

        public function new(id:Int)
        {
            this._id = id;
            this._items = [];
        }

        public var itemCount(get,never):Int;
public function  get_itemCount():Int
        {
            return this._items.length;
        }

        public function addChannelItem(k:TraxChannelItem)
        {
            this._items.push(k);
        }

        public function getItem(k:Int):TraxChannelItem
        {
            return ASCompat.dynamicAs(this._items[k] , TraxChannelItem);
        }
    }

