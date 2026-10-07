package com.sulake.habbo.notifications.feed.data
;
    import flash.display.BitmapData;

     class GenericNotificationItemData 
    {
        var _title:String;
        var _timeStamp:Int = 0;
        var _description:String;
        var _decorationImage:BitmapData;
        var _iconImage:BitmapData;
        var _buttonAction:String;
        var _buttonCaption:String;


        
        public var title(get,set):String;
public function  get_title():String
        {
            return this._title;
        }

        
        public var timeStamp(get,set):Int;
public function  get_timeStamp():Int
        {
            return this._timeStamp;
        }

        
        public var description(get,set):String;
public function  get_description():String
        {
            return this._description;
        }

        
        public var _Str_22203(get,set):BitmapData;
public function  get__Str_22203():BitmapData
        {
            return this._decorationImage;
        }

        
        public var icon(get,set):BitmapData;
public function  get_icon():BitmapData
        {
            return this._iconImage;
        }

        
        public var _Str_15192(get,set):String;
public function  get__Str_15192():String
        {
            return this._buttonAction;
        }

        
        public var buttonCaption(get,set):String;
public function  get_buttonCaption():String
        {
            return this._buttonCaption;
        }
public function  set_title(k:String):String        {
            return this._title = k;
        }
public function  set_timeStamp(k:Int):Int        {
            return this._timeStamp = k;
        }
public function  set_description(k:String):String        {
            return this._description = k;
        }
public function  set__Str_22203(k:BitmapData):BitmapData        {
            return this._decorationImage = k;
        }
public function  set_icon(k:BitmapData):BitmapData        {
            return this._iconImage = k;
        }
public function  set__Str_15192(k:String):String        {
            return this._buttonAction = k;
        }
public function  set_buttonCaption(k:String):String        {
            return this._buttonCaption = k;
        }
public function new(){}
    }

