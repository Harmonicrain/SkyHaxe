package org.openvideoads.vast.events
;
    import org.openvideoads.vast.model.CompanionAd;
    import flash.events.Event;

     class _Str_3117 extends _Str_4535 
    {
        public static inline final _Str_3831= "display-companion";
        public static inline final _Str_2703= "hide-companion";

        var _Str_17463:String = null;
        var _content:String = null;

        public function new(k:String, _arg_2:CompanionAd, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        public var companionAd(get,never):CompanionAd;
public function  get_companionAd():CompanionAd
        {
            return Std.downcast(this.nonLinearVideoAd , CompanionAd);
        }

        
        public var _Str_4022(get,set):String;
public function  set__Str_4022(k:String):String        {
            return this._Str_17463 = k;
        }
public function  get__Str_4022():String
        {
            return this._Str_17463;
        }

        
        public var content(get,set):String;
public function  set_content(k:String):String        {
            return this._content = k;
        }
public function  get_content():String
        {
            return this._content;
        }

        public function _Str_20014():Bool
        {
            return true;
        }

        public function _Str_22404():Bool
        {
            return false;
        }

        override public function clone():Event
        {
            var k= new _Str_3117(type, Std.downcast(nonLinearVideoAd , CompanionAd), bubbles, cancelable);
            k._Str_4022 = this._Str_17463;
            k.content = this._content;
            return k;
        }
    }

