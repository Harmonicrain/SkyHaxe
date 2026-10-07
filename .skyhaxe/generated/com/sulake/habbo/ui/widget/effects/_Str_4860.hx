package com.sulake.habbo.ui.widget.effects
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.memenu.IWidgetAvatarEffect;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;

     class _Str_4860 
    {
        static inline final _Str_25685= 1000;

        var _widget:EffectsWidget;
        var _window:IWindowContainer;
        var _effect:IWidgetAvatarEffect;
        var _bar:IWindow;
        var _maxWidth:Float = Math.NaN;
        var _timeLeftField:ITextWindow;
        var _timer:Timer;
        var _hilite:IWindow;

        public function new(k:EffectsWidget, _arg_2:IWidgetAvatarEffect)
        {
            this._effect = _arg_2;
            this._widget = k;
            this._timer = new Timer(_Str_4860._Str_25685);
            this._timer.addEventListener(TimerEvent.TIMER, (this.onUpdate : ASAny));
            this.update();
        }

        public var effect(get,never):IWidgetAvatarEffect;
public function  get_effect():IWidgetAvatarEffect
        {
            return this._effect;
        }

        public function dispose()
        {
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, (this.onUpdate : ASAny));
                this._timer = null;
            }
            this._widget = null;
            this._effect = null;
            this._bar = null;
            this._timeLeftField = null;
            this._hilite = null;
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

        function onUpdate(k:Event=null)
        {
            var _local_2 = Math.NaN;
            if (this._bar == null)
            {
                this._timer.stop();
                return;
            }
            if (this._effect.isActive)
            {
                _local_2 = (this._effect.secondsRemaining / this._effect.duration);
                this._bar.width = Std.int(_local_2 * this._maxWidth);
            }
            else
            {
                this._bar.width = 0;
                this._timer.stop();
            }
            this.setTimeLeft();
        }

        function setTimeLeft()
        {
            var k:String = null;
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9:String = null;
            if (this._timeLeftField == null)
            {
                this._timeLeftField = Std.downcast(this._window.findChildByName("time_left") , ITextWindow);
                if (this._timeLeftField == null)
                {
                    return;
                }
            }
            if (!this._effect.isActive)
            {
                this._timeLeftField.caption = "${widgets.memenu.effects.activate}";
                return;
            }
            if (this._effect.secondsRemaining > ((60 * 60) * 24))
            {
                this._timeLeftField.caption = "${widgets.memenu.effects.active.daysleft}";
                k = this._timeLeftField.text;
                _local_2 = Std.int(Math.ffloor((this._effect.secondsRemaining / ((60 * 60) * 24))));
                k = ASCompat.stringReplace(k, "%days_left%", _local_2);
            }
            else
            {
                this._timeLeftField.caption = "${widgets.memenu.effects.active.timeleft}";
                k = this._timeLeftField.text;
                _local_3 = this._effect.secondsRemaining;
                _local_4 = Std.int(Math.ffloor((_local_3 / (60 * 60))));
                _local_5 = Std.int(Math.ffloor((_local_3 / 60)) % 60);
                _local_6 = (_local_3 % 60);
                _local_7 = ((_local_4 < 10) ? "0" : "");
                _local_8 = ((_local_5 < 10) ? "0" : "");
                _local_9 = ((_local_6 < 10) ? "0" : "");
                if (_local_4 > 0)
                {
                    k = ASCompat.stringReplace(k, "%time_left%", (((((((_local_7 + Std.string(_local_4)) + ":") + _local_8) + Std.string(_local_5)) + ":") + _local_9) + Std.string(_local_6)));
                }
                else
                {
                    k = ASCompat.stringReplace(k, "%time_left%", ((((_local_8 + Std.string(_local_5)) + ":") + _local_9) + Std.string(_local_6)));
                }
            }
            this._timeLeftField.text = k;
        }

        public function update()
        {
            var k:XmlAsset = null;
            var _local_7:IWindow = null;
            var _local_8:IButtonWindow = null;
            if (this._window == null)
            {
                this._window = Std.downcast(this._widget.windowManager.createWindow("", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT) , IWindowContainer);
            }
            while (this._window.numChildren > 0)
            {
                _local_7 = this._window.removeChildAt(0);
                _local_7.dispose();
            }
            this._bar = null;
            this._hilite = null;
            this._timeLeftField = null;
            var _local_2= "";
            if (this._effect.isInUse)
            {
                _local_2 = "memenu_effect_selected";
            }
            else
            {
                if (this._effect.isActive)
                {
                    _local_2 = "memenu_effect_unselected";
                }
                else
                {
                    _local_2 = "memenu_effect_inactive";
                }
            }
            k = Std.downcast(this._widget.assets.getAssetByName(_local_2) , XmlAsset);
            var _local_3= Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.addChild(_local_3);
            var _local_4= Std.downcast(this._window.findChildByName("effect_name") , ITextWindow);
            if (_local_4 != null)
            {
                _local_4.caption = ((("$" + "{fx_") + Std.string(this._effect.type)) + "}");
            }
            var _local_5= Std.downcast(this._window.findChildByName("effect_amount") , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.caption = (Std.string(this._effect.amount) + "");
            }
            var _local_6= Std.downcast(this._window.findChildByName("effect_amount_bg1") , IWindowContainer);
            if (this._effect.amount < 2)
            {
                if (_local_6 != null)
                {
                    _local_6.visible = false;
                }
            }
            if (_local_2 == "memenu_effect_inactive")
            {
                _local_8 = Std.downcast(this._window.findChildByName("activate_effect") , IButtonWindow);
                if (_local_8 != null)
                {
                    _local_8.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
                }
            }
            else
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
                if (this._effect.isActive)
                {
                    _local_3.addEventListener(WindowMouseEvent.OVER, this.onMouseEvent);
                    _local_3.addEventListener(WindowMouseEvent.OUT, this.onMouseEvent);
                }
                if (this._effect.isInUse)
                {
                    this.setElementImage("effect_hilite", "memenu_fx_pause");
                }
                else
                {
                    this.setElementImage("effect_hilite", "memenu_fx_play");
                }
                this._hilite = this._window.findChildByName("effect_hilite");
                this._hilite.visible = false;
            }
            this.setTimeLeft();
            this._bar = this._window.findChildByName("loader_bar");
            if (this._bar != null)
            {
                this._maxWidth = this._bar.width;
                this._timer.start();
                this.onUpdate();
            }
            if (this._effect.icon != null)
            {
                this.setElementBitmap("effect_icon", this._effect.icon);
            }
            this._window.rectangle = _local_3.rectangle;
        }

        function setElementBitmap(k:String, _arg_2:BitmapData)
        {
            var _local_3= Std.downcast(this._window.findChildByName(k) , IBitmapWrapperWindow);
            if (_local_3 != null)
            {
                if (_local_3.bitmap != null)
                {
                    _local_3.bitmap.dispose();
                }
                _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0);
                _local_3.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(0, 0));
            }
            else
            {
                Logger.log([("Could not find element: " + k)]);
            }
        }

        function onMouseEvent(k:WindowMouseEvent)
        {
            switch (k.type)
            {
                case WindowMouseEvent.OVER:
                    if (this._hilite != null)
                    {
                        this._hilite.visible = true;
                    }
                    return;
                case WindowMouseEvent.OUT:
                    if (this._hilite != null)
                    {
                        this._hilite.visible = false;
                    }
                    return;
                case WindowMouseEvent.CLICK:
                    this._widget._Str_25077(this._effect.type, this._effect.isInUse);
                    return;
            }
        }

        function setElementImage(k:String, _arg_2:String)
        {
            var _local_3= Std.downcast(this._widget.assets.getAssetByName(_arg_2) , BitmapDataAsset);
            var _local_4= ASCompat.dynamicAs(_local_3.content , BitmapData);
            this.setElementBitmap(k, _local_4);
        }
    }

