package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.utils.Map;

    /** July Wired 2.0 variable metadata record. */
     class WiredVariable
    {
        public static inline final NONE_ID= "n";
        static inline final MINIMUM_BYTES:UInt = 25;
        static inline final MAX_TEXT_CONNECTORS= 4096;

        var _variableId:String;
        var _variableType:Int = 0;
        var _variableName:String;
        var _availabilityType:Int = 0;
        var _variableTarget:Int = 0;
        var _alwaysAvailable:Bool = false;
        var _canCreateAndDelete:Bool = false;
        var _hasValue:Bool = false;
        var _canWriteValue:Bool = false;
        var _canInterceptChanges:Bool = false;
        var _isInvisible:Bool = false;
        var _canReadCreationTime:Bool = false;
        var _canReadLastUpdateTime:Bool = false;
        var _textConnector:Map;

        public function new(k:IMessageDataWrapper)
        {
var count = 0, index = 0;            WiredMessageDataValidator.requireBytes(k, MINIMUM_BYTES, "WiredVariable");
            this._variableId = k.readString();
            this._variableType = k.readInteger();
            this._variableName = k.readString();
            this._availabilityType = k.readInteger();
            this._variableTarget = k.readInteger();
            this._alwaysAvailable = k.readBoolean();
            this._canCreateAndDelete = k.readBoolean();
            this._hasValue = k.readBoolean();
            this._canWriteValue = k.readBoolean();
            this._canInterceptChanges = k.readBoolean();
            this._isInvisible = k.readBoolean();
            this._canReadCreationTime = k.readBoolean();
            this._canReadLastUpdateTime = k.readBoolean();

            var hasTextConnector= k.readBoolean();
            if (hasTextConnector)
            {
                this._textConnector = new Map();
count= WiredMessageDataValidator.readCount(k, 6, MAX_TEXT_CONNECTORS,
                    "WiredVariable text connectors");
                for (_tmp_ in 0...count)
                {
index= _tmp_;
                    this._textConnector.add(k.readInteger(), k.readString());
                }
            }
        }

        public var variableId(get,never):String;
public function  get_variableId():String { return this._variableId; }
        public var variableType(get,never):Int;
public function  get_variableType():Int { return this._variableType; }
        public var variableName(get,never):String;
public function  get_variableName():String { return this._variableName; }
        public var availabilityType(get,never):Int;
public function  get_availabilityType():Int { return this._availabilityType; }
        public var variableTarget(get,never):Int;
public function  get_variableTarget():Int { return this._variableTarget; }
        public var alwaysAvailable(get,never):Bool;
public function  get_alwaysAvailable():Bool { return this._alwaysAvailable; }
        public var canCreateAndDelete(get,never):Bool;
public function  get_canCreateAndDelete():Bool { return this._canCreateAndDelete; }
        public var hasValue(get,never):Bool;
public function  get_hasValue():Bool { return this._hasValue; }
        public var canWriteValue(get,never):Bool;
public function  get_canWriteValue():Bool { return this._canWriteValue; }
        public var canInterceptChanges(get,never):Bool;
public function  get_canInterceptChanges():Bool { return this._canInterceptChanges; }
        public var isInvisible(get,never):Bool;
public function  get_isInvisible():Bool { return this._isInvisible; }
        public var canReadCreationTime(get,never):Bool;
public function  get_canReadCreationTime():Bool { return this._canReadCreationTime; }
        public var canReadLastUpdateTime(get,never):Bool;
public function  get_canReadLastUpdateTime():Bool { return this._canReadLastUpdateTime; }
        public var hasTextConnector(get,never):Bool;
public function  get_hasTextConnector():Bool { return this._textConnector != null; }
        public var textConnector(get,never):Map;
public function  get_textConnector():Map { return this._textConnector; }
        public var isStored(get,never):Bool;
public function  get_isStored():Bool { return this._availabilityType < 100; }
        public var isPersisted(get,never):Bool;
public function  get_isPersisted():Bool
        {
            return this._availabilityType == 10 || this._availabilityType == 11 || this._availabilityType == 20;
        }
    }

