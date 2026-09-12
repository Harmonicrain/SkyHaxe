package com.sulake.habbo.localization
;
    import com.sulake.core.localization.CoreLocalizationManager;
    import com.sulake.habbo.localization._enum.HabboLocalizationFlags;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.events.Event;
    import com.sulake.habbo.communication._enum.HabboCommunicationEvent;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.localization._enum.LocalizationEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;

     class HabboLocalizationManager extends CoreLocalizationManager implements IHabboLocalizationManager 
    {
        var _skipExternals:Bool = false;
        var _badgePointLimits:ASDictionary<ASAny,ASAny>;
        var _romanNumerals:Array<ASAny>;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._badgePointLimits = new ASDictionary<ASAny,ASAny>();
            this._romanNumerals = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI", "XXII", "XXIII", "XXIV", "XXV", "XXVI", "XXVII", "XXVIII", "XXIX", "XXX"];
            this._skipExternals = ((ASCompat.toInt(_arg_2 )& ASCompat.toInt(HabboLocalizationFlags._Str_16746)) > 0);
            super(k, _arg_2, _arg_3);
        }

        override public function dispose()
        {
            super.dispose();
        }

        override function initComponent()
        {
            super.initComponent();
            this.configureLocalizationLocations();
            if (this._skipExternals)
            {
                events.dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
                context.events.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED, this._Str_18093);
            }
        }

        function _Str_18093(k:Event)
        {
            this.requestLocalizationInit();
        }

        public function getLocalizationWithParams(k:String, _arg_2:String="",  _args:Array<ASAny> = null):String
        {
if (_args == null) _args = [];
            var _local_4 = 0;
            var _local_5 = 0;
            if (((!(_args == null)) && (_args.length > 0)))
            {
                _local_4 = Std.int(_args.length / 2);
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    registerParameter(k, _args[(_local_5 * 2)], _args[((_local_5 * 2) + 1)]);
                    _local_5++;
                }
            }
            return this.getLocalization(k, _arg_2);
        }

        public function getLocalizationWithParamMap(k:String, _arg_2:String="", _arg_3:Map=null):String
        {
var _local_4:String  = null;            var _local_4:String = null;
            if (_arg_3 != null)
            {
                if (checkNullIteratee(_arg_3)) for (_tmp_ in _arg_3.getKeys())
                {
_local_4 = _tmp_;
                    registerParameter(k, _local_4, _arg_3.getValue(_local_4));
                }
            }
            return this.getLocalization(k, _arg_2);
        }

        override public function getLocalization(k:String, _arg_2:String=""):String
        {
            var _local_3= super.getLocalization(k, _arg_2);
            return interpolate(_local_3);
        }

        public function getAchievementName(k:String):String
        {
            var _local_2= new BadgeBaseAndLevel(k);
            var _local_3= this.getExistingKey([("badge_name_al_" + k), ("badge_name_al_" + _local_2.base), ("badge_name_" + k), ("badge_name_" + _local_2.base)]);
            this.registerParameter(_local_3, "roman", this.getRomanNumeral(_local_2.level));
            var _local_4= this.getLocalization(_local_3);
            return (_local_4 != null) ? _local_4 : "";
        }

        public function getAchievementDesc(k:String, _arg_2:Int):String
        {
            var _local_3= new BadgeBaseAndLevel(k);
            var _local_4= this.getExistingKey([("badge_desc_al_" + k), ("badge_desc_al_" + _local_3.base), ("badge_desc_" + k), ("badge_desc_" + _local_3.base)]);
            this.registerParameter(_local_4, "limit", ("" + Std.string(_arg_2)));
            this.registerParameter(_local_4, "roman", this.getRomanNumeral(_local_3.level));
            return this.getLocalization(_local_4);
        }

        public function getAchievementInstruction(k:String):String
        {
            var _local_2= new BadgeBaseAndLevel(k);
            var _local_3= this.getExistingKey([("badge_instruction_" + _local_2.base)]);
            this.registerParameter(_local_3, "limit", ("" + Std.string(this.getBadgePointLimit(k))));
            var _local_4= this.getLocalization(_local_3);
            return (_local_4 != null) ? _local_4 : "";
        }

        public function getBadgeBaseName(k:String):String
        {
            var _local_2= new BadgeBaseAndLevel(k);
            return _local_2.base;
        }

        public function getBadgeName(k:String):String
        {
            var _local_2= new BadgeBaseAndLevel(k);
            var _local_3= this._Str_21023(this.getExistingKey([("badge_name_" + k), ("badge_name_" + _local_2.base)]));
            this.registerParameter(_local_3, "roman", this.getRomanNumeral(_local_2.level));
            return this.getLocalization(_local_3);
        }

        public function getBadgeDesc(k:String):String
        {
            var _local_2= new BadgeBaseAndLevel(k);
            var _local_3= this._Str_21023(this.getExistingKey([("badge_desc_" + k), ("badge_desc_" + _local_2.base)]));
            this.registerParameter(_local_3, "limit", ("" + Std.string(this.getBadgePointLimit(k))));
            this.registerParameter(_local_3, "roman", this.getRomanNumeral(_local_2.level));
            return this.getLocalization(_local_3);
        }

        function _Str_21023(k:String):String
        {
            var _local_2= ASCompat.stringReplace(k, "${", "$");
            _local_2 = ASCompat.stringReplace(_local_2, "{", "$");
            _local_2 = ASCompat.stringReplace(_local_2, "}", "$");
            return _local_2;
        }

        public function getPreviousLevelBadgeId(k:String):String
        {
            var _local_2= new BadgeBaseAndLevel(k);
            _local_2.level--;
            return _local_2.badgeId;
        }

        public function setBadgePointLimit(k:String, _arg_2:Int)
        {
            this._badgePointLimits[k] = _arg_2;
        }

        function _Str_25984(k:IAlertDialog, _arg_2:ASAny)
        {
            k.dispose();
            printNonExistingKeys();
        }

        function configureLocalizationLocations()
        {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var k= 1;
            while (propertyExists(("localization." + Std.string(k))))
            {
                _local_2 = getProperty((("localization." + Std.string(k)) + ".id"));
                _local_3 = getProperty((("localization." + Std.string(k)) + ".code"));
                _local_4 = getProperty((("localization." + Std.string(k)) + ".name"));
                _local_5 = getProperty((("localization." + Std.string(k)) + ".url"));
                super.registerLocalizationDefinition(_local_2, _local_4, _local_5, _local_3);
                k++;
            }
        }

        function requestLocalizationInit()
        {
            var k= getProperty("external.texts.txt");
            events.addEventListener(LocalizationEvent.LOCALIZATION_EVENT_LOCALIZATION_LOADED, this.onLocalizationLoaded);
            super.loadLocalizationFromURL(k);
        }

        function getBadgePointLimit(k:String):Int
        {
            return ASCompat.toInt(this._badgePointLimits[k]);
        }

        function getExistingKey(k:Array<ASAny>):String
        {
            var _local_2:String = null;
            var _local_3:String = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_3 = this.getLocalization(_local_2);
                if (_local_3 != "")
                {
                    return _local_2;
                }
            }
            return "";//k[0];
        }

        function getRomanNumeral(k:Int):String
        {
            return this._romanNumerals[Std.int(Math.max(0, (k - 1)))];
        }

        function parseDevelopmentLocalizations()
        {
        }

        override function onLocalizationFailed(k:AssetLoaderEvent)
        {
            HabboWebTools.logEventLog(("external_texts download error " + Std.string(k.status)));
            super.onLocalizationFailed(k);
        }

        public function onLocalizationLoaded(k:Event)
        {
            var _local_2:String = null;
            events.removeEventListener(LocalizationEvent.LOCALIZATION_EVENT_LOCALIZATION_LOADED, this.onLocalizationLoaded);
            if (propertyExists("external.override.texts.txt"))
            {
                _local_2 = getProperty("external.override.texts.txt");
                events.addEventListener(LocalizationEvent.LOCALIZATION_EVENT_LOCALIZATION_LOADED, this.onLocalizationOverrideLoaded);
                super.loadLocalizationFromURL(_local_2);
            }
            else
            {
                events.dispatchEvent(new Event(Event.COMPLETE));
            }
        }

        public function onLocalizationOverrideLoaded(k:Event)
        {
            events.removeEventListener(LocalizationEvent.LOCALIZATION_EVENT_LOCALIZATION_LOADED, this.onLocalizationOverrideLoaded);
            events.dispatchEvent(new Event(Event.COMPLETE));
        }
    }

