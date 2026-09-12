package splash
;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.DisplayObjectContainer;
    import splash.images.*;

     class PhotoSplashScreen extends Sprite 
    {
        var _Str_1140:Class<Dynamic>;
        var _Str_1847:Class<Dynamic>;
        var splashImg1:Class<Dynamic>;
        var splashImg2:Class<Dynamic>;
        var splashImg3:Class<Dynamic>;
        var splashImg4:Class<Dynamic>;
        var splashImg5:Class<Dynamic>;
        var splashImg6:Class<Dynamic>;
        var splashImg7:Class<Dynamic>;
        var splashImg8:Class<Dynamic>;
        var splashImg9:Class<Dynamic>;
        var splashImg10:Class<Dynamic>;
        var splashImg11:Class<Dynamic>;
        var splashImg12:Class<Dynamic>;
        var splashImg13:Class<Dynamic>;
        var splashImg14:Class<Dynamic>;
        var splashImg15:Class<Dynamic>;
        var splashImg16:Class<Dynamic>;
        var splashImg17:Class<Dynamic>;
        var splashImg18:Class<Dynamic>;
        var splashImg19:Class<Dynamic>;
        var splashImg20:Class<Dynamic>;
        var splashImg21:Class<Dynamic>;
        var splashImg22:Class<Dynamic>;
        var splashImg23:Class<Dynamic>;
        var splashImg24:Class<Dynamic>;
        var splashImg25:Class<Dynamic>;
        var splashImg26:Class<Dynamic>;
        var splashImg27:Class<Dynamic>;
        var splashImg28:Class<Dynamic>;
        var splashImg29:Class<Dynamic>;
        var splashImg30:Class<Dynamic>;

        public function new(k:DisplayObjectContainer)
        {
            var _local_3:Bitmap = null;
            this._Str_1140 = _Str_905;
            this._Str_1847 = _Str_857;
            this.splashImg1 = PhotoSplashScreen_splashImg1;
            this.splashImg2 = PhotoSplashScreen_splashImg2;
            this.splashImg3 = PhotoSplashScreen_splashImg3;
            this.splashImg4 = PhotoSplashScreen_splashImg4;
            this.splashImg5 = PhotoSplashScreen_splashImg5;
            this.splashImg6 = PhotoSplashScreen_splashImg6;
            this.splashImg7 = PhotoSplashScreen_splashImg7;
            this.splashImg8 = PhotoSplashScreen_splashImg8;
            this.splashImg9 = PhotoSplashScreen_splashImg9;
            this.splashImg10 = PhotoSplashScreen_splashImg10;
            this.splashImg11 = PhotoSplashScreen_splashImg11;
            this.splashImg12 = PhotoSplashScreen_splashImg12;
            this.splashImg13 = PhotoSplashScreen_splashImg13;
            this.splashImg14 = PhotoSplashScreen_splashImg14;
            this.splashImg15 = PhotoSplashScreen_splashImg15;
            this.splashImg16 = PhotoSplashScreen_splashImg16;
            this.splashImg17 = PhotoSplashScreen_splashImg17;
            this.splashImg18 = PhotoSplashScreen_splashImg18;
            this.splashImg19 = PhotoSplashScreen_splashImg19;
            this.splashImg20 = PhotoSplashScreen_splashImg20;
            this.splashImg21 = PhotoSplashScreen_splashImg21;
            this.splashImg22 = PhotoSplashScreen_splashImg22;
            this.splashImg23 = PhotoSplashScreen_splashImg23;
            this.splashImg24 = PhotoSplashScreen_splashImg24;
            this.splashImg25 = PhotoSplashScreen_splashImg25;
            this.splashImg26 = PhotoSplashScreen_splashImg26;
            this.splashImg27 = PhotoSplashScreen_splashImg27;
            this.splashImg28 = PhotoSplashScreen_splashImg28;
            this.splashImg29 = PhotoSplashScreen_splashImg29;
            this.splashImg30 = PhotoSplashScreen_splashImg30;
            super();
            var _local_2= new Vector<Bitmap>(0);
            _local_3 = ASCompat.dynamicAs(Type.createInstance(this._Str_1140, []) , Bitmap);
            _local_2.push(_local_3);
            var _local_4:Class<Dynamic> = (this : ASAny)[("splashImg" + Std.string(Std.int((1 + Math.ffloor((Math.random() * 30))))))] ;
            if (_local_4 != null)
            {
                _local_3 = Type.createInstance(_local_4, []);
                _local_3.x = 96;
                _local_3.y = 51;
                _local_2.push(_local_3);
            }
            _local_3 = ASCompat.dynamicAs(Type.createInstance(this._Str_1847, []) , Bitmap);
            _local_2.push(_local_3);
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                addChild(_local_3);
            }
        }
    }

