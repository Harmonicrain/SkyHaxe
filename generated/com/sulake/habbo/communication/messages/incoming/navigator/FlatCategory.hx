package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FlatCategory 
    {
        var _nodeId:Int = 0;
        var _nodeName:String;
        var _visible:Bool = false;
        var _automatic:Bool = false;
        var _Str_21646:String;
        var _Str_13882:String;
        var _Str_22231:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._nodeId = k.readInteger();
            this._nodeName = k.readString();
            this._visible = k.readBoolean();
            this._automatic = k.readBoolean();
            this._Str_21646 = k.readString();
            this._Str_13882 = k.readString();
            this._Str_22231 = k.readBoolean();
        }

        public var nodeId(get,never):Int;
function  get_nodeId():Int
        {
            return this._nodeId;
        }

        public var nodeName(get,never):String;
function  get_nodeName():String
        {
            return this._nodeName;
        }

        public var visible(get,never):Bool;
function  get_visible():Bool
        {
            return this._visible;
        }

        public var automatic(get,never):Bool;
function  get_automatic():Bool
        {
            return this._automatic;
        }

        public var _Str_13024(get,never):Bool;
function  get__Str_13024():Bool
        {
            return this._Str_22231;
        }

        public var _Str_26018(get,never):String;
function  get__Str_26018():String
        {
            return this._Str_21646;
        }

        public var _Str_26359(get,never):String;
function  get__Str_26359():String
        {
            return this._Str_13882;
        }

        public var _Str_14718(get,never):String;
function  get__Str_14718():String
        {
            return (this._Str_13882 == "") ? this._nodeName : (("${navigator.flatcategory.global." + this._Str_13882) + "}");
        }
    }

