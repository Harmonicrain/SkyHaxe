package com.sulake.habbo.communication.messages.parser.inventory.clothing
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FigureSetIdsMessageParser implements IMessageParser 
    {
        var _figureSetIds:Vector<Int>;
        var _boundFurnitureNames:Vector<String>;


        public function flush():Bool
        {
            this._figureSetIds = new Vector<Int>(0);
            this._boundFurnitureNames = new Vector<String>(0);
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3:Int;
            var _local_2= k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._figureSetIds.push(k.readInteger());
                _local_3++;
            }
            _local_2 = k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._boundFurnitureNames.push(k.readString());
                _local_3++;
            }
            return true;
        }

        public var _Str_23010(get,never):Vector<Int>;
function  get__Str_23010():Vector<Int>
        {
            return this._figureSetIds;
        }

        public var _parser9(get,never):Vector<String>;
function  get__parser9():Vector<String>
        {
            return this._boundFurnitureNames;
        }

	public function new() {}
    }

