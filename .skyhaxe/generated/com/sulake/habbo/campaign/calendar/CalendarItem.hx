package com.sulake.habbo.campaign.calendar
;
    import flash.geom.Point;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.parser.campaign.CampaignCalendarData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;

     class CalendarItem 
    {
        public static inline final _Str_5399= 1;
        public static inline final _Str_8424= 2;
        public static inline final _Str_10321= 3;
        public static inline final _Str_10951= 4;
        static inline final CAMPAIGN_DAY_GENERIC_BUTTON= "campaign_day_generic_button";
        static inline final CAMPAIGN_DAY_GENERIC_ACTIVATED= "campaign_day_generic_activated";
        static inline final CAMPAIGN_OPENED= "campaign_opened";
        static inline final CAMPAIGN_GENERIC_LOCK= "campaign_generic_lock";
        static final _Str_21760:Vector<Point> = Vector.ofArray([new Point(-2, -5), new Point(3, -4), new Point(-3, -3)]);


        public static function _Str_15147(k:IWindowContainer, _arg_2:CampaignCalendarData, _arg_3:Int):IWindowContainer
        {
            var _local_4= Std.downcast(k.clone() , IWindowContainer);
            var _local_5= Std.downcast(_local_4.findChildByName("bitmap_bg") , IStaticBitmapWrapperWindow);
            var _local_6= Std.downcast(_local_4.findChildByName("bitmap_opened_bg") , IStaticBitmapWrapperWindow);
            var _local_7= Std.downcast(_local_4.findChildByName("bitmap_lock") , IStaticBitmapWrapperWindow);
            var _local_8= _Str_9903(_arg_2, _arg_3);
            switch (_local_8)
            {
                case CalendarItem._Str_8424:
                    _local_5.assetUri = CAMPAIGN_DAY_GENERIC_BUTTON;
                    _local_7.assetUri = null;
                    _local_6.visible = false;
                    
                case CalendarItem._Str_10321
                   | CalendarItem._Str_10951:
                    _local_5.assetUri = CAMPAIGN_DAY_GENERIC_BUTTON;
                    _local_7.assetUri = CAMPAIGN_GENERIC_LOCK;
                    _local_6.visible = false;
                    
                case CalendarItem._Str_5399:
                    _local_5.assetUri = CAMPAIGN_DAY_GENERIC_ACTIVATED;
                    _local_7.assetUri = "";
                    _local_6.visible = true;
                    
            }
            return _local_4;
        }

        public static function _Str_3820(k:IWindowContainer, _arg_2:CampaignCalendarData, _arg_3:Int, _arg_4:Int)
        {
            var _local_5= Std.downcast(k.findChildByName("bitmap_bg") , IStaticBitmapWrapperWindow);
            if (_local_5 == null)
            {
                return;
            }
            if (_arg_3 == _arg_4)
            {
                if (_Str_9903(_arg_2, _arg_3) == CalendarItem._Str_8424)
                {
                    _Str_6955(_local_5);
                }
            }
        }

        public static function _Str_13922(k:IWindowContainer, _arg_2:ASObject)
        {
            var _local_3= Std.downcast(k.findChildByName("bitmap_bg") , IStaticBitmapWrapperWindow);
            var _local_4= Std.downcast(k.findChildByName("bitmap_opened_bg") , IStaticBitmapWrapperWindow);
            var _local_5= Std.downcast(k.findChildByName("bitmap_icon") , IStaticBitmapWrapperWindow);
            var _local_6= Std.downcast(k.findChildByName("bitmap_icon2") , IBitmapWrapperWindow);
            _local_3.assetUri = CAMPAIGN_DAY_GENERIC_ACTIVATED;
            _local_6.y = (_local_5.y = -6);
            _local_4.visible = true;
            if (Std.is(_arg_2 , String))
            {
                _local_5.assetUri = ASCompat.asString(_arg_2 );
                _local_6.bitmap = null;
                _Str_6955(_local_5);
            }
            if (Std.is(_arg_2 , BitmapData))
            {
                _local_5.assetUri = "";
                _local_6.bitmap = ASCompat.dynamicAs(_arg_2 , BitmapData);
                _Str_6955(_local_5);
                _Str_6955(_local_6);
            }
        }

        public static function _Str_6955(k:IWindow)
        {
            new CalendarItemWiggle(k);
        }

        public static function _Str_9903(k:CampaignCalendarData, _arg_2:Int):Int
        {
            if (k._Str_10724.indexOf(_arg_2) > -1)
            {
                return CalendarItem._Str_5399;
            }
            switch (true)
            {
                case (_ == (_arg_2 > k._Str_5472) => true):
                    return CalendarItem._Str_10951;
                case (_ == (k._Str_14267.indexOf(_arg_2) > -1) => true):
                    return CalendarItem._Str_10321;

default:
            }
            return CalendarItem._Str_8424;
        }

	public function new() {}
    }


