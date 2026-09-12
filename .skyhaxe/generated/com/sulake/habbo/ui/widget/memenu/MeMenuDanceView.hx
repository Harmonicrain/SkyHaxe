package com.sulake.habbo.ui.widget.memenu
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDanceMessage;
    import com.sulake.habbo.tracking.HabboTracking;

     class MeMenuDanceView implements IMeMenuView 
    {
        var _widget:MeMenuWidget;
        var _window:IWindowContainer;


        public function init(k:MeMenuWidget, _arg_2:String)
        {
            this._widget = k;
            this.createWindow(_arg_2);
        }

        public function dispose()
        {
            this._widget = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        function createWindow(k:String)
        {
            var _local_4:IItemListWindow = null;
            var _local_5:XmlAsset = null;
            var _local_7 = 0;
            var _local_8 = false;
            var _local_9:IWindow = null;
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("memenu_dance") , XmlAsset);
            if (_local_2 != null)
            {
                this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            }
            if (this._window == null)
            {
                throw new ASError("Failed to construct dance view window from XML!");
            }
            this._window.name = k;
            var _local_3:Array<ASAny> = [];
            _local_3.push(this._window.findChildByName("stop_dancing_button"));
            _local_3.push(this._window.findChildByName("back_btn"));
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_9  = _tmp_;
                if (_local_9 == null)
                {
                }
                else
                {
                    _local_9.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                }
            }
            _local_4 = Std.downcast(this._window.findChildByName("buttonContainer") , IItemListWindow);
            _local_5 = Std.downcast(this._widget.assets.getAssetByName("memenu_dance_button") , XmlAsset);
            if (_local_4 != null)
            {
                _local_7 = 1;
                while (_local_7 <= 4)
                {
                    _local_8 = false;
                    if (RoomWidgetDanceMessage._Str_17699.indexOf(_local_7) >= 0)
                    {
                        _local_8 = this._widget._Str_24765;
                    }
                    else
                    {
                        _local_8 = true;
                    }
                    if (_local_8)
                    {
                        _local_9 = this._widget.windowManager.buildFromXML(((_local_5.content : com.sulake.core.utils.xml.XML) )) ;
                        _local_9.name = (("dance_" + Std.string(_local_7)) + "_button");
                        _local_9.caption = (("${widget.memenu.dance" + Std.string(_local_7)) + "}");
                        _local_9.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                        _local_4.addListItemAt(_local_9, (_local_4.numListItems - 1));
                        if (this._widget.hasEffectOn)
                        {
                            _local_9.disable();
                        }
                        else
                        {
                            _local_9.enable();
                        }
                    }
                    _local_7++;
                }
            }
            var _local_6= this._window.findChildByName("club_info");
            if (((!(_local_6 == null)) && this._widget._Str_22242))
            {
                _local_6.visible = false;
            }
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_3:String = null;
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_2= k.target ;
            _local_3 = _local_2.name;
            switch (_local_3)
            {
                case "dance_1_button"
                   | "dance_2_button"
                   | "dance_3_button"
                   | "dance_4_button":
                    _local_4 = (cast _local_3.split("_"));
                    _local_5 = ASCompat.parseInt(_local_4[1]);
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetDanceMessage(_local_5));
                    this._widget.isDancing = true;
                    this._widget.hide();
                    HabboTracking.getInstance().trackEventLog("MeMenu", "click", "dance_start");
                    return;
                case "stop_dancing_button":
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetDanceMessage(RoomWidgetDanceMessage._Str_13814));
                    this._widget.isDancing = false;
                    this._widget.hide();
                    HabboTracking.getInstance().trackEventLog("MeMenu", "click", "dance_stop");
                    return;
                case "back_btn":
                    this._widget._Str_4568(MeMenuWidget.ME_MENU_TOP_VIEW);
                    return;
                default:
                    Logger.log([("Me Menu Dance View: unknown button: " + _local_3)]);
            }
        }

        public function _Str_6111(k:String, _arg_2:Int)
        {
        }
public function new(){}
    }

