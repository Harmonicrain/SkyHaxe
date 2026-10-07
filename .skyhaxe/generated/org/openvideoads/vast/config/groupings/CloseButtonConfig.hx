package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.StringUtils;

     class CloseButtonConfig extends Debuggable 
    {
        var _Str_4373:Bool = true;
        var _Str_2442:String = "overlay-close-button";
        var _Str_19122:Bool = true;

        public function new(k:ASAny=null)
        {
            super();
            this.initialise(k);
        }

        public function initialise(k:ASAny)
        {
            if (k != null)
            {
                if (Std.is(k , String))
                {
                    this._Str_4373 = StringUtils._Str_2810(k);
                }
                else
                {
                    if (Std.is(k , Bool))
                    {
                        this._Str_4373 = k;
                    }
                    else
                    {
                        if (ASCompat.hasOwnProperty(k, "enable"))
                        {
                            this._Str_4373 = StringUtils._Str_2810(k.enable);
                        }
                        if (ASCompat.hasOwnProperty(k, "region"))
                        {
                            this._Str_2442 = k.region;
                        }
                        if (ASCompat.hasOwnProperty(k, "program"))
                        {
                            this._Str_19122 = StringUtils._Str_2810(k.program);
                        }
                    }
                }
            }
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return this._Str_4373;
        }

        public var region(get,never):String;
public function  get_region():String
        {
            return this._Str_2442;
        }

        public var program(get,never):Bool;
public function  get_program():Bool
        {
            return this._Str_19122;
        }
    }

