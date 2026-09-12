package org.openvideoads.vast.events
;
    import flash.events.Event;
    import org.openvideoads.vast.schedule.Stream;

     class _Str_8609 extends Event 
    {
        public static inline final _Str_7412= "schedule-stream";
        public static inline final _Str_19519= "remove-stream";

        var _Str_1430:Stream = null;
        var _Str_16686:Int = -1;

        public function new(k:String, _arg_2:Int, _arg_3:Stream, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._Str_16686 = _arg_2;
            this._Str_1430 = _arg_3;
        }

        
        public var _Str_22367(get,set):Int;
public function  set__Str_22367(k:Int):Int        {
            return this._Str_16686 = k;
        }
public function  get__Str_22367():Int
        {
            return this._Str_16686;
        }

        
        public var stream(get,set):Stream;
public function  set_stream(k:Stream):Stream        {
            return this._Str_1430 = k;
        }
public function  get_stream():Stream
        {
            return this._Str_1430;
        }
    }

