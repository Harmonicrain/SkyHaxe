package org.openvideoads.util
;
    import flash.external.ExternalInterface;
    import flash.net.URLRequest;

     class UserAgentUtils 
    {


        static function getUA():String
        {
            var k:String = null;
            if (ExternalInterface.available)
            {
                try
                {
                    k = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
                    if (((!(k == null)) && (k.indexOf("Firefox") >= 0)))
                    {
                        return "FIREFOX";
                    }
                    if (((!(k == null)) && (k.indexOf("Safari") >= 0)))
                    {
                        return "SAFARI";
                    }
                    if (((!(k == null)) && (k.indexOf("MSIE") >= 0)))
                    {
                        return "IE";
                    }
                    if (((!(k == null)) && (k.indexOf("Opera") >= 0)))
                    {
                        return "OPERA";
                    }
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
            return "UNDEFINED";
        }

        public static function openWindow(k:String, _arg_2:String="_blank", _arg_3:String="")
        {
            var _local_4= UserAgentUtils.getUA();
            switch (_local_4)
            {
                case "IE":
                    ExternalInterface.call((((((("function setWMWindow() {window.open('" + k) + "', '") + _arg_2) + "', '") + _arg_3) + "');}"));
                    return;
                default:
                    flash.Lib.getURL(new URLRequest(k), _arg_2);
            }
        }

	public function new() {}
    }

