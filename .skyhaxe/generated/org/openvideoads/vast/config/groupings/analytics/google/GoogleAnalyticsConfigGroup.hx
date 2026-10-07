package org.openvideoads.vast.config.groupings.analytics.google
;
    import org.openvideoads.vast.config.groupings._Str_3389;
    import flash.display.DisplayObject;
    import org.openvideoads.vast.config._Str_2741;
    import org.openvideoads.util.StringUtils;

     class GoogleAnalyticsConfigGroup extends _Str_3389 
    {
        public static inline final OVA= "OVA";
        public static inline final CUSTOM= "CUSTOM";

        var _Str_2699:Bool = true;
        var _Str_10351:GoogleAnalyticsTrackingGroup;
        var _Str_4747:GoogleAnalyticsTrackingGroup = null;
        var _Str_3875:DisplayObject = null;

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            this._Str_10351 = new GoogleAnalyticsTrackingGroup("OVA", {
                "enable":true,
                "impressions":{"enable":true}
            });
            super(k, _arg_2);
        }

        function _Str_20423()
        {
            if (this._Str_3875 != null)
            {
                this.ova.displayObject = this._Str_3875;
                if (this._Str_4747 != null)
                {
                    this._Str_4747.displayObject = this._Str_3875;
                }
            }
        }

        override public function initialise(k:ASObject=null, _arg_2:_Str_2741=null, _arg_3:Bool=false)
        {
            _Str_3654();
            super.initialise(k, _arg_2);
            if (k != null)
            {
                if (k.enable != /*undefined*/null)
                {
                    if (Std.is(k.enable , String))
                    {
                        this._Str_2699 = (k.enable.toUpperCase() == "TRUE");
                    }
                    else
                    {
                        this._Str_2699 = k.enable;
                    }
                }
                if (k.ova != /*undefined*/null)
                {
                    this.ova = new GoogleAnalyticsTrackingGroup("OVA", k.ova, _arg_3);
                    if (k.ova.displayObject != null)
                    {
                        this._Str_3875 = k.ova.displayObject;
                    }
                }
                if (k.custom != /*undefined*/null)
                {
                    if (k.custom.displayObject != null)
                    {
                        this._Str_3875 = k.custom.displayObject;
                    }
                    this.custom = new GoogleAnalyticsTrackingGroup("CUSTOM");
                    this.custom.initialise(k.custom, _arg_3);
                }
                this._Str_20423();
            }
            _Str_3144();
        }

        public function update(k:ASObject)
        {
            if (StringUtils._Str_2576(k.element, OVA))
            {
                this.ova.update(k);
            }
            if (StringUtils._Str_2576(k.element, CUSTOM))
            {
                this.custom.update(k);
            }
            if (k.displayObject != null)
            {
                this._Str_3875 = k.displayObject;
            }
            this._Str_20423();
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            if (this._Str_2699 == false)
            {
                return false;
            }
            return this.ova.trackingEnabled || this.custom.trackingEnabled;
        }

        
        public var ova(get,set):GoogleAnalyticsTrackingGroup;
public function  set_ova(k:GoogleAnalyticsTrackingGroup):GoogleAnalyticsTrackingGroup        {
            return this._Str_10351 = k;
        }
public function  get_ova():GoogleAnalyticsTrackingGroup
        {
            if (this._Str_10351 == null)
            {
                this._Str_10351 = new GoogleAnalyticsTrackingGroup(OVA);
            }
            return this._Str_10351;
        }

        
        public var custom(get,set):GoogleAnalyticsTrackingGroup;
public function  set_custom(k:GoogleAnalyticsTrackingGroup):GoogleAnalyticsTrackingGroup        {
            return this._Str_4747 = k;
        }
public function  get_custom():GoogleAnalyticsTrackingGroup
        {
            if (this._Str_4747 == null)
            {
                this._Str_4747 = new GoogleAnalyticsTrackingGroup(CUSTOM, {"enable":false});
            }
            return this._Str_4747;
        }
    }

