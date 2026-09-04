package com.sulake.habbo.communication.messages.parser.inventory.furni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FurniListAddOrUpdateParser implements IMessageParser 
    {
        var _furniList:Vector<FurniData>;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._furniList = new Vector<FurniData>(0);
			this._furniList.push(new FurniData(k));
            return true;
        }

        public function flush():Bool
        {
            this._furniList = null;
            return true;
        }

        public function getFurni():Vector<FurniData>
        {
            return this._furniList;
        }

	public function new() {}
    }

