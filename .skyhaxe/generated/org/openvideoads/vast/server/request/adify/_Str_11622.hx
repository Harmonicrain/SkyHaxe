package org.openvideoads.vast.server.request.adify
;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.server.config.CustomProperties;

     class _Str_11622 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            this.oneAdPerRequest = true;
            super("Adify", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__/ad?enc=__enc__&asId=__zone__&sf=__sf__&ct=__ct__";
        }

        override function  get_defaultCustomProperties():CustomProperties
        {
            return new CustomProperties({
                "enc":"4",
                "sf":"0",
                "ct":"256"
            });
        }
    }

