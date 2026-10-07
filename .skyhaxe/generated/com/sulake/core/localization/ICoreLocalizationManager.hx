package com.sulake.core.localization
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.utils.Map;

     interface ICoreLocalizationManager extends IUnknown 
    {
        function registerListener(_arg_1:String, _arg_2:ILocalizable):Bool;
        function removeListener(_arg_1:String, _arg_2:ILocalizable):Bool;
        function loadLocalizationFromURL(_arg_1:String):Void;
        function hasLocalization(_arg_1:String):Bool;
        function getLocalization(_arg_1:String, _arg_2:String=""):String;
        function updateLocalization(_arg_1:String, _arg_2:String):Void;
        function registerParameter(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String="%"):String;
        function getLocalizationRaw(_arg_1:String):ILocalization;
        function getKeys():Array<ASAny>;
        function registerLocalizationDefinition(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String):Void;
        function activateLocalizationDefinition(_arg_1:String):Bool;
        function getLocalizationDefinitions():Map;
        function getLocalizationDefinition(_arg_1:String):ILocalizationDefinition;
        function getActiveLocalizationDefinition():ILocalizationDefinition;
        function printNonExistingKeys():Void;
    }

