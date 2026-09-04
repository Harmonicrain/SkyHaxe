package com.sulake.habbo.communication.messages.incoming.inventory.avatareffect
;
     class AvatarEffect
    {
        var _type:Int = 0;
        var _subType:Int = 0;
        var _duration:Int = 0;
        var _Str_20427:Int = 0;
        var _Str_22152:Int = 0;
        var _Str_5145:Bool = false;


        
        public var type(get,set):Int;
function  get_type():Int
        {
            return this._type;
        }
function  set_type(k:Int):Int        {
            return this._type = k;
        }

        
        public var subType(get,set):Int;
function  get_subType():Int
        {
            return this._subType;
        }
function  set_subType(k:Int):Int        {
            return this._subType = k;
        }

        
        public var duration(get,set):Int;
function  get_duration():Int
        {
            return this._duration;
        }
function  set_duration(k:Int):Int        {
            return this._duration = k;
        }

        
        public var amount(get,set):Int;
function  get_amount():Int
        {
            return this._Str_20427;
        }
function  set_amount(k:Int):Int        {
            return this._Str_20427 = k;
        }

        
        public var secondsRemaining(get,set):Int;
function  get_secondsRemaining():Int
        {
            return this._Str_22152;
        }
function  set_secondsRemaining(k:Int):Int        {
            return this._Str_22152 = k;
        }

        
        public var isPermanent(get,set):Bool;
function  get_isPermanent():Bool
        {
            return this._Str_5145;
        }
function  set_isPermanent(k:Bool):Bool        {
            return this._Str_5145 = k;
        }

	public function new() {}
    }

