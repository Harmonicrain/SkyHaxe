package com.sulake.habbo.ui.widget.furniture.mannequin
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.avatar._enum.AvatarFigurePartType;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.MannequinWidgetHandler;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.avatar.IAvatarFigureContainer;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.SetMannequinFigureComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.SetMannequinNameComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.UseFurnitureMessageComposer;

     class MannequinWidget extends RoomWidgetBase
    {
        static inline final _Str_9305= 0;
        static inline final _Str_11074= 1;
        static inline final _Str_10942= 2;
        static inline final _Str_8565= 3;
        static inline final _Str_9053= 4;
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final SAVE_BUTTON= "save_button";
        static inline final WEAR_BUTTON= "wear_button";
        static inline final CONFIGURE_BUTTON= "configure_button";
        static inline final GET_CLUB_BUTTON= "get_club_button";
        static inline final CANCEL_TEXT= "cancel_text";
        static inline final BACK_REGION= "back_region";
        static inline final OK_BUTTON= "ok_button";
        static inline final OUTFIT_NAME_SET= "outfit_name_set";
        static inline final OUTFIT_NAME_SHOW= "outfit_name_show";
        static inline final _Str_9071= 0;
        static inline final _Str_8000= 1;
        static inline final _Str_8218= 2;
        static inline final _Str_18139:UInt = 0;
        static inline final _Str_17568:UInt = 8956552;
        static inline final _Str_15584:UInt = 0x777777;
        static final _Str_9402:Array<ASAny> = [AvatarFigurePartType.CHEST_ACCESSORY, AvatarFigurePartType.COAT_CHEST, AvatarFigurePartType.CHEST, AvatarFigurePartType.LEGS, AvatarFigurePartType.SHOES, AvatarFigurePartType.WAIST_ACCESSORY];
        static final _Str_10597:Array<ASAny> = ["hd", 99999, ([99998] : Array<Dynamic>)];
        static inline final _Str_5044= 13;
        static inline final _Str_3830= 14;

        var _window:IWindowContainer;
        var _furniId:Int = 0;
        var _mannequinFigure:String;
        var _mannequinGender:String;
        var _mannequinClubLevel:Int = 0;
        var _savedOutfitName:String;
        var _nameState:Int = -1;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this.handler.widget = this;
        }

        public var handler(get,never):MannequinWidgetHandler;
public function  get_handler():MannequinWidgetHandler
        {
            return Std.downcast(_handler , MannequinWidgetHandler);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            super.dispose();
        }

        public function open(k:Int, _arg_2:String, _arg_3:String, _arg_4:String)
        {
            this._furniId = k;
            this._mannequinFigure = _arg_2;
            this._mannequinGender = _arg_3;
            this._savedOutfitName = _arg_4;
            var _local_5= Std.downcast(_handler , MannequinWidgetHandler).container.roomSession;
            var _local_6= Std.downcast(_handler , MannequinWidgetHandler).container.sessionDataManager;
            var _local_7= ((_local_5.isRoomOwner || (_local_5.roomControllerLevel >= RoomControllerLevel.GUEST)) || _local_6.isAnyRoomController);
            var _local_8= Std.downcast(_handler , MannequinWidgetHandler).container.avatarRenderManager;
            var _local_9= _local_8._Str_718(_arg_2);
            this._mannequinClubLevel = _local_8._Str_932(_local_9, this._mannequinGender, _Str_9402);
            var _local_10= this._Str_24391(_local_7, _local_6.gender, _local_6.clubLevel, _arg_3, this._mannequinClubLevel);
            this._Str_3248(_local_10);
            var _local_11= ((ASCompat.stringAsBool(this._savedOutfitName) && (!(this._savedOutfitName == ""))) ? _Str_8218 : _Str_9071);
            this._Str_6655(_local_11);
            this._window.visible = true;
        }

        function _Str_24391(k:Bool, _arg_2:String, _arg_3:Int, _arg_4:String, _arg_5:Int):Int
        {
            if (k)
            {
                return _Str_9305;
            }
            if (_arg_2.toLowerCase() != _arg_4.toLowerCase())
            {
                return _Str_9053;
            }
            if (_arg_3 < _arg_5)
            {
                return _Str_8565;
            }
            return _Str_10942;
        }

        function _Str_3248(k:Int)
        {
            var _local_2:BitmapData = null;
            var _local_3:IAvatarFigureContainer = null;
            var _local_4= Std.downcast(_handler , MannequinWidgetHandler).container.sessionDataManager;
            var _local_5= _local_4.figure;
            var _local_6= Std.downcast(_handler , MannequinWidgetHandler).container.avatarRenderManager;
            var _local_7= ((ASCompat.stringAsBool(this._savedOutfitName) && (!(this._savedOutfitName == ""))) ? _Str_8218 : _Str_9071);
            if (this._window == null)
            {
                this._window = Std.downcast(windowManager.buildFromXML(((assets.getAssetByName("mannequin_widget_frame_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                this.addClickListener(HEADER_BUTTON_CLOSE);
                this._window.center();
            }
            Std.downcast(this._window , IFrameWindow).content.removeChildAt(0);
            var _local_8= this.createWindow(k);
            Std.downcast(this._window , IFrameWindow).content.addChild(_local_8);
            switch (k)
            {
                case _Str_9305:
                    this.addClickListener(CONFIGURE_BUTTON);
                    this.addClickListener(WEAR_BUTTON);
                    this._Str_24329(OUTFIT_NAME_SET);
                    this.addClickListener(OUTFIT_NAME_SET);
                    _local_3 = _local_6._Str_718(this._mannequinFigure);
                    this._Str_17455(_local_3);
                    _local_2 = this.createAvatarImage(_local_3.getFigureString());
                    this._Str_11068(this._mannequinClubLevel);
                    this._Str_6655(_local_7);
                    this._Str_23723();
                    
                case _Str_11074:
                    this.addClickListener(SAVE_BUTTON);
                    this.addClickListener(BACK_REGION);
                    _local_3 = _local_6._Str_718(_local_5);
                    this._Str_17455(_local_3);
                    _local_2 = this.createAvatarImage(_local_3.getFigureString());
                    this._Str_11068(_local_6._Str_932(_local_3, _local_4.gender, _Str_9402));
                    this._Str_6655(_local_7);
                    
                case _Str_10942:
                    this.addClickListener(WEAR_BUTTON);
                    _local_3 = this._Str_19759(_local_5, this._mannequinFigure);
                    _local_2 = this.createAvatarImage(_local_3.getFigureString());
                    this._Str_11068(this._mannequinClubLevel);
                    this._Str_6655(_local_7);
                    
                case _Str_8565:
                    this.addClickListener(GET_CLUB_BUTTON);
                    _local_3 = this._Str_19759(_local_5, this._mannequinFigure);
                    _local_2 = this.createAvatarImage(_local_3.getFigureString());
                    this._Str_11068(this._mannequinClubLevel);
                    
                case _Str_9053:
                    this.addClickListener(OK_BUTTON);
                    _local_3 = _local_6._Str_718(this._mannequinFigure);
                    this._Str_17455(_local_3);
                    _local_2 = this.createAvatarImage(_local_3.getFigureString());
                    this._Str_11068(this._mannequinClubLevel);
                    
                default:
                    throw new ASError(("Invalid type for mannequin widget content apply: " + Std.string(k)));
            }
            this._Str_3060(_local_8, _local_2);
        }

        function createWindow(k:Int):IWindowContainer
        {
            var _local_2:IAsset = null;
            var _local_3:IWindowContainer = null;
            switch (k)
            {
                case _Str_9305:
                    _local_2 = _assets.getAssetByName("mannequin_controller_main_xml");
                    
                case _Str_11074:
                    _local_2 = _assets.getAssetByName("mannequin_controller_save_xml");
                    
                case _Str_10942:
                    _local_2 = _assets.getAssetByName("mannequin_peer_main_xml");
                    
                case _Str_8565:
                    _local_2 = _assets.getAssetByName("mannequin_no_club_xml");
                    
                case _Str_9053:
                    _local_2 = _assets.getAssetByName("mannequin_wrong_gender_xml");
                    
                default:
                    throw new ASError(("Invalid type for mannequin widget content creation: " + Std.string(k)));
            }
            _local_3 = Std.downcast(Std.downcast(_handler , MannequinWidgetHandler).container.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            return _local_3;
        }

        function _Str_17455(k:IAvatarFigureContainer)
        {
            var _local_2:String = null;
            final _iter_ = k._Str_1016(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_Str_9402.indexOf(_local_2) == -1)
                {
                    k._Str_923(_local_2);
                }
            }
            k._Str_830(_Str_10597[0], ASCompat.toInt(_Str_10597[1]), _Str_10597[2]);
        }

        function createAvatarImage(k:String):BitmapData
        {
            var _local_2= Std.downcast(_handler , MannequinWidgetHandler).container.avatarRenderManager;
            var _local_3= _local_2.createAvatarImage(k, AvatarScaleType.LARGE);
var _local_4= _local_3.getCroppedImage(AvatarSetType.FULL);
            _local_3.dispose();
            return _local_4;
        }

        function _Str_19759(k:String, _arg_2:String):IAvatarFigureContainer
        {
            var _local_6:String = null;
            var _local_3= Std.downcast(_handler , MannequinWidgetHandler).container.avatarRenderManager;
            var _local_4= _local_3._Str_718(k);
            var _local_5= _local_3._Str_718(_arg_2);
            final _iter_ = _Str_9402; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                _local_4._Str_923(_local_6);
            }
            final _iter_ = _local_5._Str_1016(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                _local_4._Str_830(_local_6, _local_5.getPartSetId(_local_6), _local_5._Str_815(_local_6));
            }
            return _local_4;
        }

        function _Str_11068(k:Int)
        {
            var _local_2= Std.downcast(this._window.findChildByName("club_icon") , IIconWindow);
            if (_local_2 == null)
            {
                return;
            }
            switch (k)
            {
                case HabboClubLevelEnum.NO_CLUB:
                    _local_2.visible = false;
                    return;
                case HabboClubLevelEnum.CLUB:
                    _local_2.style = _Str_5044;
                    _local_2.visible = true;
                    return;
                case HabboClubLevelEnum.VIP:
                    _local_2.style = _Str_3830;
                    _local_2.visible = true;
                    return;
            }
        }

        function _Str_3060(k:IWindowContainer, _arg_2:BitmapData)
        {
            var _local_6:BitmapData = null;
            if (((!(k != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            var _local_3= Std.downcast(k.findChildByName("preview_image") , IBitmapWrapperWindow);
            if (_local_3.bitmap == null)
            {
                _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height);
            }
            var _local_4= assets.getAssetByName("mannequin_preview_bg_png") ;
            if (_local_4 != null)
            {
                _local_6 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                _local_3.bitmap.copyPixels(_local_6, _local_6.rect, new Point(0, 0));
            }
            var _local_5= new Point(((_local_3.width - _arg_2.width) / 2), ((_local_3.height - _arg_2.height) / 2));
            _local_3.bitmap.copyPixels(_arg_2, _arg_2.rect, _local_5, null, null, true);
        }

        function _Str_23723()
        {
            var _local_2:BitmapDataAsset = null;
            var k= Std.downcast(this._window.findChildByName("write_deco") , IBitmapWrapperWindow);
            if (k != null)
            {
                _local_2 = Std.downcast(_assets.getAssetByName("small_pen") , BitmapDataAsset);
                k.bitmap = ASCompat.dynamicAs(_local_2.content , BitmapData);
                k.disposesBitmap = false;
            }
        }

        function close()
        {
            this._window.visible = false;
        }

        function _Str_6655(k:Int)
        {
            this._nameState = k;
            var _local_2= Std.downcast(this._window.findChildByName(OUTFIT_NAME_SET) , ITextWindow);
            if (_local_2 != null)
            {
                switch (k)
                {
                    case _Str_9071:
                        _local_2.text = this.handler.container.localization.getLocalization("mannequin.widget.set_name_hint");
                        _local_2.textColor = _Str_15584;
                        _local_2.italic = true;
                        
                    case _Str_8000:
                        _local_2.textColor = _Str_17568;
                        _local_2.italic = false;
                        
                    case _Str_8218:
                        _local_2.text = this._savedOutfitName;
                        _local_2.textColor = _Str_18139;
                        _local_2.italic = false;
                        
                    default:
                        _local_2.text = this.handler.container.localization.getLocalization("mannequin.widget.set_name_hint");
                        _local_2.textColor = _Str_15584;
                }
            }
            var _local_3= Std.downcast(this._window.findChildByName(OUTFIT_NAME_SHOW) , ITextWindow);
            if ((((_local_3 != null) && ASCompat.stringAsBool(this._savedOutfitName)) && (!(this._savedOutfitName == ""))))
            {
                _local_3.text = (("'" + this._savedOutfitName) + "'");
            }
        }

        function _Str_24030()
        {
            var k= Std.downcast(this._window.findChildByName(OUTFIT_NAME_SET) , ITextWindow);
            if (k != null)
            {
                k.text = "";
            }
        }

        function saveOutfit()
        {
            this.handler.container.connection.send(new SetMannequinFigureComposer(this._furniId));
        }

        function _Str_20994()
        {
            var k= this._Str_23640();
            this.handler.container.connection.send(new SetMannequinNameComposer(this._furniId, k));
            this._savedOutfitName = k;
            this._Str_6655(_Str_8218);
        }

        function _Str_23640():String
        {
            var k= Std.downcast(this._window.findChildByName(OUTFIT_NAME_SET) , ITextWindow).text;
            var _local_2= this.handler.container.localization.getLocalization("mannequin.widget.set_name_hint");
            return (k == _local_2) ? "" : k;
        }

        function addClickListener(k:String)
        {
            this._window.findChildByName(k).addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
        }

        function _Str_24329(k:String)
        {
            this._window.findChildByName(k).addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_24123);
        }

        function _Str_24123(k:WindowKeyboardEvent)
        {
            if (k.keyCode == 13)
            {
                this._Str_20994();
            }
            else
            {
                if (this._nameState != _Str_8000)
                {
                    this._Str_6655(_Str_8000);
                }
            }
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(_handler , MannequinWidgetHandler).container.sessionDataManager;
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL_TEXT
                   | OK_BUTTON:
                    this.close();
                    return;
                case SAVE_BUTTON:
                    this.saveOutfit();
                    this.close();
                    return;
                case WEAR_BUTTON:
                    if (_local_2.clubLevel < this._mannequinClubLevel)
                    {
                        this._Str_3248(_Str_8565);
                    }
                    else
                    {
                        if (_local_2.gender.toLowerCase() != this._mannequinGender.toLowerCase())
                        {
                            this._Str_3248(_Str_9053);
                        }
                        else
                        {
                            this.handler.container.connection.send(new UseFurnitureMessageComposer(this._furniId));
                            this.close();
                        }
                    }
                    return;
                case CONFIGURE_BUTTON:
                    this._Str_20994();
                    this._Str_3248(_Str_11074);
                    return;
                case BACK_REGION:
                    this._Str_3248(_Str_9305);
                    return;
                case GET_CLUB_BUTTON:
                    Std.downcast(_handler , MannequinWidgetHandler).container.catalog.openClubCenter();
                    this.close();
                    return;
                case OUTFIT_NAME_SET:
                    if (this._nameState == _Str_9071)
                    {
                        this._Str_24030();
                        this._Str_6655(_Str_8000);
                    }
                    else
                    {
                        if (this._nameState == _Str_8218)
                        {
                            this._Str_6655(_Str_8000);
                        }
                    }
                    return;
            }
        }
    }

