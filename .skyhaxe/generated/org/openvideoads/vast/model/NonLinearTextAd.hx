package org.openvideoads.vast.model
;
    import flash.xml.*;

     class NonLinearTextAd extends NonLinearVideoAd 
    {
        var _title:String = null;
        var _Str_1858:String = null;
        var _Str_20556:String = null;


        override public function  set_codeBlock(k:String):String        {
            _Str_3366 = "<TextAd>";
            _Str_3366 = (_Str_3366 + k);
            _Str_3366 = (_Str_3366 + "</TextAd>");
            this.parse();
return k;
        }

        function parse()
        {
            var k= new com.sulake.core.utils.xml.XML(_Str_3366);
            if (k.length() > 0)
            {
                if (k.child("Title" )!= /*undefined*/null)
                {
                    this._title = ASCompat.xmlListToString(k.child("Title").text());
                }
                if (k.child("Description" )!= /*undefined*/null)
                {
                    this._Str_1858 = ASCompat.xmlListToString(k.child("Description").text());
                }
                if (k.child("CallToAction" )!= /*undefined*/null)
                {
                    this._Str_20556 = ASCompat.xmlListToString(k.child("CallToAction").text());
                }
            }
        }

        public var title(get,never):String;
public function  get_title():String
        {
            return this._title;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._Str_1858;
        }

        public var callToActionTitle(get,never):String;
public function  get_callToActionTitle():String
        {
            return this._Str_20556;
        }

        override public function rawContentAsObject():ASObject
        {
            return ({
                "type":"TEXT",
                "format":"TEXT",
                "content":{
                    "title":this.title,
                    "description":this.description,
                    "callToActionTitle":this.callToActionTitle
                }
            });
        }

	public function new() { super(); }
    }

