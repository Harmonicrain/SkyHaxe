package org.openvideoads.vast.schedule.ads.templates
;
    import org.openvideoads.vast.model.NonLinearTextAd;
    import org.openvideoads.vast.model.NonLinearVideoAd;

     class _Str_5080 extends _Str_3048 
    {
        public function new(k:String="flash", _arg_2:String=null)
        {
            super(k, ((_arg_2 != null) ? _arg_2 : ((k == "flash") ? (((("<body>" + "<p align='left' class='title'>_title_</p>") + "<p align='left' class='description'>_description_</p>") + "<p align='left' class='callToActionTitle'>_callToActionTitle_</p>") + "</body>") : (((("<div class='textAdContainer'>" + "<div class='textAdTitle'>_title_</div>") + "<div class='textAdDescription'>_description_</div>") + "<div class='textAdCallToActionTitle'>_callToActionTitle_</div>") + "</div>"))));
        }

        override public function getContent(k:NonLinearVideoAd):String
        {
            var _local_2:String = null;
            if (k != null)
            {
                _local_2 = replace(_Str_2620, "title", Std.downcast(k , NonLinearTextAd).title);
                _local_2 = replace(_local_2, "description", Std.downcast(k , NonLinearTextAd).description);
                _local_2 = replace(_local_2, "callToActionTitle", Std.downcast(k , NonLinearTextAd).callToActionTitle);
                return _local_2;
            }
            return "Non-linear video ad not available";
        }
    }

