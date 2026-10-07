package com.sulake.habbo.ui.widget.effects
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.ui.handler.EffectsWidgetHandler;
    import com.sulake.core.assets.XmlAsset;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.memenu.IWidgetAvatarEffect;

     class EffectsWidget extends RoomWidgetBase
    {
        static inline final _Str_18779= 320;
        static inline final _Str_16932= 48;
        static inline final _Str_16128= 2;

        var _view:IWindowContainer;
        var _list:IScrollableListWindow;
        var _effectViews:Map;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
            this.handler.widget = this;
            this._effectViews = new Map();
        }

        public var handler(get,never):EffectsWidgetHandler;
public function  get_handler():EffectsWidgetHandler
        {
            return Std.downcast(_handler , EffectsWidgetHandler);
        }

        override public function dispose()
        {
            var k:_Str_4860 = null;
            if (disposed)
            {
                return;
            }
            if (this._effectViews != null)
            {
                final _iter_ = this._effectViews; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._effectViews.dispose();
                this._effectViews = null;
            }
            this._list = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            super.dispose();
        }

        public function open()
        {
            var k:XmlAsset = null;
            var _local_2:Rectangle = null;
            var _local_3:IWindow = null;
            if (this._view == null)
            {
                k = Std.downcast(assets.getAssetByName("effects_widget") , XmlAsset);
                this._view = Std.downcast(windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                _local_2 = this.handler.container.toolbar.getRect();
                this._view.x = Std.int(_local_2.right + _Str_16128);
                this._view.y = Std.int(_local_2.bottom - this._view.height);
                this._list = Std.downcast(this._view.findChildByName("list") , IScrollableListWindow);
                _local_3 = this._view.findChildByName("close");
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
            this.update();
            this._view.visible = true;
        }

        public function update()
        {
            var k:_Str_4860 = null;
            var _local_3:IWidgetAvatarEffect = null;
            var _local_4 = 0;
            var _local_2= this.handler.container.inventory.getAvatarEffects();
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                k = ASCompat.dynamicAs(this._effectViews.getValue(_local_3.type) , _Str_4860);
                if (k != null)
                {
                    k.update();
                }
                else
                {
                    k = new _Str_4860(this, _local_3);
                    this._effectViews.add(_local_3.type, k);
                    this._list.addListItem(k.window);
                }
            }
            _local_4 = ASCompat.toInt(this._effectViews.length - 1);
            while (_local_4 >= 0)
            {
                k = this._effectViews.getWithIndex(_local_4);
                if (_local_2.indexOf(k.effect) == -1)
                {
                    this._list.removeListItem(k.window);
                    this._effectViews.remove(this._effectViews.getKey(_local_4));
                    k.dispose();
                }
                _local_4--;
            }
            var _local_5= Std.int(this._list.scrollableRegion.height);
            this._list.height = Std.int(Math.max(Math.min(_local_5, _Str_18779), _Str_16932));
            this._view.findChildByName("no_effects").visible = (_local_2.length == 0);
        }

        public function _Str_25077(k:Int, _arg_2:Bool)
        {
            if (_arg_2)
            {
                this.handler.container.inventory.setEffectDeselected(k);
            }
            else
            {
                this.handler.container.inventory.setEffectSelected(k);
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._view.visible = false;
        }
    }

