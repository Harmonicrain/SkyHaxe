package com.sulake.habbo.advertisement
;
     class AdImageRequest 
    {
        var _roomId:Int = 0;
        var _objectId:Int = 0;
        var _objectCategory:Int = 0;
        var _imageURL:String;
        var _clickURL:String;

        public function new(k:Int, _arg_2:String=null, _arg_3:String=null, _arg_4:Int=-1, _arg_5:Int=-1)
        {
            this._roomId = k;
            this._objectId = _arg_4;
            this._objectCategory = _arg_5;
            this._imageURL = _arg_2;
            this._clickURL = _arg_3;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var objectCategory(get,never):Int;
public function  get_objectCategory():Int
        {
            return this._objectCategory;
        }

        public var imageURL(get,never):String;
public function  get_imageURL():String
        {
            return this._imageURL;
        }

        public var clickURL(get,never):String;
public function  get_clickURL():String
        {
            return this._clickURL;
        }
    }

