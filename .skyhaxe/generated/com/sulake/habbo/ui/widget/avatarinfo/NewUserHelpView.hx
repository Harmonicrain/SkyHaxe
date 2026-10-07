package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;

     class NewUserHelpView extends AvatarContextInfoButtonView 
    {
        var _caption:String = "";

        public function new(k:AvatarInfoWidget)
        {
            super(k);
            this._caption = k.localization.getLocalization("room.enter.infostand.caption", "");
            _Str_12637 = k.configuration.getInteger("room.enter.infostand.fade.start.delay", 5000);
        }

        public static function setup(k:AvatarContextInfoButtonView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int)
        {
            AvatarContextInfoButtonView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
        }


        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
            var _local_2:IWindow = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            if (window == null)
            {
                k = ((_widget.assets.getAssetByName("new_user_help").content : com.sulake.core.utils.xml.XML) );
                _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                if (window == null)
                {
                    return;
                }
                _local_2 = window.findChildByName("help");
                _local_2.caption = this._caption;
                _window.invalidate();
            }
            activeView = _window;
        }

        public var widget(get,never):AvatarInfoWidget;
public function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }
    }




