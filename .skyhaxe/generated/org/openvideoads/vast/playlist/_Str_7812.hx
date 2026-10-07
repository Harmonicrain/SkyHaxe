package org.openvideoads.vast.playlist
;
    import org.openvideoads.vast.playlist.smil.SMILPlaylist;
    import org.openvideoads.vast.playlist.mrss.MediaRSSPlaylist;
    import org.openvideoads.vast.schedule.StreamSequence;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;

     class _Str_7812 
    {
        public static inline final _Str_16654= 1;
        public static inline final _Str_19288= 2;
        public static inline final _Str_19097= 3;
        public static inline final _Str_10550= 4;
        public static inline final _Str_11385= 5;
        public static inline final _Str_21051= 6;


        public static function _Str_26421(k:StreamSequence, _arg_2:Int=1, _arg_3:ProvidersConfigGroup=null, _arg_4:ProvidersConfigGroup=null):_Str_4575
        {
            switch (_arg_2)
            {
                case _Str_10550:
                    return new SMILPlaylist(k, _arg_3, _arg_4);
                case _Str_11385:
                    return new MediaRSSPlaylist(k, _arg_3, _arg_4);
            }
            return new DefaultPlaylist(k, _arg_3, _arg_4);
        }

        public static function _Str_19936(k:Int=1):_Str_4575
        {
            switch (k)
            {
                case _Str_10550:
                    return new SMILPlaylist();
                case _Str_11385:
                    return new MediaRSSPlaylist();
            }
            return new DefaultPlaylist();
        }

        public static function getType(k:String):Int
        {
            switch (k.toUpperCase())
            {
                case "SMIL":
                    return _Str_10550;
                case "MRSS":
                    return _Str_11385;
            }
            return _Str_16654;
        }

	public function new() {}
    }

