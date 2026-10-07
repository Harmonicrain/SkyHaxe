package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.regions.config.RegionViewConfig;
    import org.openvideoads.regions.config.CloseButtonConfig;

     class ClickSignConfig extends RegionViewConfig 
    {
        var _Str_2699:Bool = true;
        var _Str_2529:String = "_blank";

        public function new(k:ASObject=null)
        {
            super(null);
            _id = "reserved-click-me-prompt";
            _Str_7287 = "CENTER";
            _Str_12474 = "CENTER";
            _width = 250;
            _height = 32;
            _Str_11028 = 0.5;
            _Str_10333 = 20;
            _backgroundColor = "#000000";
            _style = ".smalltext { font-size:12; }";
            _Str_4544 = '<p class="smalltext" align="center">CLICK FOR MORE INFORMATION</p>';
            _Str_12703 = 0.75;
            _closeButton = new CloseButtonConfig({"enabled":false});
            setup(k);
            if (k != null)
            {
                if (k.closeButton != /*undefined*/null)
                {
                    if (Std.is(k.closeButton , org.openvideoads.regions.config.CloseButtonConfig))
                    {
                        _closeButton = k.closeButton;
                    }
                    else
                    {
                        _closeButton = new CloseButtonConfig(k.closeButton);
                    }
                }
                if (k.enabled != /*undefined*/null)
                {
                    if (Std.is(k.enabled , String))
                    {
                        this.enabled = ((k.enabled.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.enabled = k.enabled;
                    }
                }
                if (k.target != /*undefined*/null)
                {
                    this._Str_2529 = k.target;
                }
            }
        }

        
        public var enabled(get,set):Bool;
public function  set_enabled(k:Bool):Bool        {
            return this._Str_2699 = k;
        }
public function  get_enabled():Bool
        {
            return this._Str_2699;
        }

        
        public var target(get,set):String;
public function  set_target(k:String):String        {
            return this._Str_2529 = k;
        }
public function  get_target():String
        {
            return this._Str_2529;
        }
    }

