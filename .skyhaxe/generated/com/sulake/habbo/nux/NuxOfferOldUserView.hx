package com.sulake.habbo.nux
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

     class NuxOfferOldUserView 
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
            var k= Std.downcast(this._component.assets.getAssetByName("nux_offer_old_user_xml") , XmlAsset);
            this._frame = Std.downcast(this._component.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._frame == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._frame.center();
            var _local_2= this._frame.findChildByTag("close");
            if (_local_2 != null)
            {
                _local_2.visible = false;
            }
            _local_2 = this._frame.findChildByName("btnSkip");
            _local_2.addEventListener(WindowMouseEvent.CLICK, this.onReject);
            _local_2 = this._frame.findChildByName("btnGo");
            _local_2.addEventListener(WindowMouseEvent.CLICK, this.onVerify);
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this.hide();
        }

        function onVerify(k:WindowMouseEvent)
        {
            this._component.onVerify();
            this.hide();
        }

        function onReject(k:WindowMouseEvent)
        {
            this._component.onReject();
        }
    }

