package org.openvideoads.vast.server.events
;
    import flash.events.Event;
    import org.openvideoads.vast.server.response.AdServerTemplate;

     class TemplateEvent extends Event 
    {
        public static inline final LOADED= "loaded";
        public static inline final _Str_14592= "load-failed";
        public static inline final _Str_6699= "load-timeout";
        public static inline final _Str_6462= "load-deferred";

        var _data:ASObject = null;

        public function new(k:String, _arg_2:ASObject=null, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            if (_arg_2 != null)
            {
                this._data = _arg_2;
            }
        }

        public function _Str_13568():Bool
        {
            return !(this._data == null);
        }

        
        public var data(get,set):ASObject;
public function  set_data(k:ASObject):ASObject        {
            return this._data = k;
        }
public function  get_data():ASObject
        {
            return this._data;
        }

        public function _Str_18017():Bool
        {
            return (!(this._data == null)) && Std.is(this.data , AdServerTemplate);
        }

        public var template(get,never):AdServerTemplate;
public function  get_template():AdServerTemplate
        {
            return ASCompat.dynamicAs(this._data , AdServerTemplate);
        }

        override public function clone():Event
        {
            return new TemplateEvent(type, this._data, bubbles, cancelable);
        }

        override public function toString():String
        {
            if (this._data != null)
            {
                return Std.string(this._data);
            }
            return "No error message provided";
        }
    }

