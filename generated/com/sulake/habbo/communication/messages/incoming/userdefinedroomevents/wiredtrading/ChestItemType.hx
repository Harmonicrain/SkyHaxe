package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;

    /** July wired-trading chest item type. */
     class ChestItemType
    {
        var _isWallItem:Bool = false;
        var _typeId:Int = 0;
        var _legacyPosterId:String;
        public function new(isWallItem:Bool, typeId:Int, legacyPosterId:String)
        { this._isWallItem=isWallItem; this._typeId=typeId; this._legacyPosterId=legacyPosterId; }
        public static function readFromMessage(data:IMessageDataWrapper):ChestItemType
        { WiredMessageDataValidator.requireBytes(data, 6, "ChestItemType"); var wall=data.readBoolean(); var type=data.readInteger(); var poster=data.readString(); return new ChestItemType(wall, type, poster==""?null:poster); }
        public var isWallItem(get,never):Bool;
function  get_isWallItem():Bool{return this._isWallItem;} public var typeId(get,never):Int;
function  get_typeId():Int{return this._typeId;} public var legacyPosterId(get,never):String;
function  get_legacyPosterId():String{return this._legacyPosterId==null?"":this._legacyPosterId;}
        public function addToComposer(out:Array<ASAny>){ASCompat.ASArray.pushMultiple(out, this._isWallItem,this._typeId,this.legacyPosterId);}
    }

