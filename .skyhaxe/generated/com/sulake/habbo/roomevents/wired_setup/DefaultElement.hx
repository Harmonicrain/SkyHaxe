package com.sulake.habbo.roomevents.wired_setup
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Base Wired 2.0 builder element adapted from May/July DefaultElement.
     * Provides safe defaults; concrete element types override code/inputMode/buildInputs
     * and the read*FromForm accessors.
     */
     class DefaultElement implements IWiredElement
    {
        public static var INPUTS_TYPE_NONE:Int = 0;
        public static var INPUTS_TYPE_UI_BUILDER:Int = 1;

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _initialized:Bool = false;

        public function new()
        {
        }

        public var code(get,never):Int;
public function  get_code():Int
        {
            return -1;
        }

        public var negativeCode(get,never):Int;
public function  get_negativeCode():Int
        {
            return -1;
        }

        public var inputMode(get,never):Int;
public function  get_inputMode():Int
        {
            return INPUTS_TYPE_NONE;
        }

        public var requiredCapability(get,never):Int;
public function  get_requiredCapability():Int
        {
            return 0;
        }

        public var hasStateSnapshot(get,never):Bool;
public function  get_hasStateSnapshot():Bool
        {
            return false;
        }

        public var requiresFurniSelection(get,never):Bool;
public function  get_requiresFurniSelection():Bool
        {
            return false;
        }

        public var forceFurniSelection(get,never):Bool;
public function  get_forceFurniSelection():Bool
        {
            return this.hasStateSnapshot;
        }

        public var forceHidePickFurniInstructions(get,never):Bool;
public function  get_forceHidePickFurniInstructions():Bool
        {
            return false;
        }

        public function furniSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.furni.title";
        }

        public function userSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.users.title";
        }

        public function mergedSelections():Array<ASAny>
        {
            return [];
        }

        public function mergedSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.merged.title";
        }

        public function setMergedType(_arg_1:Int, _arg_2:Int)
        {
        }

        public function getMergedType(_arg_1:Int):Int
        {
            return WiredInputSourcePicker.FURNI_SOURCE;
        }

        public function isInputSourceDisabled(_arg_1:Int, _arg_2:Int):Bool
        {
            return false;
        }

        public function getCustomSourcesForMergedType(_arg_1:Int):Array<ASAny>
        {
            return [];
        }

        public function advancedAlwaysVisible():Bool
        {
            return false;
        }

        public function inputSourcesAlwaysVisible():Bool
        {
            return false;
        }

        public var usingCustomAdvancedSettings(get,never):Bool;
public function  get_usingCustomAdvancedSettings():Bool
        {
            return false;
        }

        public function mergedSourceOptions(_arg_1:Int):Array<ASAny>
        {
var source = 0;            var result:Array<ASAny> = [WiredInputSourcePicker.FURNI_SOURCE, WiredInputSourcePicker.USER_SOURCE];
            final _iter_ = this.getCustomSourcesForMergedType(_arg_1); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
source = ASCompat.toInt(_tmp_);
                result.push(source);
            }
            return result;
        }

        public function hasCustomTypePicker(_arg_1:Int):Bool
        {
            return false;
        }

        function createSourceTypeListener(_arg_1:Int):ISourceTypeListener
        {
            return new WrappedSourceTypeListener(this, _arg_1);
        }

        public function onGuildMemberships(_arg_1:Array<ASAny>)
        {
        }

        public function readIntParamsFromForm():Array<ASAny>
        {
            return [];
        }

        public function readVariableIdsFromForm():Array<ASAny>
        {
            return null;
        }

        public function readFurniSourceTypesFromForm():Array<ASAny>
        {
            return null;
        }

        public function readUserSourceTypesFromForm():Array<ASAny>
        {
            return null;
        }

        public function readFurniIds2FromForm():Array<ASAny>
        {
            return null;
        }

        public function readStringParamFromForm():String
        {
            return "";
        }

        public function setRoomEvents(_arg_1:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = _arg_1;
        }

        public function onInit(_arg_1:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = _arg_1;
            this._initialized = true;
        }

        public function onEditStart(_arg_1:Triggerable)
        {
        }

        public function onEditInitialized()
        {
        }

        public function onEditEnd()
        {
        }

        public function validate():String
        {
            return null;
        }

        public var requireConfirmation(get,never):ASObject;
public function  get_requireConfirmation():ASObject
        {
            return null;
        }

        public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
        }

        public var roomEvents(get,never):HabboUserDefinedRoomEvents;
public function  get_roomEvents():HabboUserDefinedRoomEvents
        {
            return this._roomEvents;
        }

        function loc(_arg_1:String):String
        {
            return this._roomEvents.localization.getLocalization(_arg_1, _arg_1);
        }

        function l(_arg_1:String):String
        {
            return "${wiredfurni.params." + _arg_1 + "}";
        }

        public var widthModifier(get,never):Float;
public function  get_widthModifier():Float
        {
            return 1;
        }

        public var allowScrolling(get,never):Bool;
public function  get_allowScrolling():Bool
        {
            return false;
        }
    }

