package org.openvideoads.vast.server.request
;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.vast.server.request.injected._Str_9148;
    import org.openvideoads.vast.server.request.direct._Str_11961;

     class AdServerRequestType 
    {
        public static inline final DIRECT= "DIRECT";
        public static inline final INJECT= "INJECT";


        public static function create(k:String):AdServerRequest
        {
            if (StringUtils._Str_2576(k, INJECT))
            {
                return new _Str_9148();
            }
            return new _Str_11961();
        }

	public function new() {}
    }

