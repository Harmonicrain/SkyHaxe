package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /**
     * Wired 2.0 base definition (kept the legacy class name `Triggerable` so the
     * ~60 wired type classes and the controller that reference this type compile
     * unchanged). Reads the expanded packet in the exact order Arcturus
     * InteractionWired.serializeWiredDataNew writes it.
     *
     * Two virtual hooks let subclasses read type-specific fields:
     *   readDefinitionSpecifics - between `code` and advancedMode
     *   readTypeSpecifics       - between allowWallFurni and WiredContext
     */
     class Triggerable
    {
        static inline final MAX_FURNI_IDS= 10000;
        static inline final MAX_INT_PARAMS= 4096;
        static inline final MAX_VARIABLE_IDS= 4096;
        static inline final MAX_SOURCE_TYPES= 256;
        static inline final MAX_DEFAULT_INT_PARAMS= 4096;

        var _furniLimit:Int = 0;
        var _stuffIds:Array<ASAny>;
        var _stuffIds2:Array<ASAny>;
        var _stuffTypeId:Int = 0;
        var _id:Int = 0;
        var _stringParam:String;
        var _intParams:Array<ASAny>;
        var _variableIds:Array<ASAny>;        // strings
        var _furniSourceTypes:Array<ASAny>;
        var _userSourceTypes:Array<ASAny>;
        var _code:Int = 0;
        var _advancedMode:Bool = false;
        var _inputSourcesConf:InputSourcesConf;
        var _allowWallFurni:Bool = false;
        var _wiredContext:WiredContext;
        var _defaultIntParams:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._stuffIds = new Array<ASAny>();
            this._stuffIds2 = new Array<ASAny>();
            this._intParams = new Array<ASAny>();
            this._variableIds = new Array<ASAny>();
            this._furniSourceTypes = new Array<ASAny>();
            this._userSourceTypes = new Array<ASAny>();
            this._defaultIntParams = new Array<ASAny>();

            var count:Int;
            var index:Int;

            this._furniLimit = k.readInteger();

            count = WiredMessageDataValidator.readCount(k, 4, MAX_FURNI_IDS, "Triggerable primary furni ids");
            for (index in 0...count) { this._stuffIds.push(k.readInteger()); }

            count = WiredMessageDataValidator.readCount(k, 4, MAX_FURNI_IDS, "Triggerable secondary furni ids");
            for (index in 0...count) { this._stuffIds2.push(k.readInteger()); }

            this._stuffTypeId = k.readInteger();
            this._id = k.readInteger();
            this._stringParam = k.readString();

            count = WiredMessageDataValidator.readCount(k, 4, MAX_INT_PARAMS, "Triggerable integer params");
            for (index in 0...count) { this._intParams.push(k.readInteger()); }

            count = WiredMessageDataValidator.readCount(k, 2, MAX_VARIABLE_IDS, "Triggerable variable ids");
            for (index in 0...count) { this._variableIds.push(k.readString()); }

            count = WiredMessageDataValidator.readCount(k, 4, MAX_SOURCE_TYPES, "Triggerable furni source types");
            for (index in 0...count) { this._furniSourceTypes.push(k.readInteger()); }

            count = WiredMessageDataValidator.readCount(k, 4, MAX_SOURCE_TYPES, "Triggerable user source types");
            for (index in 0...count) { this._userSourceTypes.push(k.readInteger()); }

            this._code = k.readInteger();

            this.readDefinitionSpecifics(k);

            this._advancedMode = k.readBoolean();
            this._inputSourcesConf = new InputSourcesConf(k);
            this.normalizeSourceTypes();
            this._allowWallFurni = k.readBoolean();

            this.readTypeSpecifics(k);

            this._wiredContext = new WiredContext(k);

            count = WiredMessageDataValidator.readCount(k, 4, MAX_DEFAULT_INT_PARAMS,
                "Triggerable default integer params");
            for (index in 0...count) { this._defaultIntParams.push(k.readInteger()); }
        }

        function readDefinitionSpecifics(k:IMessageDataWrapper) { }
        function readTypeSpecifics(k:IMessageDataWrapper) { }

        function normalizeSourceTypes()
        {
            normalizeArray(this._furniSourceTypes, this._inputSourcesConf.defaultFurniSources, this._inputSourcesConf.allowedFurniSources);
            normalizeArray(this._userSourceTypes, this._inputSourcesConf.defaultUserSources, this._inputSourcesConf.allowedUserSources);
        }

        static function normalizeArray(target:Array<ASAny>, defaults:Array<ASAny>, allowed:Array<ASAny>)
        {
            var index:Int;
            var slot:Array<ASAny>;
            var value:Int;
            var desired= Std.int(Math.max(defaults.length, allowed.length));
            for (index in 0...desired)
            {
                if (index < target.length)
                {
                    continue;
                }
                if (index < defaults.length)
                {
                    value = ASCompat.toInt(defaults[index]);
                }
                else
                {
                    slot = ASCompat.dynamicAs(allowed[index] , Array);
                    value = (slot != null && slot.length > 0) ? ASCompat.toInt(slot[0]) : 0;
                }
                target.push(value);
            }
        }

        // ---- legacy getter names (kept for the existing type classes / controller) ----
        public var stuffTypeSelectionEnabled(get,never):Bool;
function  get_stuffTypeSelectionEnabled():Bool { return false; }
                public var _Str_6040(get,set):Int;
function  get__Str_6040():Int { return 0; }
function  set__Str_6040(k:Int):Int{ return k;
}
        public var maximumItemSelectionCount(get,never):Int;
function  get_maximumItemSelectionCount():Int { return this._furniLimit; }
        public var selectedItems(get,never):Array<ASAny>;
function  get_selectedItems():Array<ASAny> { return this._stuffIds; }
        public var id(get,never):Int;
function  get_id():Int { return this._id; }
        public var stringData(get,never):String;
function  get_stringData():String { return this._stringParam; }
        public var intData(get,never):Array<ASAny>;
function  get_intData():Array<ASAny> { return this._intParams; }
        public var code(get,never):Int;
function  get_code():Int { return this._code; }
        public var spriteId(get,never):Int;
function  get_spriteId():Int { return this._stuffTypeId; }
        public function getBoolean(k:Int):Bool { return this._intParams[k] == 1; }

        // ---- Wired 2.0 additions ----
        public var selectedItems2(get,never):Array<ASAny>;
function  get_selectedItems2():Array<ASAny> { return this._stuffIds2; }
                public var variableIds(get,set):Array<ASAny>;
function  get_variableIds():Array<ASAny> { return this._variableIds; }
function  set_variableIds(k:Array<ASAny>):Array<ASAny>{ this._variableIds = k != null ? k : []; return k;
}
        public var intParams(never,set):Array<ASAny>;
function  set_intParams(k:Array<ASAny>):Array<ASAny>{ this._intParams = k != null ? k : []; return k;
}
        public var stringParam(never,set):String;
function  set_stringParam(k:String):String{ this._stringParam = k != null ? k : ""; return k;
}
        public var stuffIds(never,set):Array<ASAny>;
function  set_stuffIds(k:Array<ASAny>):Array<ASAny>{ this._stuffIds = k != null ? k : []; return k;
}
        public var stuffIds2(never,set):Array<ASAny>;
function  set_stuffIds2(k:Array<ASAny>):Array<ASAny>{ this._stuffIds2 = k != null ? k : []; return k;
}
                public var furniSourceTypes(get,set):Array<ASAny>;
function  get_furniSourceTypes():Array<ASAny> { return this._furniSourceTypes; }
function  set_furniSourceTypes(k:Array<ASAny>):Array<ASAny>{ this._furniSourceTypes = k != null ? k : []; return k;
}
                public var userSourceTypes(get,set):Array<ASAny>;
function  get_userSourceTypes():Array<ASAny> { return this._userSourceTypes; }
function  set_userSourceTypes(k:Array<ASAny>):Array<ASAny>{ this._userSourceTypes = k != null ? k : []; return k;
}
        public var advancedMode(get,never):Bool;
function  get_advancedMode():Bool { return this._advancedMode; }
        public var usingCustomInputSources(get,never):Bool;
function  get_usingCustomInputSources():Bool { return this._inputSourcesConf.isUsingAdvancedSettings(this._furniSourceTypes, this._userSourceTypes); }
        public var inputSourcesConf(get,never):InputSourcesConf;
function  get_inputSourcesConf():InputSourcesConf { return this._inputSourcesConf; }
        public var allowWallFurni(get,never):Bool;
function  get_allowWallFurni():Bool { return this._allowWallFurni; }
        public var wiredContext(get,never):WiredContext;
function  get_wiredContext():WiredContext { return this._wiredContext; }
        public var defaultIntParams(get,never):Array<ASAny>;
function  get_defaultIntParams():Array<ASAny> { return this._defaultIntParams; }
    }

