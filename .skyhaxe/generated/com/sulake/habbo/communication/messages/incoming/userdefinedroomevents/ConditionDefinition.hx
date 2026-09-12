package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ConditionDefinition extends Triggerable
    {
        var _quantifierCode:Int = 0;
        var _quantifierType:Int = 0;
        var _isInvert:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            super(k);
        }

        override function readDefinitionSpecifics(k:IMessageDataWrapper)
        {
            this._quantifierCode = k.readInteger();
        }

        override function readTypeSpecifics(k:IMessageDataWrapper)
        {
            this._quantifierType = k.readByte();
            this._isInvert = k.readBoolean();
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this.code;
        }

        
        public var quantifierCode(get,set):Int;
public function  get_quantifierCode():Int
        {
            return this._quantifierCode;
        }
public function  set_quantifierCode(k:Int):Int        {
            return this._quantifierCode = k;
        }

        public var quantifierType(get,never):Int;
public function  get_quantifierType():Int
        {
            return this._quantifierType;
        }

        public var isInvert(get,never):Bool;
public function  get_isInvert():Bool
        {
            return this._isInvert;
        }
    }

