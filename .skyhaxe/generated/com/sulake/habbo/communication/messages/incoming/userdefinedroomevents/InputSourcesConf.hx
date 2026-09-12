package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /**
     * Wired 2.0 input-source configuration. Read order matches the Arcturus
     * serializeInputSourcesConf: allowedFurniSources (2D), allowedUserSources (2D),
     * defaultFurniSources (flat), defaultUserSources (flat).
     */
     class InputSourcesConf
    {
        public static inline final FURNI_SOURCE_FURNI_PICKS_1= 100;
        public static inline final FURNI_SOURCE_FURNI_PICKS_2= 101;
        public static inline final FURNI_SOURCE_DUAL_MODE= 110;
        static inline final MAX_SOURCE_SLOTS= 256;
        static inline final MAX_SOURCES_PER_SLOT= 256;
        static inline final MAX_DEFAULT_SOURCES= 256;

        var _allowedFurniSources:Array<ASAny>; // Array of Array<int>
        var _allowedUserSources:Array<ASAny>;  // Array of Array<int>
        var _defaultFurniSources:Array<ASAny>; // Array<int>
        var _defaultUserSources:Array<ASAny>;  // Array<int>

        public function new(k:IMessageDataWrapper)
        {
            this._allowedFurniSources = readAllowedSources(k);
            this._allowedUserSources = readAllowedSources(k);
            this._defaultFurniSources = readFlatSources(k);
            this._defaultUserSources = readFlatSources(k);
        }

        static function readAllowedSources(k:IMessageDataWrapper):Array<ASAny>
        {
var i = 0, slot:Array<ASAny>  = null, innerCount = 0, j = 0;            var outer= new Array<ASAny>();
            var outerCount= WiredMessageDataValidator.readCount(k, 4, MAX_SOURCE_SLOTS,
                "InputSourcesConf source slots");
            for (_tmp_ in 0...outerCount)
            {
i= _tmp_;
slot= new Array<ASAny>();
innerCount= WiredMessageDataValidator.readCount(k, 4, MAX_SOURCES_PER_SLOT,
                    "InputSourcesConf slot sources");
                for (_tmp_ in 0...innerCount)
                {
j= _tmp_;
                    slot.push(k.readInteger());
                }
                outer.push(slot);
            }
            return outer;
        }

        static function readFlatSources(k:IMessageDataWrapper):Array<ASAny>
        {
var i = 0;            var out= new Array<ASAny>();
            var count= WiredMessageDataValidator.readCount(k, 4, MAX_DEFAULT_SOURCES,
                "InputSourcesConf default sources");
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                out.push(k.readInteger());
            }
            return out;
        }

        public var allowedFurniSources(get,never):Array<ASAny>;
public function  get_allowedFurniSources():Array<ASAny> { return this._allowedFurniSources; }
        public var allowedUserSources(get,never):Array<ASAny>;
public function  get_allowedUserSources():Array<ASAny> { return this._allowedUserSources; }
        public var defaultFurniSources(get,never):Array<ASAny>;
public function  get_defaultFurniSources():Array<ASAny> { return this._defaultFurniSources; }
        public var defaultUserSources(get,never):Array<ASAny>;
public function  get_defaultUserSources():Array<ASAny> { return this._defaultUserSources; }
        public var amountFurniSelections(get,never):Int;
public function  get_amountFurniSelections():Int { return this._allowedFurniSources.length; }
        public var amountUserSelections(get,never):Int;
public function  get_amountUserSelections():Int { return this._allowedUserSources.length; }

        public function getAllowedFurniSources(k:Int):Array<ASAny>
        {
            if (k < 0 || k >= this._allowedFurniSources.length)
            {
                return [];
            }
            return this._allowedFurniSources[k];
        }

        public function getAllowedUserSources(k:Int):Array<ASAny>
        {
            if (k < 0 || k >= this._allowedUserSources.length)
            {
                return [];
            }
            return this._allowedUserSources[k];
        }

        public function isUsingAdvancedSettings(k:Array<ASAny>, _arg_2:Array<ASAny>):Bool
        {
var             index = 0;            var index = 0;
            index= 0;while (index < this._defaultFurniSources.length)
            {
                if (index >= k.length || this._defaultFurniSources[index] != k[index])
                {
                    return true;
                }
index++;
            }
            index= 0;while (index < this._defaultUserSources.length)
            {
                if (index >= _arg_2.length || this._defaultUserSources[index] != _arg_2[index])
                {
                    return true;
                }
index++;
            }
            return false;
        }

        public function allowFurniSelection():Bool
        {
var slot:Array<ASAny>  = null;            final _iter_ = this._allowedFurniSources; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
slot = _tmp_;
                if (slot.indexOf(FURNI_SOURCE_FURNI_PICKS_1) != -1
                    || slot.indexOf(FURNI_SOURCE_FURNI_PICKS_2) != -1
                    || slot.indexOf(FURNI_SOURCE_DUAL_MODE) != -1)
                {
                    return true;
                }
            }
            return false;
        }

        public function isDualFurniPickingMode():Bool
        {
var slot:Array<ASAny>  = null;            var hasPrimary= false;
            var hasSecondary= false;
            final _iter_ = this._allowedFurniSources; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
slot = _tmp_;
                if (slot.indexOf(FURNI_SOURCE_FURNI_PICKS_1) != -1 || slot.indexOf(FURNI_SOURCE_DUAL_MODE) != -1)
                {
                    hasPrimary = true;
                }
                if (slot.indexOf(FURNI_SOURCE_FURNI_PICKS_2) != -1)
                {
                    hasSecondary = true;
                }
            }
            return hasPrimary && hasSecondary;
        }

        public function isFurniSelectionDefault():Bool
        {
            return this._defaultFurniSources.indexOf(FURNI_SOURCE_FURNI_PICKS_1) != -1
                || this._defaultFurniSources.indexOf(FURNI_SOURCE_FURNI_PICKS_2) != -1
                || this._defaultFurniSources.indexOf(FURNI_SOURCE_DUAL_MODE) != -1;
        }
    }

