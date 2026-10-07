package org.openvideoads.vast.server.request.openx
;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.vast.server.config.CustomProperties;

     class _Str_10391 extends AdServerConfig 
    {
        public function new(k:ASObject=null)
        {
            super("OpenX", k);
        }

        override function  get_defaultTemplate():String
        {
            return "__api-address__?script=__script__&zones=__zones__&nz=__nz__&source=__source__&r=__r__&block=__block__&format=__format__&charset=__charset__&__target__";
        }

        override function  get_defaultCustomProperties():CustomProperties
        {
            return new CustomProperties({
                "script":"bannerTypeHtml:vastInlineBannerTypeHtml:vastInlineHtml",
                "nz":"1",
                "source":"",
                "r":"__random-number__",
                "block":"__allow-duplicates-as-binary__",
                "format":"vast",
                "charset":"UTF-8"
            });
        }
    }

