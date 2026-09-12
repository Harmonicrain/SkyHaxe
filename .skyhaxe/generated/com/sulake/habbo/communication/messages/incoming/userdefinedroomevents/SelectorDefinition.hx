package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SelectorDefinition extends Triggerable
    {
        var _isFilter:Bool = false;
        var _isInvert:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            super(k);
        }

        override function readDefinitionSpecifics(k:IMessageDataWrapper)
        {
            this._isFilter = k.readBoolean();
            this._isInvert = k.readBoolean();
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this.code;
        }

        
        public var isFilter(get,set):Bool;
public function  get_isFilter():Bool
        {
            return this._isFilter;
        }
public function  set_isFilter(k:Bool):Bool        {
            return this._isFilter = k;
        }

        
        public var isInvert(get,set):Bool;
public function  get_isInvert():Bool
        {
            return this._isInvert;
        }
public function  set_isInvert(k:Bool):Bool        {
            return this._isInvert = k;
        }
    }

