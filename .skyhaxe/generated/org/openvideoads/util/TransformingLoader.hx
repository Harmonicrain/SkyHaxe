package org.openvideoads.util
;
    import flash.net.URLLoader;

     class TransformingLoader extends URLLoader 
    {
        var _Str_3676:Array<ASAny> = null;


        public var transformers(never,set):Array<ASAny>;
public function  set_transformers(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_3676 = k;
        }

        public var transformedData(get,never):String;
public function  get_transformedData():String
        {
            var k:String = null;
            var _local_2 = 0;
            if (this._Str_3676 != null)
            {
                if (this._Str_3676.length > 0)
                {
                    k = this.data;
                    _local_2 = 0;
                    while (_local_2 < this._Str_3676.length)
                    {
                        if ((ASCompat.hasOwnProperty(this._Str_3676[_local_2], "pattern") && ASCompat.hasOwnProperty(this._Str_3676[_local_2], "replace")))
                        {
                            k = new compat.RegExp(this._Str_3676[_local_2].pattern, (ASCompat.hasOwnProperty(this._Str_3676[_local_2], "command") ? this._Str_3676[_local_2].command : "g")).replace(k, this._Str_3676[_local_2].replace);
                        }
                        _local_2++;
                    }
                }
                return k;
            }
            return this.data;
        }

	public function new() { super(); }
    }

