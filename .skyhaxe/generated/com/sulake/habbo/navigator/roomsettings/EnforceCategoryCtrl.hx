package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCategory;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.roomsettings.UpdateRoomCategoryAndTradeSettingsComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class EnforceCategoryCtrl 
    {
        var _navigator:IHabboTransitionalNavigator;
        var _window:IFrameWindow;
        var _dialog:IModalDialog;
        var _categorySelection:Int = 0;
        var _tradeModeSelection:Int = 0;
        var _visibleAndSelectableCategories:Array<ASAny>;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._visibleAndSelectableCategories = [];
            this._navigator = k;
        }

        public function show(k:Int)
        {
            var _local_5:FlatCategory = null;
            var _local_6:Array<ASAny> = null;
            var _local_7:FlatCategory = null;
            this.close();
            this._dialog = this._navigator.windowManager.buildModalDialogFromXML(((this._navigator.assets.getAssetByName("enforce_category_xml").content : com.sulake.core.utils.xml.XML) ));
            this._window = Std.downcast(this._dialog.rootWindow , IFrameWindow);
            this._window.procedure = this.windowProcedure;
            this._window.center();
            this._window.findChildByName("header_button_close").visible = false;
            var _local_2= Std.downcast(this._window.findChildByName("trade_mode") , IDropMenuWindow);
            var _local_3= new Array<ASAny>();
            _local_3.push("${navigator.roomsettings.trade_not_allowed}");
            _local_3.push("${navigator.roomsettings.trade_not_with_Controller}");
            _local_3.push("${navigator.roomsettings.trade_allowed}");
            _local_2.populate(_local_3);
            _local_2.selection = 0;
            var _local_4= Std.downcast(this._window.findChildByName("category") , IDropMenuWindow);
            this._visibleAndSelectableCategories = [];
            final _iter_ = this._navigator.data._Str_11717; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                if (((!_local_5.automatic) && ((!_local_5._Str_13024) || (_local_5._Str_13024 && this._navigator.sessionData.hasSecurity(SecurityLevelEnum.COMMUNITY)))))
                {
                    this._visibleAndSelectableCategories.push(_local_5);
                }
            }
            _local_6 = new Array<ASAny>();
            final _iter_ = this._visibleAndSelectableCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_7  = _tmp_;
                _local_6.push(_local_7._Str_14718);
            }
            _local_4.populate(_local_6);
            _local_4.selection = 0;
        }

        function close()
        {
            if (((this._dialog != null) && (this._window != null)))
            {
                this._dialog.dispose();
                this._dialog = null;
                this._window = null;
            }
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "ok":
                        _local_3 = cast(this._visibleAndSelectableCategories[Std.int(Math.max(0, this._categorySelection))], FlatCategory).nodeId;
                        this._navigator.communication.connection.send(new UpdateRoomCategoryAndTradeSettingsComposer(this._navigator.data._Str_20386, _local_3, this._tradeModeSelection));
                        this.close();
                        
                }
            }
            else
            {
                if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
                {
                    switch (_arg_2.name)
                    {
                        case "category":
                            this._categorySelection = cast(_arg_2, IDropMenuWindow).selection;
                            return;
                        case "trade_mode":
                            this._tradeModeSelection = cast(_arg_2, IDropMenuWindow).selection;
                            return;
                    }
                }
            }
        }
    }








