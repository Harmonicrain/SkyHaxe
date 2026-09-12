package org.openvideoads.vast.server.request.openx
;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.server.config.CustomProperties;

     class _Str_11383 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            super("OpenX3", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__?__zones__&test=true";
        }

        override function  get_defaultCustomProperties():CustomProperties
        {
            return new CustomProperties();
        }
    }

