package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.playlist._Str_6835;
    import org.openvideoads.vast.playlist._Str_4575;
    import org.openvideoads.vast.playlist._Str_7812;

     class ShowsPlaylistConfigGroup extends Debuggable implements _Str_6835 
    {
        var _Str_577:String = null;
        var _type:Int = 5;
        var _Str_2519:_Str_4575 = null;

        public function new(k:ASObject)
        {
            super();
            if (k.type != /*undefined*/null)
            {
                this._type = _Str_7812.getType(k.type);
            }
            if (((!(k.url == /*undefined*/null)) || (!(k.file == /*undefined*/null))))
            {
                this._Str_577 = ((k.url != /*undefined*/null) ? k.url : k.file);
                this._Str_24471();
            }
        }

        function _Str_24471()
        {
            if (this._type != -1)
            {
                this._Str_2519 = _Str_7812._Str_19936(this._type);
                this._Str_2519._Str_16925(this._Str_577, this);
            }
        }

        public function _Str_16701(k:_Str_4575)
        {
        }

        
        public var url(get,set):String;
public function  set_url(k:String):String        {
            return this._Str_577 = k;
        }
public function  get_url():String
        {
            return this._Str_577;
        }

        
        public var type(get,set):Int;
public function  set_type(k:Int):Int        {
            return this._type = k;
        }
public function  get_type():Int
        {
            return this._type;
        }

        public function _Str_10087():Array<ASAny>
        {
            if (this._Str_2519 != null)
            {
                return this._Str_2519._Str_10087();
            }
            return new Array<ASAny>();
        }
    }

