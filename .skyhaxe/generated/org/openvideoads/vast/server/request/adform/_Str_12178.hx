package org.openvideoads.vast.server.request.adform
;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.server.config.CustomProperties;

     class _Str_12178 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            this.oneAdPerRequest = true;
            super("Adform", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__/?bn=__zone__&ord=__timestamp__";
        }

        override function  get_defaultCustomProperties():CustomProperties
        {
            return new CustomProperties({"api-address":"http://track.adform.net/serving/videoad"});
        }
    }

