package org.openvideoads.vast.model
;
     class _Str_5606 extends NonLinearVideoAd 
    {


        public var imageURL(get,never):String;
public function  get_imageURL():String
        {
            if (_Str_3366 != null)
            {
                return _Str_3366;
            }
            if (_Str_4309())
            {
                return _Str_577.getQualifiedStreamAddress();
            }
            return "";
        }

        override public function  get_content():String
        {
            return this.imageURL;
        }

	public function new() { super(); }
    }

