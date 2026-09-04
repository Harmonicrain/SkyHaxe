package com.sulake.habbo.communication.messages.outgoing.camera.json
;
     class JsonMaskDrawingData 
    {
        var _name:String;
        var _location:JsonPoint;
        var _flipH:Bool = false;
        var _flipV:Bool = false;

        public function new(k:String, _arg_2:JsonPoint, _arg_3:Bool, _arg_4:Bool)
        {
            this._name = k;
            this._location = _arg_2;
            this._flipH = _arg_3;
            this._flipV = _arg_4;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var location(get,never):JsonPoint;
function  get_location():JsonPoint
        {
            return this._location;
        }

        public var flipH(get,never):Bool;
function  get_flipH():Bool
        {
            return this._flipH;
        }

        public var flipV(get,never):Bool;
function  get_flipV():Bool
        {
            return this._flipV;
        }
    }

