package org.openvideoads.vast.server.request.doubleclick
;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.server.config.CustomProperties;

     class _Str_10632 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            this.oneAdPerRequest = true;
            super("DART", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__/pfadx/__site__;kw=__redirect__;sz=__size__;ord=__zone__;dcmt=__dcmt__";
        }

        override function  get_defaultCustomProperties():CustomProperties
        {
            return new CustomProperties({
                "size":"460x360",
                "dcmt":"text/html"
            });
        }
    }

