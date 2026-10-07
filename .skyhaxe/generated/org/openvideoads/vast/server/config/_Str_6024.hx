package org.openvideoads.vast.server.config
;
    import org.openvideoads.vast.server.request.adify._Str_11622;
    import org.openvideoads.vast.server.request.adform._Str_12178;
    import org.openvideoads.vast.server.request.adtech._Str_9861;
    import org.openvideoads.vast.server.request.doubleclick._Str_10632;
    import org.openvideoads.vast.server.request.direct._Str_4664;
    import org.openvideoads.vast.server.request.injected._Str_6762;
    import org.openvideoads.vast.server.request.lightningcast._Str_10009;
    import org.openvideoads.vast.server.request.liverail._Str_10743;
    import org.openvideoads.vast.server.request.oas._Str_10867;
    import org.openvideoads.vast.server.request.oasis._Str_10310;
    import org.openvideoads.vast.server.request.openx._Str_10391;
    import org.openvideoads.vast.server.request.openx._Str_11383;

     class _Str_6024 
    {
        public static inline final ADFORM= "ADFORM";
        public static inline final ADIFY= "ADIFY";
        public static inline final ADTECH= "ADTECH";
        public static inline final DART= "DART";
        public static inline final DIRECT= "DIRECT";
        public static inline final INJECT= "INJECT";
        public static inline final LIGHTNINGCAST= "LIGHTNINGCAST";
        public static inline final LIVERAIL= "LIVERAIL";
        public static inline final OAS= "OAS";
        public static inline final OASIS= "OASIS";
        public static inline final AD_SERVER_OPENX_V2= "OPENX";
        public static inline final AD_SERVER_OPENX_V3= "OPENX3";


        public static function _Str_5664(k:String):AdServerConfig
        {
            switch (k.toUpperCase())
            {
                case ADIFY:
                    return new _Str_11622();
                case ADFORM:
                    return new _Str_12178();
                case ADTECH:
                    return new _Str_9861();
                case DART:
                    return new _Str_10632();
                case DIRECT:
                    return new _Str_4664();
                case INJECT:
                    return new _Str_6762();
                case LIGHTNINGCAST:
                    return new _Str_10009();
                case LIVERAIL:
                    return new _Str_10743();
                case OAS:
                    return new _Str_10867();
                case OASIS:
                    return new _Str_10310();
                case AD_SERVER_OPENX_V2:
                    return new _Str_10391();
                case AD_SERVER_OPENX_V3:
                    return new _Str_11383();
                default:
                    return new _Str_4664();
            }
        }

	public function new() {}
    }

