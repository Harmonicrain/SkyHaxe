package org.openvideoads.vast.server.request.oas
;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.server.config.CustomProperties;

     class _Str_10867 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            this.oneAdPerRequest = true;
            super("OAS", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__/__sitepage__/__random-number__@__listpos__?__target__";
        }

        override function  get_defaultCustomProperties():CustomProperties
        {
            return new CustomProperties({"target":""});
        }
    }

