package com.sulake.habbo.avatar.effects
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.utils.Timer;
    import com.sulake.habbo.avatar.IHabboAvatarEditorAvatarEffect;
    import flash.events.TimerEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.ITextWindow;

     class EffectsParamView implements IDisposable 
    {
        var _model:EffectsModel;
        var _container:IWindowContainer;
        var _catalogPageName:String;
        var _windowManager:IHabboWindowManager;
        var _secondsCounterTimer:Timer;
        var _storedSeconds:Int = 0;
        var _storedEffect:IHabboAvatarEditorAvatarEffect = null;

        public function new(k:EffectsModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            this._model = k;
            this._windowManager = _arg_2;
            this._container = k.controller.view.effectsParamViewContainer;
            this._catalogPageName = k.controller.manager.getProperty("avatareditor.effects.buy.button.catalog.page.name");
            this._secondsCounterTimer = new Timer(1000);
            this._secondsCounterTimer.addEventListener(TimerEvent.TIMER, (this._Str_19275 : ASAny));
            this._container.findChildByName("get_more_button").addEventListener(WindowMouseEvent.CLICK, this.onBuyButtonClick);
            this.updateView(null);
        }

        public function dispose()
        {
            if (this._secondsCounterTimer != null)
            {
                this._secondsCounterTimer.stop();
                this._secondsCounterTimer.removeEventListener(TimerEvent.TIMER, (this._Str_19275 : ASAny));
                this._secondsCounterTimer = null;
            }
            this._windowManager = null;
            this._model = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._model == null;
        }

        public function updateView(k:IHabboAvatarEditorAvatarEffect)
        {
            this._storedEffect = k;
            this._container.visible = true;
            if (k == null)
            {
                this._container.findChildByName("time_left_bg").visible = false;
                this._container.findChildByName("save_to_activate").visible = false;
                this._container.findChildByName("effect_name").visible = false;
            }
            else
            {
                this._container.findChildByName("effect_name").visible = true;
                if (((!k.isActive) && (!k.isPermanent)))
                {
                    this._container.findChildByName("time_left_bg").visible = false;
                    this._container.findChildByName("save_to_activate").visible = true;
                    this._secondsCounterTimer.stop();
                }
                else
                {
                    this._storedSeconds = k.secondsRemaining;
                    this._Str_10660(k.secondsRemaining, k.duration, k.isPermanent);
                    this._container.findChildByName("time_left_bg").visible = true;
                    this._container.findChildByName("save_to_activate").visible = false;
                    this._secondsCounterTimer.start();
                }
                this._container.findChildByName("effect_name").caption = ((("$" + "{fx_") + Std.string(k.type)) + "}");
            }
        }

        function _Str_10660(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            var _local_10:String = null;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16:String = null;
            var _local_17:String = null;
            var _local_18:String = null;
            var _local_4= Std.downcast(this._container.findChildByName("time_left_bg") , IWindowContainer);
            var _local_5= cast(_local_4.findChildByName("progress_bar_bitmap"), IBitmapWrapperWindow);
            var _local_6= new BitmapData(_local_5.width, _local_5.height, false, 0);
            var _local_7= (_arg_3 ? _arg_2 : k);
            var _local_8= new Rectangle(0, 0, Std.int((_local_6.width * (_local_7 / _arg_2))), _local_6.height);
            _local_6.fillRect(_local_8, 2146080);
            _local_5.bitmap = _local_6;
            var _local_9= cast(_local_4.findChildByName("effect_time_left"), ITextWindow);
            if (_arg_3)
            {
                _local_9.caption = "${avatareditor.effects.active.permanent}";
                _local_10 = _local_9.text;
            }
            else
            {
                if (k > ((60 * 60) * 24))
                {
                    _local_9.caption = "${avatareditor.effects.active.daysleft}";
                    _local_10 = _local_9.text;
                    _local_11 = Std.int(Math.ffloor((k / ((60 * 60) * 24))));
                    _local_10 = ASCompat.stringReplace(_local_10, "%days_left%", _local_11);
                }
                else
                {
                    _local_9.caption = "${avatareditor.effects.active.timeleft}";
                    _local_10 = _local_9.text;
                    _local_12 = k;
                    _local_13 = Std.int(Math.ffloor((_local_12 / (60 * 60))));
                    _local_14 = Std.int(Math.ffloor((_local_12 / 60)) % 60);
                    _local_15 = (_local_12 % 60);
                    _local_16 = ((_local_13 < 10) ? "0" : "");
                    _local_17 = ((_local_14 < 10) ? "0" : "");
                    _local_18 = ((_local_15 < 10) ? "0" : "");
                    if (_local_13 > 0)
                    {
                        _local_10 = ASCompat.stringReplace(_local_10, "%time_left%", (((((((_local_16 + Std.string(_local_13)) + ":") + _local_17) + Std.string(_local_14)) + ":") + _local_18) + Std.string(_local_15)));
                    }
                    else
                    {
                        _local_10 = ASCompat.stringReplace(_local_10, "%time_left%", ((((_local_17 + Std.string(_local_14)) + ":") + _local_18) + Std.string(_local_15)));
                    }
                }
            }
            _local_9.text = _local_10;
        }

        function onBuyButtonClick(k:WindowMouseEvent)
        {
            this._model.controller.manager.catalog.openCatalogPage(this._catalogPageName);
        }

        function _Str_19275(k:TimerEvent)
        {
            if (((!(this._storedEffect == null)) && this._storedEffect.isActive))
            {
                this._Str_10660(this._storedSeconds--, this._storedEffect.duration, this._storedEffect.isPermanent);
            }
        }
    }

