package com.sulake.habbo.session.events
;
    import flash.display.BitmapData;
    import flash.events.Event;

     class FurniIconImageReadyEvent extends Event
    {
        public static inline final ICON_READY= "FIIRE_ICON_READY";

        var _assetName:String;
        var _wallItem:Bool = false;
        var _typeId:Int = 0;
        var _extra:String;
        var _furniIconImage:BitmapData;
        var _success:Bool = false;

        public function new(assetName:String, wallItem:Bool, typeId:Int, extra:String, furniIconImage:BitmapData, success:Bool=true, bubbles:Bool=false, cancelable:Bool=false)
        {
            super(ICON_READY, bubbles, cancelable);
            this._assetName = assetName == null ? "" : assetName;
            this._wallItem = wallItem;
            this._typeId = typeId;
            this._extra = extra == null ? "" : extra;
            this._furniIconImage = furniIconImage;
            this._success = success;
        }

        public var assetName(get,never):String;
function  get_assetName():String
        {
            return this._assetName;
        }

        public var wallItem(get,never):Bool;
function  get_wallItem():Bool
        {
            return this._wallItem;
        }

        public var typeId(get,never):Int;
function  get_typeId():Int
        {
            return this._typeId;
        }

        public var extra(get,never):String;
function  get_extra():String
        {
            return this._extra;
        }

        public var furniIconImage(get,never):BitmapData;
function  get_furniIconImage():BitmapData
        {
            return this._furniIconImage;
        }

        public var success(get,never):Bool;
function  get_success():Bool
        {
            return this._success;
        }

        override public function clone():Event
        {
            return new FurniIconImageReadyEvent(this._assetName, this._wallItem, this._typeId, this._extra, this._furniIconImage, this._success, bubbles, cancelable);
        }
    }

