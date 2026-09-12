package org.openvideoads.vast.config
;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.vast.schedule.ads.templates._Str_5080;
    import org.openvideoads.vast.schedule.ads.templates._Str_4426;
    import org.openvideoads.vast.schedule.ads.templates._Str_4962;
    import org.openvideoads.vast.schedule.ads.templates._Str_5816;
    import org.openvideoads.vast.schedule.ads.templates._Str_5713;
    import org.openvideoads.vast.schedule.ads.templates._Str_5981;
    import org.openvideoads.vast.schedule.ads.templates.*;

     class ConfigPreConverter 
    {


        public static function _Str_4080(k:ASObject):ASObject
        {
            var _local_2:ASObject = _Str_21599(_Str_22158(k));
            return _local_2;
        }

        public static function _Str_22158(k:ASObject):ASObject
        {
var _local_2:String  = null;            var _local_2:String = null;
            var _local_3 = 0;
            if (ASCompat.hasOwnProperty(k, "analytics"))
            {
                if (ASCompat.hasOwnProperty(k.analytics, "google"))
                {
                    if (ASCompat.hasOwnProperty(k.analytics.google, "enable"))
                    {
                        if (k.analytics.google.enable == false)
                        {
                            if (ASCompat.hasOwnProperty(k.analytics.google, "custom"))
                            {
                                k.analytics.google.custom.enable = false;
                            }
                        }
                        Reflect.deleteField(k.analytics.google, "enable");
                    }
                    if (ASCompat.hasOwnProperty(k.analytics.google, "ova"))
                    {
                        Reflect.deleteField(k.analytics.google, "ova");
                    }
                }
            }
            if (ASCompat.hasOwnProperty(k, "overlays"))
            {
                if (ASCompat.hasOwnProperty(k.overlays, "closeButton"))
                {
                    if (ASCompat.hasOwnProperty(k, "regions"))
                    {
                        k.regions.closeButton = k.overlays.closeButton;
                    }
                    else
                    {
                        k.regions = {"closeButton":k.overlays.closeButton};
                    }
                }
                if (ASCompat.hasOwnProperty(k.overlays, "regions"))
                {
                    k.regions = {"declarations":k.overlays.regions};
                }
                if (ASCompat.hasOwnProperty(k.overlays, "stagePaddingBottomNoControls"))
                {
                    if (ASCompat.hasOwnProperty(k, "player"))
                    {
                        if (ASCompat.hasOwnProperty(k.player, "margins"))
                        {
                            k.player.margins.withoutControls = k.overlays.stagePaddingBottomNoControls;
                            k.player.margins.withoutControlsOverride = k.overlays.stagePaddingBottomNoControls;
                        }
                        else
                        {
                            k.player.margins = {
                                "withoutControls":k.overlays.stagePaddingBottomNoControls,
                                "withoutControlsOverride":k.overlays.stagePaddingBottomNoControls
                            }
;                        }
                    }
                    else
                    {
                        k.player = {"margins":{
                                "withoutControls":k.overlays.stagePaddingBottomNoControls,
                                "withoutControlsOverride":k.overlays.stagePaddingBottomNoControls
                            }};
                    }
                }
                if (ASCompat.hasOwnProperty(k.overlays, "stagePaddingBottomWithControls"))
                {
                    if (ASCompat.hasOwnProperty(k, "player"))
                    {
                        if (ASCompat.hasOwnProperty(k.player, "margins"))
                        {
                            k.player.margins.withControls = k.overlays.stagePaddingBottomWithControls;
                            k.player.margins.withControlsOverride = k.overlays.stagePaddingBottomWithControls;
                        }
                        else
                        {
                            k.player.margins = {
                                "withControls":k.overlays.stagePaddingBottomWithControls,
                                "withControlsOverride":k.overlays.stagePaddingBottomWithControls
                            }
;                        }
                    }
                    else
                    {
                        k.player = {"margins":{
                                "withControls":k.overlays.stagePaddingBottomWithControls,
                                "withControlsOverride":k.overlays.stagePaddingBottomWithControls
                            }};
                    }
                }
            }
            if (ASCompat.hasOwnProperty(k, "ads"))
            {
                if (ASCompat.hasOwnProperty(k.ads, "replayNonLinearAds"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                    {
                        k.ads.overlays.replay = k.ads.replayNonLinearAds;
                    }
                    else
                    {
                        k.ads.overlays = {"replay":k.ads.replayNonLinearAds};
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "acceptedNonLinearAdMimeTypes"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                    {
                        k.ads.overlays.acceptedMimeTypes = k.ads.acceptedNonLinearAdMimeTypes;
                    }
                    else
                    {
                        k.ads.overlays = {"acceptedMimeTypes":k.ads.acceptedNonLinearAdMimeTypes};
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "enableOverlayScaling"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                    {
                        k.ads.overlays.enableScaling = k.ads.enableOverlayScaling;
                    }
                    else
                    {
                        k.ads.overlays = {"enableScaling":k.ads.enableOverlayScaling};
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "enforceOverlayRecommendedSizing"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                    {
                        k.ads.overlays.enforceRecommendedSizing = k.ads.enforceOverlayRecommendedSizing;
                    }
                    else
                    {
                        k.ads.overlays = {"enforceRecommendedSizing":k.ads.enforceOverlayRecommendedSizing};
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "keepOverlayVisibleAfterClick"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                    {
                        k.ads.overlays.keepVisibleAfterClick = k.ads.keepOverlayVisibleAfterClick;
                    }
                    else
                    {
                        k.ads.overlays = {"keepVisibleAfterClick":k.ads.keepOverlayVisibleAfterClick};
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "companions"))
                {
                    if (Std.is(k.ads.companions , Array))
                    {
                        k.ads.companions = {"regions":k.ads.companions};
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "processCompanionsExternally"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "companions"))
                    {
                        k.ads.companions.html5 = k.ads.processCompanionsExternally;
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "millisecondDelayOnCompanionInjection"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "companions"))
                    {
                        k.ads.companions.millisecondDelayOnInjection = k.ads.millisecondDelayOnCompanionInjection;
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "displayCompanions"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "companions"))
                    {
                        k.ads.companions.enable = k.ads.displayCompanions;
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "restoreCompanions"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "companions"))
                    {
                        k.ads.companions.restore = k.ads.restoreCompanions;
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "additionalParamsForSWFCompanions"))
                {
                    if (ASCompat.hasOwnProperty(k.ads, "companions"))
                    {
                        k.ads.companions.additionalParamsForSWFCompanions = k.ads.additionalParamsForSWFCompanions;
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "controls"))
                {
                    if (ASCompat.hasOwnProperty(k.ads.controls, "skipAd"))
                    {
                        k.ads.skipAd = k.ads.controls.skipAd;
                    }
                    else
                    {
                        if (ASCompat.hasOwnProperty(k, "player")== false)
                        {
                            k.player = {"modes":{"linear":{"controls":k.ads.controls}}};
                        }
                        else
                        {
                            if (ASCompat.hasOwnProperty(k.player, "modes")== false)
                            {
                                k.player.modes = {"linear":{"controls":k.ads.controls}};
                            }
                            else
                            {
                                if (ASCompat.hasOwnProperty(k.player.modes, "linear")== false)
                                {
                                    k.player.modes.linear = {"controls":k.ads.controls};
                                }
                                else
                                {
                                    if (ASCompat.hasOwnProperty(k.player.modes.linear, "controls")== false)
                                    {
                                        k.player.modes.linear.controls = k.ads.controls;
                                    }
                                    else
                                    {
                                        final _iter_:ASAny = k.ads.controls; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
                                        {
_local_2 = _tmp_;
                                            if (_local_2 == "skipAd")
                                            {
                                                k.ads.skipAd = _local_2;
                                            }
                                            else
                                            {
ASCompat.setDynamicProperty(                                                k.player.modes.linear.controls, _local_2, k.ads.controls[_local_2]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (ASCompat.hasOwnProperty(k.ads, "vpaid"))
                    {
                        if (ASCompat.hasOwnProperty(k.ads.vpaid, "controls"))
                        {
                            if (ASCompat.hasOwnProperty(k.ads.vpaid.controls, "hideOnLinearPlayback"))
                            {
                                if (ASCompat.hasOwnProperty(k, "player")== false)
                                {
                                    k.player = {"modes":{"linear":{"controls":{"vpaid":{"visible":(!k.ads.vpaid.controls.hideOnLinearPlayback)}}}}};
                                }
                                else
                                {
                                    if (ASCompat.hasOwnProperty(k.player, "modes")== false)
                                    {
                                        k.player.modes = {"linear":{"controls":{"vpaid":{"visible":(!k.ads.vpaid.controls.hideOnLinearPlayback)}}}};
                                    }
                                    else
                                    {
                                        if (ASCompat.hasOwnProperty(k.player.modes, "linear")== false)
                                        {
                                            k.player.modes.linear = {"controls":{"vpaid":{"visible":(!k.ads.vpaid.controls.hideOnLinearPlayback)}}};
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.player.modes.linear, "controls")== false)
                                            {
                                                k.player.modes.linear.controls = {"vpaid":{"visible":(!k.ads.vpaid.controls.hideOnLinearPlayback)}};
                                            }
                                            else
                                            {
                                                if (ASCompat.hasOwnProperty(k.player.modes.linear.controls, "vpaid")== false)
                                                {
                                                    k.player.modes.linear.controls.vpaid = {"visible":(!k.ads.vpaid.controls.hideOnLinearPlayback)};
                                                }
                                                else
                                                {
                                                    k.player.modes.linear.controls.vpaid.visible = (!k.ads.vpaid.controls.hideOnLinearPlayback);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "disableControls"))
                {
                    if (ASCompat.hasOwnProperty(k, "player")== false)
                    {
                        k.player = {"modes":{"linear":{"controls":{"enable":(!k.ads.disableControls)}}}};
                    }
                    else
                    {
                        if (ASCompat.hasOwnProperty(k.player, "modes")== false)
                        {
                            k.player.modes = {"linear":{"controls":{"enable":(!k.ads.disableControls)}}};
                        }
                        else
                        {
                            if (ASCompat.hasOwnProperty(k.player.modes, "linear")== false)
                            {
                                k.player.modes.linear = {"controls":{"enable":(!k.ads.disableControls)}};
                            }
                            else
                            {
                                if (ASCompat.hasOwnProperty(k.player.modes.linear, "controls")== false)
                                {
                                    k.player.modes.linear.controls = {"enable":(!k.ads.disableControls)};
                                }
                                else
                                {
                                    if (ASCompat.hasOwnProperty(k.player.modes.linear, "enable")== false)
                                    {
                                        k.player.modes.linear.controls.enable = (!k.ads.disableControls);
                                    }
                                }
                            }
                        }
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "schedule"))
                {
                    if (Std.is(k.ads.schedule , Array))
                    {
                        _local_3 = 0;
                        while (_local_3 < k.ads.schedule.length)
                        {
                            if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "position"))
                            {
                                if (Std.is(k.ads.schedule[_local_3].position , String))
                                {
                                    if (StringUtils._Str_22149("PRE-ROLL MID-ROLL POST-ROLL", k.ads.schedule[_local_3].position) == false)
                                    {
                                        k.ads.schedule[_local_3].region = k.ads.schedule[_local_3].position;
                                        Reflect.deleteField(k.ads.schedule[_local_3], "position");
                                    }
                                }
                            }
                            _local_3++;
                        }
                    }
                }
            }
            return k;
        }

        static function _Str_9558(k:ASObject):ASObject
        {
var _local_3:String  = null;            var _local_2:ASObject = null;
            var _local_3:String = null;
            if (Std.is(k , String))
            {
                return ({
                    "image":k,
                    "text":k,
                    "html":k,
                    "swf":k,
                    "vpaid":k,
                    "iframe":k,
                    "script":k
                });
            }
            _local_2 = {
                "image":"auto:bottom",
                "text":"auto:bottom",
                "html":"auto:bottom",
                "swf":"auto:bottom",
                "vpaid":"auto:bottom",
                "iframe":"auto:bottom",
                "script":"auto:bottom"
            }
;            if (k != null)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k.___keys())
                {
_local_3 = _tmp_;
ASCompat.setDynamicProperty(                    _local_2, _local_3, ASCompat.getDynamicProperty(k, _local_3));
                }
            }
            return _local_2;
        }

        static function _Str_6379(k:String, _arg_2:ASObject=null):ASObject
        {
var _local_4:String  = null;            var _local_4:String = null;
            var _local_3:ASObject = {
                "text":new _Str_5080(k),
                "html":new _Str_4426(k),
                "image":new _Str_4962(k),
                "swf":new _Str_5816(k),
                "script":new _Str_5713(k),
                "iframe":new _Str_5981(k),
                "vpaid":null
            }
;            if (_arg_2 != null)
            {
                if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2.___keys())
                {
_local_4 = _tmp_;
                    if (StringUtils._Str_2576(_local_4, "text"))
                    {
ASCompat.setDynamicProperty(                        _local_3, _local_4, new _Str_5080(k, ASCompat.getDynamicProperty(_arg_2, _local_4)));
                    }
                    else
                    {
                        if (StringUtils._Str_2576(_local_4, "html"))
                        {
ASCompat.setDynamicProperty(                            _local_3, _local_4, new _Str_4426(k, ASCompat.getDynamicProperty(_arg_2, _local_4)));
                        }
                        else
                        {
                            if (StringUtils._Str_2576(_local_4, "image"))
                            {
ASCompat.setDynamicProperty(                                _local_3, _local_4, new _Str_4962(k, ASCompat.getDynamicProperty(_arg_2, _local_4)));
                            }
                            else
                            {
                                if (StringUtils._Str_2576(_local_4, "swf"))
                                {
ASCompat.setDynamicProperty(                                    _local_3, _local_4, new _Str_5816(k, ASCompat.getDynamicProperty(_arg_2, _local_4)));
                                }
                                else
                                {
                                    if (StringUtils._Str_2576(_local_4, "script"))
                                    {
ASCompat.setDynamicProperty(                                        _local_3, _local_4, new _Str_5713(k, ASCompat.getDynamicProperty(_arg_2, _local_4)));
                                    }
                                    else
                                    {
                                        if (StringUtils._Str_2576(_local_4, "iframe"))
                                        {
ASCompat.setDynamicProperty(                                            _local_3, _local_4, new _Str_5981(k, ASCompat.getDynamicProperty(_arg_2, _local_4)));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return _local_3;
        }

        public static function _Str_21599(k:ASObject):ASObject
        {
            var _local_2:ASObject = null;
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6 = 0;
            if (ASCompat.hasOwnProperty(k, "ads"))
            {
                _local_2 = (ASCompat.hasOwnProperty(k.ads, "overlays") ? k.ads.overlays : new ASObject());
                if (ASCompat.hasOwnProperty(_local_2, "regions")== false)
                {
                    if (ASCompat.hasOwnProperty(_local_2, "region"))
                    {
                        _local_2.regions = {
                            "preferred":"flash",
                            "flash":([{
                                "enable":true,
                                "region":_local_2.region
                            }] : Array<Dynamic>),
                            "html5":([{
                                "enable":false,
                                "region":_local_2.region
                            }] : Array<Dynamic>)
                        }
;                        Reflect.deleteField(_local_2, "region");
                    }
                    else
                    {
                        _local_2.regions = {
                            "preferred":"flash",
                            "flash":([{"enable":true}] : Array<Dynamic>),
                            "html5":([{"enable":false}] : Array<Dynamic>)
                        }
;                    }
                }
                else
                {
                    if (ASCompat.hasOwnProperty(_local_2.regions, "preferred")== false)
                    {
                        _local_2.regions.preferred = "flash";
                    }
                    if (ASCompat.hasOwnProperty(_local_2.regions, "flash")== false)
                    {
                        _local_2.regions.flash = ([{"enable":true}] : Array<Dynamic>);
                    }
                    else
                    {
                        if ((Std.is(_local_2.regions.flash , String) || Std.is(_local_2.regions.flash , Bool)))
                        {
                            _local_2.regions.flash = ([{"enable":StringUtils._Str_2810(_local_2.regions.flash)}] : Array<Dynamic>);
                        }
                        else
                        {
                            if (Std.is(_local_2.regions.flash , Array))
                            {
                            }
                        }
                    }
                    if (ASCompat.hasOwnProperty(_local_2.regions, "html5")== false)
                    {
                        _local_2.regions.html5 = ([{"enable":false}] : Array<Dynamic>);
                    }
                    else
                    {
                        if (Std.is(_local_2.regions.html5 , Array) == false)
                        {
                            _local_2.regions.html5 = ([{"enable":StringUtils._Str_2810(_local_2.regions.html5)}] : Array<Dynamic>);
                        }
                    }
                }
                if (ASCompat.hasOwnProperty(k.ads, "schedule"))
                {
                    if (Std.is(k.ads.schedule , Array))
                    {
                        _local_3 = 0;
                        while (_local_3 < k.ads.schedule.length)
                        {
                            if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "startTime"))
                            {
                                if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "regions")== false)
                                {
                                    if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "region"))
                                    {
                                        k.ads.schedule[_local_3].regions = {
                                            "preferred":_local_2.regions.preferred,
                                            "flash":([{
                                                "enable":_local_2.regions.flash[0].enable,
                                                "region":k.ads.schedule[_local_3].region,
                                                "overlay":true
                                            }] : Array<Dynamic>),
                                            "html5":([{
                                                "enable":_local_2.regions.html5[0].enable,
                                                "region":k.ads.schedule[_local_3].region,
                                                "overlay":true
                                            }] : Array<Dynamic>)
                                        }
;                                    }
                                    else
                                    {
                                        k.ads.schedule[_local_3].regions = _local_2.regions;
                                    }
                                }
                                if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3].regions, "preferred")== false)
                                {
                                    k.ads.schedule[_local_3].regions.preferred = "flash";
                                }
                                if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3].regions, "flash")== false)
                                {
                                    if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "region"))
                                    {
                                        k.ads.schedule[_local_3].regions.flash = ([{
                                            "enable":_local_2.regions.flash[0].enable,
                                            "region":k.ads.schedule[_local_3].region,
                                            "overlay":true
                                        }] : Array<Dynamic>);
                                    }
                                    else
                                    {
                                        k.ads.schedule[_local_3].regions.flash = ([{
                                            "enable":_local_2.regions.flash[0].enable,
                                            "overlay":true
                                        }] : Array<Dynamic>);
                                    }
                                }
                                else
                                {
                                    if (Std.is(k.ads.schedule[_local_3].regions.flash , Array) == false)
                                    {
                                        k.ads.schedule[_local_3].regions.flash = ([{
                                            "enable":StringUtils._Str_2810(k.ads.schedule[_local_3].regions.flash),
                                            "overlay":true
                                        }] : Array<Dynamic>);
                                    }
                                }
                                if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3].regions, "html5")== false)
                                {
                                    if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "region"))
                                    {
                                        k.ads.schedule[_local_3].regions.html5 = ([{
                                            "enable":_local_2.regions.html5[0].enable,
                                            "region":k.ads.schedule[_local_3].region,
                                            "overlay":true
                                        }] : Array<Dynamic>);
                                    }
                                    else
                                    {
                                        k.ads.schedule[_local_3].regions.html5 = ([{
                                            "enable":_local_2.regions.html5[0].enable,
                                            "overlay":true
                                        }] : Array<Dynamic>);
                                    }
                                }
                                else
                                {
                                    if (Std.is(k.ads.schedule[_local_3].regions.html5 , Array) == false)
                                    {
                                        k.ads.schedule[_local_3].regions.html5 = ([{
                                            "enable":StringUtils._Str_2810(k.ads.schedule[_local_3].regions.html5),
                                            "overlay":true
                                        }] : Array<Dynamic>);
                                    }
                                }
                                _local_4 = "flash";
                                _local_5 = 0;
                                while (_local_5 < 2)
                                {
                                    _local_6 = 0;
                                    while (_local_6 < k.ads.schedule[_local_3].regions[_local_4].length)
                                    {
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3].regions[_local_4][_local_6], "region"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].region = _Str_9558(k.ads.schedule[_local_3].regions[_local_4][_local_6].region);
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3].regions, "region"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "region"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].region = _Str_9558(k.ads.schedule[_local_3].region);
                                                }
                                            }
                                            else
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                                {
                                                    if (ASCompat.hasOwnProperty(k.ads.overlays, "region"))
                                                    {
                                                        k.ads.schedule[_local_3].regions[_local_4][_local_6].region = _Str_9558(k.ads.overlays.region);
                                                    }
                                                }
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "templates"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].templates = _Str_6379(_local_4, k.ads.schedule[_local_3].templates);
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "templates"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].templates = _Str_6379(_local_4, k.ads.overlays.templates);
                                                }
                                                else
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].templates = _Str_6379(_local_4);
                                                }
                                            }
                                            else
                                            {
                                                k.ads.schedule[_local_3].regions[_local_4][_local_6].templates = _Str_6379(_local_4);
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "width"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].width = k.ads.schedule[_local_3].width;
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "width"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].width = k.ads.overlays.width;
                                                }
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "height"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].height = k.ads.schedule[_local_3].height;
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "height"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].height = k.ads.overlays.height;
                                                }
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "acceptedAdTypes"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].acceptedAdTypes = k.ads.schedule[_local_3].acceptedAdTypes;
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "acceptedAdTypes"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].acceptedAdTypes = k.ads.overlays.acceptedAdTypes;
                                                }
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "alwaysMatch"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].alwaysMatch = k.ads.schedule[_local_3].alwaysMatch;
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "alwaysMatch"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].alwaysMatch = k.ads.overlays.alwaysMatch;
                                                }
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "enableScaling"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].enableScaling = k.ads.schedule[_local_3].enableScaling;
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "enableScaling"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].enableScaling = k.ads.overlays.enableScaling;
                                                }
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "enforceRecommendedSizing"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].enforceRecommendedSizing = k.ads.schedule[_local_3].enforceRecommendedSizing;
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "enforceRecommendedSizing"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].enforceRecommendedSizing = k.ads.overlays.enforceRecommendedSizing;
                                                }
                                            }
                                        }
                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "keepVisibleAfterClick"))
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].keepVisibleAfterClick = k.ads.schedule[_local_3].keepVisibleAfterClick;
                                        }
                                        else
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads.overlays, "keepVisibleAfterClick"))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].keepVisibleAfterClick = k.ads.overlays.keepVisibleAfterClick;
                                                }
                                            }
                                        }
                                        if (_local_4 == "html5")
                                        {
                                            if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3], "overlay"))
                                            {
                                                if (Std.is(k.ads.schedule[_local_3].overlay , Bool))
                                                {
                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].overlay = k.ads.schedule[_local_3].overlay;
                                                }
                                                else
                                                {
                                                    if ((k.ads.schedule[_local_3].overlay != null))
                                                    {
                                                        if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3].overlay, "html5"))
                                                        {
                                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].overlay = k.ads.schedule[_local_3].overlay.html5;
                                                        }
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                if (ASCompat.hasOwnProperty(k.ads, "overlays"))
                                                {
                                                    if (ASCompat.hasOwnProperty(k.ads.overlays, "overlay"))
                                                    {
                                                        if (Std.is(k.ads.overlays.overlay , Bool))
                                                        {
                                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].overlay = ASCompat.xmlDescendants(k.ads.overlays, "overlay");
                                                        }
                                                        else
                                                        {
                                                            if ((k.ads.overlays.overlay != null))
                                                            {
                                                                if (ASCompat.hasOwnProperty(k.ads.overlays.overlay, "html5"))
                                                                {
                                                                    k.ads.schedule[_local_3].regions[_local_4][_local_6].overlay = k.ads.overlays.overlay.html5;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    if (ASCompat.hasOwnProperty(k.ads.schedule[_local_3].regions[_local_4][_local_6], "overlay")== false)
                                                    {
                                                        k.ads.schedule[_local_3].regions[_local_4][_local_6].overlay = true;
                                                    }
                                                }
                                            }
                                        }
                                        else
                                        {
                                            k.ads.schedule[_local_3].regions[_local_4][_local_6].overlay = true;
                                        }
                                        _local_6++;
                                    }
                                    _local_4 = "html5";
                                    _local_5++;
                                }
                            }
                            _local_3++;
                        }
                    }
                }
            }
            return k;
        }

	public function new() {}
    }

