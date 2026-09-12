package com.sulake.habbo.communication.messages.incoming.inventory.furni
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FurniData implements IFurnitureItemData 
    {
        static inline final WALL_ITEM= "I";
        static inline final FLOOR_ITEM= "S";

        var _rentable:Bool = false;
        var _itemId:Int = 0;
        var _furniType:String;
        var _ref:Int = 0;
        var _spriteId:Int = 0;
        var _category:Int = 0;
        var _stuffData:IStuffData;
        var _isGroupable:Bool = false;
        var _isRecyclable:Bool = false;
        var _tradable:Bool = false;
        var _isSellable:Bool = false;
        var _secondsToExpiration:Int = 0;
        var _extra:Int = 0;
        var _flatId:Int = 0;
        var _isWallItem:Bool = false;
        var _hasRentPeriodStarted:Bool = false;
        var _expirationTimeStamp:Int = 0;
        var _slotId:String = "";
        var _songId:Int = -1;

        public function new(k:IMessageDataWrapper)
        {
            this._itemId = k.readInteger();
            this._furniType = k.readString();
            this._ref = k.readInteger();
            this._spriteId = k.readInteger();
            this._category = k.readInteger();
            this._stuffData = ObjectDataParser.parseStuffData(k);
            this._isRecyclable = k.readBoolean();
            this._tradable = k.readBoolean();
            this._isGroupable = k.readBoolean();
            this._isSellable = k.readBoolean();
            this._secondsToExpiration = k.readInteger();
            this._expirationTimeStamp = flash.Lib.getTimer();
            if (this.secondsToExpiration > -1)
            {
                this._rentable = true;
            }
            else
            {
                this._rentable = false;
                this._secondsToExpiration = -1;
            }
            this._hasRentPeriodStarted = k.readBoolean();
            this._flatId = k.readInteger();
            this._isWallItem = (this._furniType == WALL_ITEM);
            if (this._furniType == FLOOR_ITEM)
            {
                this._slotId = k.readString();
                this._extra = k.readInteger();
            }
        }

        public var itemId(get,never):Int;
public function  get_itemId():Int
        {
            return this._itemId;
        }

        public var furniType(get,never):String;
public function  get_furniType():String
        {
            return this._furniType;
        }

        public var ref(get,never):Int;
public function  get_ref():Int
        {
            return this._ref;
        }

        public var spriteId(get,never):Int;
public function  get_spriteId():Int
        {
            return this._spriteId;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var stuffData(get,never):IStuffData;
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }

        public var isGroupable(get,never):Bool;
public function  get_isGroupable():Bool
        {
            return this._isGroupable;
        }

        public var isRecycleable(get,never):Bool;
public function  get_isRecycleable():Bool
        {
            return this._isRecyclable;
        }

        public var tradable(get,never):Bool;
public function  get_tradable():Bool
        {
            return this._tradable;
        }

        public var sellable(get,never):Bool;
public function  get_sellable():Bool
        {
            return this._isSellable;
        }

        public var secondsToExpiration(get,never):Int;
public function  get_secondsToExpiration():Int
        {
            return this._secondsToExpiration;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }

        public var slotId(get,never):String;
public function  get_slotId():String
        {
            return this._slotId;
        }

        public var songId(get,never):Int;
public function  get_songId():Int
        {
            return this._songId;
        }

        public var extra(get,never):Int;
public function  get_extra():Int
        {
            return this._extra;
        }

        public var rentable(get,never):Bool;
public function  get_rentable():Bool
        {
            return this._rentable;
        }

        public var isWallItem(get,never):Bool;
public function  get_isWallItem():Bool
        {
            return this._isWallItem;
        }

        public var hasRentPeriodStarted(get,never):Bool;
public function  get_hasRentPeriodStarted():Bool
        {
            return this._hasRentPeriodStarted;
        }

        public var expirationTimeStamp(get,never):Int;
public function  get_expirationTimeStamp():Int
        {
            return this._expirationTimeStamp;
        }

        public var creationDay(get,never):Int;
public function  get_creationDay():Int
        {
            return 0;
        }

        public var creationMonth(get,never):Int;
public function  get_creationMonth():Int
        {
            return 0;
        }

        public var creationYear(get,never):Int;
public function  get_creationYear():Int
        {
            return 0;
        }

        public var isExternalImageFurni(get,never):Bool;
public function  get_isExternalImageFurni():Bool
        {
            return !(this._furniType.indexOf("external_image") == -1);
        }
    }

