package com.sulake.habbo.roomevents.wired_setup.inputsources
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.InputSourcesConf;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.IWiredElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;

     class WiredInputSourcePicker implements ISourceTypeListener
    {
        public static inline final FURNI_SOURCE= 0;
        public static inline final USER_SOURCE= 1;
        public static inline final MERGED_SOURCE= 2;

        public static inline final STUFF_PICKING_MODE_NONE= 0;
        public static inline final STUFF_PICKING_MODE_1= 1;
        public static inline final STUFF_PICKING_MODE_2= 2;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _sourceType:Int = 0;
        var _id:Int = 0;
        var _definition:Triggerable;
        var _element:IWiredElement;
        var _selectionCache:ASDictionary<ASAny,ASAny>;
        var _selectedText:String = "";
        var _stuffPickingSpecialMode:Int = 0;
        var _buttonsDisabled:Bool = false;
        var _disabled:Bool = false;
        var _disposed:Bool = false;

        public function new(k:HabboUserDefinedRoomEvents, _arg_2:Int, _arg_3:Int)
        {
            this._roomEvents = k;
            this._sourceType = _arg_2;
            this._id = _arg_3;
            if (this._sourceType == MERGED_SOURCE)
            {
                this._selectionCache = new ASDictionary<ASAny,ASAny>();
            }
        }

        public static function getTypeNameForSource(k:Int):String
        {
            if (k == FURNI_SOURCE) { return "furni"; }
            if (k == USER_SOURCE) { return "users"; }
            if (k == VariableExtraSourceTypes.CONTEXT_SOURCE) { return "context"; }
            if (k == VariableExtraSourceTypes.GLOBAL_SOURCE) { return "global"; }
            return "";
        }

        public function onChangeInputSource(k:Bool)
        {
            var allowed= currentAllowedSources();
            if (allowed == null || allowed.length == 0)
            {
                return;
            }
            var current= currentSelectedValue();
            var index= allowed.indexOf(current);
            if (index == -1)
            {
                index = 0;
            }
            else if (k)
            {
                index = (index + 1) % allowed.length;
            }
            else
            {
                index = (index - 1 + allowed.length) % allowed.length;
            }
            setCurrentSelectedValue(ASCompat.toInt(allowed[index]));
            refreshContainer(this._definition, this._element);
        }

        
        public var sourceType(get,set):Int;
public function  set_sourceType(k:Int):Int        {
            if (this._sourceType != MERGED_SOURCE || this._definition == null || this._element == null)
            {
                return k;
            }
            var oldType= this._element.getMergedType(this._id);
            var merged:Array<ASAny> = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return k;
            }
            if (oldType == FURNI_SOURCE)
            {
                this._selectionCache[oldType] = this._definition.furniSourceTypes[ASCompat.toInt(merged[0])];
            }
            else if (oldType == USER_SOURCE)
            {
                this._selectionCache[oldType] = this._definition.userSourceTypes[ASCompat.toInt(merged[1])];
            }
            this._element.setMergedType(this._id, k);
            var conf= this._definition.inputSourcesConf;
            if (k == FURNI_SOURCE)
            {
                this._definition.furniSourceTypes[ASCompat.toInt(merged[0])] = this._selectionCache.exists(k ) ? this._selectionCache[k] : firstOrZero(conf.getAllowedFurniSources(ASCompat.toInt(merged[0])));
            }
            else if (k == USER_SOURCE)
            {
                this._definition.userSourceTypes[ASCompat.toInt(merged[1])] = this._selectionCache.exists(k ) ? this._selectionCache[k] : firstOrZero(conf.getAllowedUserSources(ASCompat.toInt(merged[1])));
            }
            refreshContainer(this._definition, this._element);
return k;
        }

        public function refreshContainer(k:Triggerable, _arg_2:IWiredElement)
        {
var ids:Array<ASAny>  = null;            if (this._definition != k || this._element != _arg_2)
            {
                this._definition = k;
                this._element = _arg_2;
                if (this._sourceType == MERGED_SOURCE)
                {
                    this._selectionCache = new ASDictionary<ASAny,ASAny>();
                }
            }
            var typeName= currentTypeName();
            var selectedValue= currentSelectedValue();
            var custom= isCustomSource();
            var key= custom ? ("wiredfurni.params.sources." + typeName) : ("wiredfurni.params.sources." + typeName + "." + Std.string(selectedValue));
            var text= this._roomEvents.localization.getLocalization(key, key);
            this._stuffPickingSpecialMode = STUFF_PICKING_MODE_NONE;
            if (typeName == "furni")
            {
ids= null;
                if (selectedValue == InputSourcesConf.FURNI_SOURCE_FURNI_PICKS_1 || selectedValue == InputSourcesConf.FURNI_SOURCE_DUAL_MODE)
                {
                    ids = this._roomEvents.wiredCtrl.getStuffIds();
                    this._stuffPickingSpecialMode = STUFF_PICKING_MODE_1;
                }
                else if (selectedValue == InputSourcesConf.FURNI_SOURCE_FURNI_PICKS_2)
                {
                    ids = this._roomEvents.wiredCtrl.getStuffIds2();
                    this._stuffPickingSpecialMode = STUFF_PICKING_MODE_2;
                }
                if (ids != null && (k.inputSourcesConf.isDualFurniPickingMode() || this._roomEvents.wiredCtrl.hidePickFurniInstructions))
                {
                    text += " [" + Std.string(ids.length) + "/" + Std.string(k.maximumItemSelectionCount) + "]";
                }
            }
            this._buttonsDisabled = custom;
            this._selectedText = text;
            this._disabled = _arg_2.isInputSourceDisabled(this._id, this._sourceType);
        }

        function currentAllowedSources():Array<ASAny>
        {
            var conf= this._definition.inputSourcesConf;
            if (this._sourceType == FURNI_SOURCE)
            {
                return conf.getAllowedFurniSources(this._id);
            }
            if (this._sourceType == USER_SOURCE)
            {
                return conf.getAllowedUserSources(this._id);
            }
            var merged:Array<ASAny> = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return [];
            }
            return this._element.getMergedType(this._id) == FURNI_SOURCE
                ? conf.getAllowedFurniSources(ASCompat.toInt(merged[0]))
                : conf.getAllowedUserSources(ASCompat.toInt(merged[1]));
        }

        function currentSelectedValue():Int
        {
            if (this._sourceType == FURNI_SOURCE)
            {
                return ASCompat.toInt(this._definition.furniSourceTypes[this._id]);
            }
            if (this._sourceType == USER_SOURCE)
            {
                return ASCompat.toInt(this._definition.userSourceTypes[this._id]);
            }
            var merged:Array<ASAny> = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return 0;
            }
            return this._element.getMergedType(this._id) == FURNI_SOURCE
                ? ASCompat.toInt(this._definition.furniSourceTypes[ASCompat.toInt(merged[0])])
                : ASCompat.toInt(this._definition.userSourceTypes[ASCompat.toInt(merged[1])]);
        }

        function setCurrentSelectedValue(k:Int)
        {
            if (this._sourceType == FURNI_SOURCE)
            {
                this._definition.furniSourceTypes[this._id] = k;
                return;
            }
            if (this._sourceType == USER_SOURCE)
            {
                this._definition.userSourceTypes[this._id] = k;
                return;
            }
            var merged:Array<ASAny> = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return;
            }
            if (this._element.getMergedType(this._id) == FURNI_SOURCE)
            {
                this._definition.furniSourceTypes[ASCompat.toInt(merged[0])] = k;
            }
            else
            {
                this._definition.userSourceTypes[ASCompat.toInt(merged[1])] = k;
            }
        }

        function currentTypeName():String
        {
            if (this._sourceType == FURNI_SOURCE)
            {
                return "furni";
            }
            if (this._sourceType == USER_SOURCE)
            {
                return "users";
            }
            return getTypeNameForSource(this._element.getMergedType(this._id));
        }

        function isCustomSource():Bool
        {
            return this._sourceType == MERGED_SOURCE
                && this._element.getMergedType(this._id) != FURNI_SOURCE
                && this._element.getMergedType(this._id) != USER_SOURCE;
        }

        static function firstOrZero(k:Array<ASAny>):Int
        {
            return (k != null && k.length > 0) ? ASCompat.toInt(k[0]) : 0;
        }
public function  get_sourceType():Int { return this._sourceType; }
        public var id(get,never):Int;
public function  get_id():Int { return this._id; }
        public var selectedText(get,never):String;
public function  get_selectedText():String { return this._selectedText; }
        public var isButtonsDisabled(get,never):Bool;
public function  get_isButtonsDisabled():Bool { return this._buttonsDisabled; }
        public var stuffPickingSpecialMode(get,never):Int;
public function  get_stuffPickingSpecialMode():Int { return this._stuffPickingSpecialMode; }
        public var disabled(get,never):Bool;
public function  get_disabled():Bool { return this._disabled; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._roomEvents = null;
            this._definition = null;
            this._element = null;
            this._selectionCache = null;
            this._disposed = true;
        }
    }

