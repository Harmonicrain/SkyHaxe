package org.openvideoads.vast.server.request.direct
;
    import org.openvideoads.vast.server.config.AdServerConfig;

     class _Str_4664 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            this.oneAdPerRequest = true;
            super("Direct", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__";
        }
    }

