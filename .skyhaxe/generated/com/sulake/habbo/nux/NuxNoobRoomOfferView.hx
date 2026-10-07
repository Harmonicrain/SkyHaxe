package com.sulake.habbo.nux
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

     class NuxNoobRoomOfferView 
    {
        var _frame:IFrameWindow;
        var _component:HabboNuxDialogs;

        public function new(k:HabboNuxDialogs)
        {
            this._component = k;
            this.show();
        }

        public function dispose()
        {
            if (this._frame != null)
            {
                this._frame.dispose();
                this._frame = null;
            }
            this._component = null;
        }

        function hide()
        {
            if (this._component != null)
            {
                this._component.destroyNuxOfferView();
            }
        }

        function show()
        {
            if (this._frame != null)
            {
                return;
            }
            var k= Std.downcast(this._component.assets.getAssetByName("nux_noob_room_offer_xml") , XmlAsset);
            this._frame = Std.downcast(this._component.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._frame == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._frame.x = (this._frame.y = 20);
            var _local_2= this._frame.findChildByName("btnGo");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_23291);
            }
            var _local_3= this._frame.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
        }

        function _Str_23291(k:WindowMouseEvent)
        {
            this._component.context.createLinkEvent("navigator/goto/predefined_noob_lobby");
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._component.destroyNoobRoomOfferView();
        }
    }


