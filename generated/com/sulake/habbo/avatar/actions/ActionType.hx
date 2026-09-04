package com.sulake.habbo.avatar.actions
;
     class ActionType 
    {
        var _id:Int = 0;
        var _value:Int = 0;
        var _prevents:Array<ASAny>;
        var _preventHeadTurn:Bool = true;
        var _isAnimated:Bool = true;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            this._prevents = [];
            this._id = ASCompat.parseInt(k.attribute("value").toString());
            this._value = ASCompat.parseInt(k.attribute("value").toString());
            var _local_2= k.attribute("prevents").toString();
            if (_local_2 != "")
            {
                this._prevents = (cast _local_2.split(","));
            }
            this._preventHeadTurn = (k.attribute("preventheadturn").toString() == "true");
            var _local_3= k.attribute("animated").toString();
            if (_local_3 == "")
            {
                this._isAnimated = true;
            }
            else
            {
                this._isAnimated = (_local_3 == "true");
            }
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var value(get,never):Int;
function  get_value():Int
        {
            return this._value;
        }

        public var prevents(get,never):Array<ASAny>;
function  get_prevents():Array<ASAny>
        {
            return this._prevents;
        }

        public var preventHeadTurn(get,never):Bool;
function  get_preventHeadTurn():Bool
        {
            return this._preventHeadTurn;
        }

        public var isAnimated(get,never):Bool;
function  get_isAnimated():Bool
        {
            return this._isAnimated;
        }
    }

