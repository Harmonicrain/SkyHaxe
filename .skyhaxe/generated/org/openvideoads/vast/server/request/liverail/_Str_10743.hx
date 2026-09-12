package org.openvideoads.vast.server.request.liverail
;
    import org.openvideoads.vast.server.config.AdServerConfig;

     class _Str_10743 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            this.oneAdPerRequest = true;
            super("Liverail", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__";
        }
    }

