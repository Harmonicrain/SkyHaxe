package com.sulake.room.renderer.utils
;
     class ObjectMouseData 
    {
        var _objectId:String = "";
        var _spriteTag:String = "";

        
        public var objectId(get,set):String;
public function  get_objectId():String
        {
            return this._objectId;
        }
public function  set_objectId(k:String):String        {
            return this._objectId = k;
        }

        
        public var spriteTag(get,set):String;
public function  get_spriteTag():String
        {
            return this._spriteTag;
        }
public function  set_spriteTag(k:String):String        {
            return this._spriteTag = k;
        }
public function new(){}
    }

