package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** July Wired 2.0 unframed editor-context blocks. */
     class WiredContext
    {
        static inline final MAX_BLOCKS= 7;

        var _roomVariablesList:AllVariablesInRoom;
        var _furniVariableInfo:VariableInfoAndHolders;
        var _userVariableInfo:VariableInfoAndHolders;
        var _globalVariableInfo:VariableInfoAndValue;
        var _referenceVariablesList:SharedVariableList;
        var _rulesetVariables:VariableList;
        var _referencePlaceholderList:SharedGlobalPlaceholderList;

        public function new(k:IMessageDataWrapper)
        {
            var blockCount= WiredMessageDataValidator.readCount(k, 8, MAX_BLOCKS,
                "WiredContext blocks");
            var seen:ASObject = {};
            for (index in 0...blockCount)
            {
                WiredMessageDataValidator.requireBytes(k, 4, "WiredContext block type");
                var blockType= k.readInteger();
                if (seen[Std.string(blockType)] == true)
                {
                    throw new ASError("WiredContext: duplicate unframed block type " + blockType);
                }
                seen[Std.string(blockType)] = true;

                switch (blockType)
                {
                    case WiredContextBlockTypes.ALL_VARIABLES_IN_ROOM:
                        this._roomVariablesList = new AllVariablesInRoom(k);
                        
                    case WiredContextBlockTypes.FURNI_VARIABLE_INFO_AND_HOLDERS:
                        this._furniVariableInfo = new VariableInfoAndHolders(k);
                        
                    case WiredContextBlockTypes.USER_VARIABLE_INFO_AND_HOLDERS:
                        this._userVariableInfo = new VariableInfoAndHolders(k);
                        
                    case WiredContextBlockTypes.GLOBAL_VARIABLE_INFO_AND_VALUE:
                        this._globalVariableInfo = new VariableInfoAndValue(k);
                        
                    case WiredContextBlockTypes.SHARED_VARIABLE_LIST:
                        this._referenceVariablesList = new SharedVariableList(k);
                        
                    case WiredContextBlockTypes.RULESET_VARIABLE_LIST:
                        this._rulesetVariables = new VariableList(k);
                        
                    case WiredContextBlockTypes.SHARED_GLOBAL_PLACEHOLDER_LIST:
                        this._referencePlaceholderList = new SharedGlobalPlaceholderList(k);
                        
                    default:
                        throw new ASError("WiredContext: unknown unframed block type " + blockType);
                }
            }
        }

        public var roomVariablesList(get,never):AllVariablesInRoom;
function  get_roomVariablesList():AllVariablesInRoom { return this._roomVariablesList; }
        public var furniVariableInfo(get,never):VariableInfoAndHolders;
function  get_furniVariableInfo():VariableInfoAndHolders { return this._furniVariableInfo; }
        public var userVariableInfo(get,never):VariableInfoAndHolders;
function  get_userVariableInfo():VariableInfoAndHolders { return this._userVariableInfo; }
        public var globalVariableInfo(get,never):VariableInfoAndValue;
function  get_globalVariableInfo():VariableInfoAndValue { return this._globalVariableInfo; }
        public var referenceVariablesList(get,never):SharedVariableList;
function  get_referenceVariablesList():SharedVariableList { return this._referenceVariablesList; }
        public var rulesetVariables(get,never):VariableList;
function  get_rulesetVariables():VariableList { return this._rulesetVariables; }
        public var referencePlaceholderList(get,never):SharedGlobalPlaceholderList;
function  get_referencePlaceholderList():SharedGlobalPlaceholderList { return this._referencePlaceholderList; }
    }

