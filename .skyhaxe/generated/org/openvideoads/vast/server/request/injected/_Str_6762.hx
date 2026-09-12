package org.openvideoads.vast.server.request.injected
;
    import org.openvideoads.vast.server.config.AdServerConfig;

     class _Str_6762 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            this.oneAdPerRequest = true;
            super("Injected", k);
        }
    }

