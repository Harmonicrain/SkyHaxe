package com.sulake.habbo.ui.widget.doorbell
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

     class DoorbellView 
    {
        var _doorbell:DoorbellWidget;
        var _frame:IFrameWindow;
        var _list:IItemListWindow;

        public function new(k:DoorbellWidget)
        {
            this._doorbell = k;
        }

        public function dispose()
        {
            this._list = null;
            this._doorbell = null;
            if (this._frame != null)
            {
                this._frame.dispose();
                this._frame = null;
            }
        }

        public function update()
        {
            var k = 0;
            if (this._doorbell.users.length == 0)
            {
                this.hide();
                return;
            }
            if (this._frame == null)
            {
                this.createMainWindow();
            }
            this._frame.visible = true;
            if (this._list != null)
            {
                this._list.destroyListItems();
                k = 0;
                while (k < this._doorbell.users.length)
                {
                    this._list.addListItem(this._Str_6850(ASCompat.asString(this._doorbell.users[k] ), k));
                    k++;
                }
            }
        }

        public var mainWindow(get,never):IWindow;
public function  get_mainWindow():IWindow
        {
            return this._frame;
        }

        function _Str_6850(k:String, _arg_2:Int):IWindow
        {
            var _local_6:IWindow = null;
            var _local_3= Std.downcast(this._doorbell.assets.getAssetByName("doorbell_list_entry") , XmlAsset);
            var _local_4= Std.downcast(this._doorbell.windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (_local_4 == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            var _local_5= Std.downcast(_local_4.findChildByName("user_name") , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.caption = k;
            }
            _local_4.name = k;
            if ((_arg_2 % 2) == 0)
            {
                _local_4.color = 0xFFFFFFFF;
            }
            _local_6 = _local_4.findChildByName("accept");
            if (_local_6 != null)
            {
                _local_6.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            _local_6 = _local_4.findChildByName("deny");
            if (_local_6 != null)
            {
                _local_6.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            return _local_4;
        }

        function hide()
        {
            if (this._frame != null)
            {
                this._frame.dispose();
                this._frame = null;
            }
        }

        function createMainWindow()
        {
            if (this._frame != null)
            {
                return;
            }
            var k= Std.downcast(this._doorbell.assets.getAssetByName("doorbell") , XmlAsset);
            this._frame = Std.downcast(this._doorbell.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._frame == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._list = Std.downcast(this._frame.findChildByName("user_list") , IItemListWindow);
            this._frame.visible = false;
            var _local_2= this._frame.findChildByTag("close");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._doorbell.denyAll();
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_2= k.window.parent.name;
            switch (k.window.name)
            {
                case "accept":
                    this._doorbell.accept(_local_2);
                    return;
                case "deny":
                    this._doorbell.deny(_local_2);
                    return;
            }
        }
    }


