package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;

     class LinearAdMetaDataConfig extends Debuggable 
    {
        var _title:String = null;
        var _Str_1858:String = null;

        public function new(k:ASObject=null)
        {
            super();
            this.initialise(k);
        }

        public function initialise(k:ASObject)
        {
            if (k != null)
            {
                if (k.title != /*undefined*/null)
                {
                    this._title = k.title;
                }
                if (k.description != /*undefined*/null)
                {
                    this._Str_1858 = k.description;
                }
            }
        }

        
        public var title(get,set):String;
public function  get_title():String
        {
            return this._title;
        }
public function  set_title(k:String):String        {
            return this._title = k;
        }

        public function _Str_24997():Bool
        {
            return !(this._title == null);
        }

        
        public var description(get,set):String;
public function  get_description():String
        {
            return this._Str_1858;
        }
public function  set_description(k:String):String        {
            return this._Str_1858 = k;
        }

        public function _Str_22342():Bool
        {
            return !(this._Str_1858 == null);
        }

        function _Str_14334(k:String, _arg_2:String, _arg_3:String):String
        {
            var _local_4= new compat.RegExp(_arg_2, "g");
            return _local_4.replace(k, _arg_3);
        }

        public function _Str_25280(k:String="", _arg_2:String="0", _arg_3:Int=-1):String
        {
            var _local_4:String = null;
            if (this._Str_24997())
            {
                _local_4 = this._Str_14334(this._title, "__duration__", _arg_2);
                _local_4 = this._Str_14334(_local_4, "__index__", Std.string(_arg_3));
                return _local_4;
            }
            return k;
        }

        public function _Str_23078(k:String="", _arg_2:String="0", _arg_3:Int=-1):String
        {
            var _local_4:String = null;
            if (this._Str_22342())
            {
                _local_4 = this._Str_14334(this._Str_1858, "__duration__", _arg_2);
                _local_4 = this._Str_14334(_local_4, "__index__", Std.string(_arg_3));
                return _local_4;
            }
            return k;
        }
    }

