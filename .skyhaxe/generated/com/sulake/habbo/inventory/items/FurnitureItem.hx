package com.sulake.habbo.inventory.items
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.IFurnitureItemData;

     class FurnitureItem implements IFurnitureItem 
    {
        var _expirationTimeStamp:Int = 0;
        var _isWallItem:Bool = false;
        var _songId:Int = 0;
        var _locked:Bool = false;
        var _id:Int = 0;
        var _ref:Int = 0;
        var _category:Int = 0;
        var _type:Int = 0;
        var _stuffData:IStuffData;
        var _extra:Float = Math.NaN;
        var _recyclable:Bool = false;
        var _tradeable:Bool = false;
        var _groupable:Bool = false;
        var _sellable:Bool = false;
        var _secondsToExpiration:Int = 0;
        var _hasRentPeriodStarted:Bool = false;
        var _creationDay:Int = 0;
        var _creationMonth:Int = 0;
        var _creationYear:Int = 0;
        var _slotId:String;
        var _isRented:Bool = false;
        var _flatId:Int = 0;

        public function new(k:IFurnitureItemData)
        {
            this._id = k.itemId;
            this._type = k.spriteId;
            this._ref = k.ref;
            this._category = k.category;
            this._groupable = (k.isGroupable && (!k.rentable));
            this._tradeable = k.tradable;
            this._recyclable = k.isRecycleable;
            this._sellable = k.sellable;
            this._stuffData = k.stuffData;
            this._extra = k.extra;
            this._secondsToExpiration = k.secondsToExpiration;
            this._expirationTimeStamp = k.expirationTimeStamp;
            this._hasRentPeriodStarted = k.hasRentPeriodStarted;
            this._creationDay = k.creationDay;
            this._creationMonth = k.creationMonth;
            this._creationYear = k.creationYear;
            this._slotId = k.slotId;
            this._songId = k.songId;
            this._flatId = k.flatId;
            this._isRented = k.rentable;
            this._isWallItem = k.isWallItem;
        }

        public var rentable(get,never):Bool;
public function  get_rentable():Bool
        {
            return this._isRented;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var ref(get,never):Int;
public function  get_ref():Int
        {
            return this._ref;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        
        public var stuffData(get,set):IStuffData;
public function  get_stuffData():IStuffData
        {
            return this._stuffData;
        }
public function  set_stuffData(k:IStuffData):IStuffData        {
            return this._stuffData = k;
        }

        public var extra(get,never):Float;
public function  get_extra():Float
        {
            return this._extra;
        }

        public var recyclable(get,never):Bool;
public function  get_recyclable():Bool
        {
            return this._recyclable;
        }

        public var tradeable(get,never):Bool;
public function  get_tradeable():Bool
        {
            return this._tradeable;
        }

        public var groupable(get,never):Bool;
public function  get_groupable():Bool
        {
            return this._groupable;
        }

        public var sellable(get,never):Bool;
public function  get_sellable():Bool
        {
            return this._sellable;
        }

        public var secondsToExpiration(get,never):Int;
public function  get_secondsToExpiration():Int
        {
            if (this._secondsToExpiration == -1)
            {
                return -1;
            }
            var k= -1;
            if (this._hasRentPeriodStarted)
            {
                k = Std.int(this._secondsToExpiration - ((flash.Lib.getTimer() - this._expirationTimeStamp) / 1000));
                if (k < 0)
                {
                    k = 0;
                }
            }
            else
            {
                k = this._secondsToExpiration;
            }
            return k;
        }

        public var creationDay(get,never):Int;
public function  get_creationDay():Int
        {
            return this._creationDay;
        }

        public var creationMonth(get,never):Int;
public function  get_creationMonth():Int
        {
            return this._creationMonth;
        }

        public var creationYear(get,never):Int;
public function  get_creationYear():Int
        {
            return this._creationYear;
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

        
        public var locked(get,set):Bool;
public function  get_locked():Bool
        {
            return this._locked;
        }
public function  set_locked(k:Bool):Bool        {
            return this._locked = k;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
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

        public function update(k:IFurnitureItemData)
        {
            this._type = k.spriteId;
            this._ref = k.ref;
            this._category = k.category;
            this._groupable = (k.isGroupable && (!k.rentable));
            this._tradeable = k.tradable;
            this._recyclable = k.isRecycleable;
            this._sellable = k.sellable;
            this._stuffData = k.stuffData;
            this._extra = k.extra;
            this._secondsToExpiration = k.secondsToExpiration;
            this._expirationTimeStamp = k.expirationTimeStamp;
            this._hasRentPeriodStarted = k.hasRentPeriodStarted;
            this._creationDay = k.creationDay;
            this._creationMonth = k.creationMonth;
            this._creationYear = k.creationYear;
            this._slotId = k.slotId;
            this._songId = k.songId;
            this._flatId = k.flatId;
            this._isRented = k.rentable;
            this._isWallItem = k.isWallItem;
        }
    }

