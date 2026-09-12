package com.sulake.habbo.freeflowchat.history.visualization.entry
;
    import flash.display.Bitmap;

     class BitmapSpriteWithUserId extends Bitmap 
    {
        var _userId:Int = 0;
        var _roomId:Int = 0;
        var _canIgnore:Bool = false;
        var _userName:String;


        
        public var _Str_6123(get,set):Bool;
public function  get__Str_6123():Bool
        {
            return this._canIgnore;
        }
public function  set__Str_6123(k:Bool):Bool        {
            return this._canIgnore = k;
        }

        
        public var userName(get,set):String;
public function  get_userName():String
        {
            return this._userName;
        }
public function  set_userName(k:String):String        {
            return this._userName = k;
        }

        
        public var userId(get,set):Int;
public function  get_userId():Int
        {
            return this._userId;
        }
public function  set_userId(k:Int):Int        {
            return this._userId = k;
        }

        
        public var roomId(get,set):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
public function  set_roomId(k:Int):Int        {
            return this._roomId = k;
        }

	public function new() { super(); }
    }

