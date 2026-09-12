package com.sulake.habbo.catalog.viewer
;

     class PageLocalization implements IPageLocalization 
    {
        public static inline final CATALOG_HEADER_IMAGE= "catalog.header.image";
        public static inline final CATALOG_HEADER_ICON= "catalog.header.icon";
        public static inline final CATALOG_HEADER_TITLE= "catalog.header.title";
        public static inline final CATALOG_HEADER_DESCRIPTION= "catalog.header.description";
        static final _Str_17252:Array<ASAny> = [CATALOG_HEADER_DESCRIPTION, "ctlg_description", "ctlg_special_txt", "ctlg_text_1", "ctlg_text_2"];
        static final _Str_15924:Array<ASAny> = [CATALOG_HEADER_IMAGE, "ctlg_teaserimg_1", "ctlg_special_img", "ctlg_teaserimg_2", "ctlg_teaserimg_3"];
        static final _Str_15198:ASDictionary<ASAny,ASAny> = new ASDictionary();
        static final _Str_3902:ASDictionary<ASAny,ASAny> = new ASDictionary();
        static final _Str_5903:ASDictionary<ASAny,ASAny> = new ASDictionary();

        var _images:Array<ASAny>;
        var _texts:Array<ASAny>;

        public function new(k:Array<ASAny>, _arg_2:Array<ASAny>)
        {
            this._images = k;
            this._texts = _arg_2;
        }

        public var imageCount(get,never):Int;
public function  get_imageCount():Int
        {
            return this._images.length;
        }

        public var textCount(get,never):Int;
public function  get_textCount():Int
        {
            return this._texts.length;
        }

        public function dispose()
        {
            this._images = null;
            this._texts = null;
        }

        public function hasLinks(k:String):Bool
        {
            return !(_Str_5903[k] == null);
        }

        public function _Str_20312(k:String):Array<ASAny>
        {
            return _Str_5903[k];
        }

        public function getTextElementName(k:Int, _arg_2:String):String
        {
            var _local_3:Array<ASAny> = _Str_3902[_arg_2];
            if (_local_3 == null)
            {
                _local_3 = _Str_17252;
            }
            if (k < _local_3.length)
            {
                return _local_3[k];
            }
            return "";
        }

        public function getImageElementName(k:Int, _arg_2:String):String
        {
            var _local_3:Array<ASAny> = _Str_15198[_arg_2];
            if (_local_3 == null)
            {
                _local_3 = _Str_15924;
            }
            if (k < _local_3.length)
            {
                return _local_3[k];
            }
            return "";
        }

        public function getTextElementContent(k:Int):String
        {
            if (k < this._texts.length)
            {
                return this._texts[k];
            }
            return "";
        }

        public function getImageElementContent(k:Int):String
        {
            if (k < this._images.length)
            {
                return this._images[k];
            }
            return "";
        }

        public function _Str_22305(k:Int):UInt
        {
            var _local_2:String = null;
            if (k < this._texts.length)
            {
                _local_2 = ASCompat.stringReplace(ASCompat.toString(this._texts[k]), "#", "0x");
                return ASCompat.toUInt(ASCompat.toNumber(_local_2));
            }
            return 0;
        }

	static final ___init = {

        {
            _Str_15198["frontpage4"] = ([PageLocalization.CATALOG_HEADER_IMAGE, "ctlg_teaserimg_1"] : Array<Dynamic>);
            _Str_3902["camera1"] = ([CATALOG_HEADER_DESCRIPTION, "ctlg_text_1"] : Array<Dynamic>);
            _Str_3902["presents"] = ([CATALOG_HEADER_DESCRIPTION, "ctlg_text1"] : Array<Dynamic>);
            _Str_3902["pets"] = ([CATALOG_HEADER_DESCRIPTION, "ctlg_text_1", "ctlg_text_2", "ctlg_text_3"] : Array<Dynamic>);
            _Str_3902["pets2"] = ([CATALOG_HEADER_DESCRIPTION, "ctlg_text_1", "ctlg_text_2", "ctlg_text_3"] : Array<Dynamic>);
            _Str_3902["pets3"] = ([CATALOG_HEADER_DESCRIPTION, "ctlg_text_1", "ctlg_text_2", "ctlg_text_3"] : Array<Dynamic>);
            _Str_3902["info_rentables"] = ([CATALOG_HEADER_DESCRIPTION, "ctlg_text_1", "ctlg_text_2", "ctlg_text_3", "ctlg_text_4", "ctlg_text_5"] : Array<Dynamic>);
            _Str_3902["info_duckets"] = (["ctlg_description"] : Array<Dynamic>);
            _Str_3902["info_loyalty"] = (["ctlg_description"] : Array<Dynamic>);
            _Str_3902["trophies"] = (["trophy.description", "trophy.enscription"] : Array<Dynamic>);
            _Str_3902["frontpage4"] = (["ctlg_txt1", "ctlg_txt2"] : Array<Dynamic>);
            _Str_3902["builders_club_frontpage"] = (["ctlg_description"] : Array<Dynamic>);
            _Str_3902["builders_club_addons"] = (["ctlg_description"] : Array<Dynamic>);
            _Str_3902["builders_club_loyalty"] = (["ctlg_description"] : Array<Dynamic>);
            _Str_5903["club_buy"] = (["club_link"] : Array<Dynamic>);
            _Str_5903["mad_money"] = (["ctlg_madmoney_button"] : Array<Dynamic>);
            _Str_5903["monkey"] = (["ctlg_teaserimg_1_region", "ctlg_special_img_region"] : Array<Dynamic>);
            _Str_5903["niko"] = (["ctlg_teaserimg_1_region", "ctlg_special_img_region"] : Array<Dynamic>);
            _Str_5903["pets3"] = (["ctlg_text_3"] : Array<Dynamic>);
        }

	null;
	};
    }

