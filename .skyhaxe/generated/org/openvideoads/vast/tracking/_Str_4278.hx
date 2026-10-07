package org.openvideoads.vast.tracking
;
    import org.openvideoads.base.Debuggable;

     class _Str_4278 extends Debuggable 
    {
        static inline final _Str_16850= "BA EA 1Q HW 3Q CS CE SN HN EC DC TN";

        var _Str_5970:Float = Math.NaN;
        var _Str_2467:Float = Math.NaN;
        var _Str_6324:String;
        var _Str_22415:String = "TM BA EA 1Q HW 3Q SN HN NS NE TN";

        public function new(k:Float, _arg_2:Float=0, _arg_3:String=null)
        {
            super();
            this._Str_5970 = k;
            this._Str_2467 = _arg_2;
            this._Str_6324 = _arg_3;
        }

        public function _Str_26042():Bool
        {
            return this._Str_22415.indexOf(this.label) > -1;
        }

        public function _Str_23283():Bool
        {
            return _Str_16850.indexOf(this._Str_6324) > -1;
        }

        public var milliseconds(get,never):Float;
public function  get_milliseconds():Float
        {
            return this._Str_5970;
        }

        public var seconds(get,never):Float;
public function  get_seconds():Float
        {
            return this._Str_5970 / 1000;
        }

        public var duration(get,never):Float;
public function  get_duration():Float
        {
            return this._Str_2467;
        }

        public var label(get,never):String;
public function  get_label():String
        {
            return this._Str_6324;
        }

        public function toString():String
        {
            return ((((("TimeEvent(time point: " + Std.string(this._Str_5970)) + ", label: ") + this._Str_6324) + ", duration: ") + Std.string(this._Str_2467)) + ")";
        }
    }

