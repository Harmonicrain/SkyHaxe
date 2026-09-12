package deng.fzip
;
    import flash.events.Event;

     class _Str_661 extends Event 
    {
        public static inline final FILELOADED= "fileLoaded";

        public var file:FZipFile;

        public function new(k:String, _arg_2:FZipFile=null, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            this.file = _arg_2;
            super(k, _arg_3, _arg_4);
        }

        override public function clone():Event
        {
            return new _Str_661(type, this.file, bubbles, cancelable);
        }

        override public function toString():String
        {
            return ((((((((('[FZipEvent type="' + type) + '" filename="') + this.file.filename) + '" bubbles=') + Std.string(bubbles)) + " cancelable=") + Std.string(cancelable)) + " eventPhase=") + Std.string(eventPhase)) + "]";
        }
    }

