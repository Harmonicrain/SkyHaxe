package com.sulake.habbo.ui.widget.infostand
;
    import flash.geom.Point;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.Map;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPetCommandMessage;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;

     class PetCommandTool 
    {
        static final DEFAULT_LOCATION:Point = new Point(100, 70);
        static inline final _Str_5169= 162;
        static inline final _Str_8071= 16;
        static inline final _Str_3835= 4;
        static inline final _Str_5037:UInt = 0xDADADA;
        static inline final _Str_4952:UInt = 0x3A3A3A;
        static inline final _Str_18292:UInt = 10513106;
        static inline final _Str_17141:UInt = 8734654;
        static inline final SKILL= "skill";
        static inline final _Str_18058= 15;

        static inline final _Str_22633= 1100;

        var _widget:InfoStandWidget;
        var _commandWindow:IFrameWindow;
        var _commandButtonTemplate:IWindow;
        var _enabledCommands:Map;
        var _currentPetId:Int = 0;
        var _currentPetName:String;
        var _disableTimer:Timer;

        public function new(k:InfoStandWidget)
        {
            this._widget = k;
            this._enabledCommands = new Map();
            this._disableTimer = new Timer(PetCommandTool._Str_22633);
            this._disableTimer.addEventListener(TimerEvent.TIMER, (this._Str_24724 : ASAny));
        }

        public static function hideChildren(k:IWindowContainer)
        {
            var _local_2 = 0;
            while (_local_2 < k.numChildren)
            {
                k.getChildAt(_local_2).visible = false;
                _local_2++;
            }
        }

        public static function getLowestPoint(k:IWindowContainer):Int
        {
            var _local_4:IWindow = null;
            var _local_2 = 0;
            var _local_3 = 0;
            while (_local_3 < k.numChildren)
            {
                _local_4 = k.getChildAt(_local_3);
                if (_local_4.visible)
                {
                    _local_2 = Std.int(Math.max(_local_2, (_local_4.y + _local_4.height)));
                }
                _local_3++;
            }
            return _local_2;
        }

        static function _Str_12421(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:UInt):BitmapData
        {
            _arg_2 = Std.int(Math.max(_arg_2, 1));
            k = Std.int(Math.max(k, 0));
            if (k > _arg_2)
            {
                k = _arg_2;
            }
            var _local_5= (k / _arg_2);
            var _local_6= 1;
            var _local_7= new BitmapData(_Str_5169, _Str_8071, false);
            _local_7.fillRect(new Rectangle(0, 0, _local_7.width, _local_7.height), _Str_5037);
            var _local_8= new Rectangle(_local_6, _local_6, (_local_7.width - (_local_6 * 2)), (_local_7.height - (_local_6 * 2)));
            _local_7.fillRect(_local_8, _Str_4952);
            var _local_9= new Rectangle(_local_6, (_local_6 + _Str_3835), (_local_7.width - (_local_6 * 2)), ((_local_7.height - (_local_6 * 2)) - _Str_3835));
            _local_9.width = (_local_5 * _local_9.width);
            _local_7.fillRect(_local_9, _arg_3);
            var _local_10= new Rectangle(_local_6, _local_6, (_local_7.width - (_local_6 * 2)), _Str_3835);
            _local_10.width = (_local_5 * _local_10.width);
            _local_7.fillRect(_local_10, _arg_4);
            return _local_7;
        }


        public function dispose()
        {
            if (this._disableTimer != null)
            {
                this._disableTimer.stop();
                this._disableTimer = null;
            }
            if (this._widget != null)
            {
                this._widget = null;
            }
            if (this._commandWindow != null)
            {
                this._commandWindow.dispose();
            }
            this._commandWindow = null;
        }

        public function _Str_18025():Int
        {
            return this._currentPetId;
        }

        public function isVisible():Bool
        {
            if (this._commandWindow == null)
            {
                return false;
            }
            return this._commandWindow.visible;
        }

        public function _Str_19046(k:Int, _arg_2:String, _arg_3:BitmapData, _arg_4:Int, _arg_5:Int, _arg_6:Float, _arg_7:Int, _arg_8:Array<ASAny>)
        {
            if (this._commandWindow == null)
            {
                return;
            }
            this._Str_9597(SKILL, Std.int((_arg_5 + _arg_6) * 100), (_arg_7 * 100), _Str_17141, _Str_18292, _arg_4);
            if (this._currentPetId == k)
            {
                return;
            }
            this._currentPetId = k;
            this._currentPetName = _arg_2;
            var _local_9= Std.downcast(this._commandWindow.findChildByName("pet_name") , ITextWindow);
            if (_local_9 != null)
            {
                _local_9.text = _arg_2;
            }
            this._Str_21945(_arg_3);
            var _local_10= ASCompat.dynamicAs(this._enabledCommands.getValue(k) , CommandConfiguration);
            if (_local_10 == null)
            {
                this._Str_20953();
                this._Str_23280(this._currentPetId);
            }
            else
            {
                this._Str_16721(_local_10);
            }
        }

        public function _Str_21945(k:BitmapData)
        {
            var _local_3:BitmapData = null;
            var _local_4:Point = null;
            var _local_2= Std.downcast(this._commandWindow.findChildByName("avatar_image") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                if (k != null)
                {
                    _local_3 = new BitmapData(_local_2.width, _local_2.height, true, 0);
                    _local_4 = new Point(0, 0);
                    _local_4.x = Math.fround(((_local_2.width - k.width) / 2));
                    _local_4.y = Math.fround(((_local_2.height - k.height) / 2));
                    _local_3.copyPixels(k, k.rect, _local_4);
                    _local_2.bitmap = _local_3;
                }
                else
                {
                    _local_2.bitmap = null;
                }
                _local_2.invalidate();
            }
        }

        function _Str_24724(k:TimerEvent)
        {
            var _local_2= ASCompat.dynamicAs(this._enabledCommands.getValue(this._currentPetId) , CommandConfiguration);
            this._Str_16721(_local_2);
            this._disableTimer.stop();
        }

        public function _Str_23216(k:Int, _arg_2:CommandConfiguration)
        {
            this._enabledCommands.remove(k);
            this._enabledCommands.add(k, _arg_2);
            if (k != this._currentPetId)
            {
                return;
            }
            this._Str_16721(_arg_2);
            this._disableTimer.stop();
        }

        public function showWindow(k:Bool)
        {
            if (k)
            {
                if (this._commandWindow == null)
                {
                    this._Str_23006();
                }
                this._commandWindow.visible = true;
            }
            else
            {
                if (this._commandWindow != null)
                {
                    this._commandWindow.visible = false;
                }
            }
            this._disableTimer.stop();
        }

        function _Str_23280(k:Int)
        {
            var _local_2= new RoomWidgetPetCommandMessage(RoomWidgetPetCommandMessage.RWPCM_REQUEST_PET_COMMANDS, k);
            this._widget.messageListener.processWidgetMessage(_local_2);
        }

        function _Str_23006()
        {
            var _local_6:BitmapDataAsset = null;
            var _local_7:BitmapData = null;
            var k= Std.downcast(this._widget.assets.getAssetByName("pet_commands") , XmlAsset);
            this._commandWindow = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._commandWindow == null)
            {
                throw new ASError("Failed to construct command window from XML!");
            }
            this._commandWindow.context.getDesktopWindow().addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_25490);
            this._commandButtonTemplate = cast(this._commandWindow.findChildByName("commands_container"), IWindowContainer).removeChildAt(0);
            var _local_2= this._commandWindow.findChildByName("header_button_close");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_22576);
            }
            var _local_3= this._commandWindow.findChildByName("description_link");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_25105);
            }
            var _local_4= this._commandWindow.findChildByName("avatar_image");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_25003);
            }
            var _local_5= Std.downcast(this._commandWindow.findChildByName("status_skill_icon") , IBitmapWrapperWindow);
            if (_local_5 != null)
            {
                _local_6 = Std.downcast(this._widget.assets.getAssetByName("icon_pet_skill") , BitmapDataAsset);
                _local_7 = ASCompat.dynamicAs(_local_6.content , BitmapData);
                _local_5.bitmap = _local_7.clone();
            }
            this._commandWindow.position = DEFAULT_LOCATION;
        }

        function _Str_16721(k:CommandConfiguration)
        {
            var _local_11:IButtonWindow = null;
            var _local_12 = 0;
            if (this._commandWindow == null)
            {
                return;
            }
            var _local_2= cast(this._commandWindow.findChildByName("commands_container"), IWindowContainer);
            hideChildren(_local_2);
            var _local_3= k.allCommandIds;
            var _local_4= 25;
            var _local_5 = 0;
            var _local_6= 86;
            var _local_7 = 0;
            var _local_8 = 0;
            while (_local_8 < _local_3.length)
            {
                _local_11 = Std.downcast(_local_2.getChildAt(_local_8) , IButtonWindow);
                if (_local_11 == null)
                {
                    _local_11 = Std.downcast(this._commandButtonTemplate.clone() , IButtonWindow);
                    _local_11.addEventListener(WindowMouseEvent.CLICK, this._Str_23490);
                    _local_2.addChild(_local_11);
                }
                _local_11.visible = true;
                _local_12 = ASCompat.toInt(_local_3[_local_8]);
                _local_11.id = _local_12;
                _local_11.caption = this._widget.localizations.getLocalization(("pet.command." + Std.string(_local_12)));
                if (k.isEnabled(_local_12))
                {
                    _local_11.enable();
                }
                else
                {
                    _local_11.disable();
                }
                _local_11.y = _local_7;
                if ((_local_8 % 2) == 1)
                {
                    _local_7 = (_local_7 + _local_4);
                    _local_11.x = _local_6;
                }
                else
                {
                    _local_11.x = _local_5;
                }
                _local_8++;
            }
            var _local_9= this._widget.config.getBoolean("pet.enhancements.enabled");
            var _local_10= (_local_9 ? 180 : 160);
            _local_2.height = getLowestPoint(_local_2);
            this._commandWindow.height = (_local_2.height + _local_10);
            this._disableTimer.stop();
        }

        function _Str_20953()
        {
            var _local_3:IButtonWindow = null;
            if (this._commandWindow == null)
            {
                return;
            }
            var k= cast(this._commandWindow.findChildByName("commands_container"), IWindowContainer);
            var _local_2 = 0;
            while (_local_2 < k.numChildren)
            {
                _local_3 = cast(k.getChildAt(_local_2), IButtonWindow);
                _local_3.disable();
                _local_2++;
            }
        }

        function _Str_22576(k:WindowMouseEvent)
        {
            this._commandWindow.visible = false;
        }

        function _Str_25105(k:WindowMouseEvent)
        {
            this._widget.windowManager.openHelpPage("help/pets/training");
        }

        function _Str_25003(k:WindowMouseEvent)
        {
            this._widget.messageListener.processWidgetMessage(new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_REQUEST_PET_UPDATE, this._currentPetId));
        }

        function _Str_23490(k:WindowMouseEvent)
        {
            var _local_2= k.target;
            var _local_3= _local_2.id;
            var _local_4= ("pet.command." + Std.string(_local_3));
            var _local_5= this._widget.localizations.getLocalization(_local_4);
            var _local_6= new RoomWidgetPetCommandMessage(RoomWidgetPetCommandMessage.RWPCM_PET_COMMAND, this._currentPetId, ((this._currentPetName + " ") + _local_5));
            this._widget.messageListener.processWidgetMessage(_local_6);
            this._Str_20953();
            this._disableTimer.start();
        }

        function _Str_25490(k:WindowEvent)
        {
            var _local_2:IWindow = null;
            var _local_3:Rectangle = null;
            if (((this._commandWindow != null) && (!this._commandWindow.disposed)))
            {
                _local_2 = k.window;
                _local_3 = new Rectangle();
                this._commandWindow.getGlobalRectangle(_local_3);
                if (_local_3.x > _local_2.width)
                {
                    this._commandWindow.x = (_local_2.width - this._commandWindow.width);
                    this._commandWindow.getGlobalRectangle(_local_3);
                }
                if ((_local_3.x + _local_3.width) <= 0)
                {
                    this._commandWindow.x = 0;
                    this._commandWindow.getGlobalRectangle(_local_3);
                }
                if (_local_3.y > _local_2.height)
                {
                    this._commandWindow.y = 0;
                    this._commandWindow.getGlobalRectangle(_local_3);
                }
                if ((_local_3.y + _local_3.height) <= 0)
                {
                    this._commandWindow.y = 0;
                    this._commandWindow.getGlobalRectangle(_local_3);
                }
            }
        }

        function _Str_9597(k:String, _arg_2:Int, _arg_3:Int, _arg_4:UInt, _arg_5:UInt, _arg_6:Int)
        {
            var _local_11:BitmapData = null;
            if (this._commandWindow == null)
            {
                return;
            }
            var _local_7= Std.downcast(this._commandWindow.findChildByName((("status_" + k) + "_container")) , IWindowContainer);
            if (_local_7 == null)
            {
                return;
            }
            _local_7.visible = (this._widget.config.getBoolean("pet.enhancements.enabled") && (_arg_6 == _Str_18058));
            var _local_8= Std.downcast(_local_7.findChildByName((("status_" + k) + "_value_text")) , ITextWindow);
            if (_local_8 != null)
            {
                _local_8.text = ((Std.string(_arg_2) + "/") + Std.string(_arg_3));
            }
            var _local_9= Std.downcast(_local_7.findChildByName((("status_" + k) + "_text")) , ITextWindow);
            if (_local_9 != null)
            {
                _local_9.caption = (("${infostand.pet.text.skill.next." + Std.string(_arg_6)) + "}");
            }
            var _local_10= Std.downcast(_local_7.findChildByName((("status_" + k) + "_bitmap")) , IBitmapWrapperWindow);
            if (_local_10 != null)
            {
                _local_11 = _Str_12421(_arg_2, _arg_3, _arg_4, _arg_5);
                if (_local_11 != null)
                {
                    _local_10.bitmap = _local_11;
                    _local_10.width = _local_11.width;
                    _local_10.height = _local_11.height;
                    _local_10.invalidate();
                }
            }
        }
    }

