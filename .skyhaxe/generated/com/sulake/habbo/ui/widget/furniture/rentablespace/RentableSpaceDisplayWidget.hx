package com.sulake.habbo.ui.widget.furniture.rentablespace
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.FurnitureRentableSpaceWidgetHandler;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.core.window.components.IItemListWindow;

     class RentableSpaceDisplayWidget extends RoomWidgetBase
    {
        static var _Str_4003:ASDictionary<ASAny,ASAny> = new ASDictionary();

        var _window:IWindowContainer;
        var _roomObject:IRoomObject;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this.ownHandler.widget = this;
        }

        var ownHandler(get,never):FurnitureRentableSpaceWidgetHandler;
function  get_ownHandler():FurnitureRentableSpaceWidgetHandler
        {
            return Std.downcast(_handler , FurnitureRentableSpaceWidgetHandler);
        }

        public function hide(k:IRoomObject)
        {
            if (this._roomObject != k)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._roomObject = null;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            this.hide(this._roomObject);
            super.dispose();
        }

        override public function  get_mainWindow():IWindow
        {
            return this._window;
        }

        public function show(k:IRoomObject)
        {
            this._roomObject = k;
            this.updateWidgetState();
        }

        function createWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = Std.downcast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(assets.getAssetByName("rentablespace_xml").content)) , IWindowContainer);
            this._window.procedure = this.windowProcedure;
            this._window.center();
            this._window.findChildByName("rent_button").disable();
            this._window.findChildByName("rented_view").visible = false;
            this._window.findChildByName("error_view").visible = false;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    switch (_arg_2.name)
                    {
                        case "header_button_close"
                           | "error_button_close":
                            this.hide(this._roomObject);
                            
                        case "rent_button":
                            this.ownHandler.rentSpace(this._roomObject.getId());
                            
                        case "cancel_rent_button":
                            this.ownHandler.cancelRent(this._roomObject.getId());
                            
                    }
            }
        }

        public function updateWidgetState()
        {
            if (this._roomObject == null)
            {
                return;
            }
            this.ownHandler.getRentableSpaceStatus(this._roomObject.getId());
        }

        public function _Str_23885(k:Bool, _arg_2:Bool, _arg_3:Int, _arg_4:Int, _arg_5:String, _arg_6:Int, _arg_7:Int)
        {
            var _local_8 = false;
            if (this._roomObject == null)
            {
                return;
            }
            this.createWindow();
            if (k)
            {
                this._window.findChildByName("rent_view").visible = false;
                this._window.findChildByName("error_view").visible = false;
                this._window.findChildByName("rented_view").visible = true;
                this._window.findChildByName("renter_name").caption = _arg_5;
                this._window.findChildByName("time_remaining_label").caption = FriendlyTime.format(this.ownHandler.container.localization, _arg_6);
                this._window.findChildByName("cancel_rent_button").visible = (this.ownHandler.container.isOwnerOfFurniture(this._roomObject) || this.ownHandler.container.sessionDataManager.hasSecurity(SecurityLevelEnum.MODERATOR));
                cast(this._window.findChildByName("rented_view"), IItemListWindow).arrangeListItems();
            }
            else
            {
                this._window.findChildByName("rented_view").visible = false;
                this._window.findChildByName("error_view").visible = false;
                this._window.findChildByName("rent_view").visible = true;
                this._window.findChildByName("price_label").caption = (Std.string(_arg_7) + " x");
                _local_8 = (_arg_7 <= this.ownHandler._Str_23322());
                if (!_arg_2)
                {
                    this._window.findChildByName("cant_rent_error").caption = _Str_4003[_arg_3];
                }
                else
                {
                    if (!_local_8)
                    {
                        this._window.findChildByName("cant_rent_error").caption = _Str_4003[200];
                    }
                    else
                    {
                        this._window.findChildByName("cant_rent_error").visible = false;
                        this._window.findChildByName("rent_button").enable();
                    }
                }
                cast(this._window.findChildByName("rent_view"), IItemListWindow).arrangeListItems();
            }
            if (!this._window.visible)
            {
                this._window.visible = true;
            }
        }

        public function _Str_23970(k:Int)
        {
            this._window.findChildByName("rent_view").visible = false;
            this._window.findChildByName("rented_view").visible = false;
            this._window.findChildByName("error_view").visible = true;
            this._window.findChildByName("error_message").caption = _Str_4003[k];
        }

	static final ___init = {

        {
            _Str_4003[100] = "${rentablespace.widget.error_reason_already_rented}";
            _Str_4003[101] = "${rentablespace.widget.error_reason_not_rented}";
            _Str_4003[102] = "${rentablespace.widget.error_reason_not_rented_by_you}";
            _Str_4003[103] = "${rentablespace.widget.error_reason_can_rent_only_one_space}";
            _Str_4003[200] = "${rentablespace.widget.error_reason_not_enough_credits}";
            _Str_4003[201] = "${rentablespace.widget.error_reason_not_enough_duckets}";
            _Str_4003[202] = "${rentablespace.widget.error_reason_no_permission}";
            _Str_4003[203] = "${rentablespace.widget.error_reason_no_habboclub}";
            _Str_4003[300] = "${rentablespace.widget.error_reason_disabled}";
            _Str_4003[400] = "${rentablespace.widget.error_reason_generic}";
        }

	null;
	};
    }

