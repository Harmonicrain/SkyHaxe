package com.sulake.habbo.ui.widget.crafting.controller
;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindowContainer;

     class CraftingProgressBarController 
    {
        var _widget:CraftingWidget;
        var _progressTimer:Timer;
        var _progress:Float = Math.NaN;

        public function new(k:CraftingWidget)
        {
            this._widget = k;
            this._progressTimer = new Timer(70);
            this._progressTimer.addEventListener(TimerEvent.TIMER, (this._Str_24900 : ASAny));
        }

        public function dispose()
        {
            this._widget = null;
        }

        function _Str_11199(k:Float)
        {
            var _local_4:IWindow = null;
            var _local_2= this.container.findChildByName("btn_cancel");
            var _local_3:IWindow = ((this.container != null) ? this.container.findChildByName("bar") : null);
            if (_local_3 != null)
            {
                _local_4 = _local_3.parent;
                _local_3.width = Std.int(_local_2.width * k);
            }
        }

        function _Str_24900(k:TimerEvent)
        {
            this._Str_11199((this._progress = (this._progress + 0.02)));
            if (this._progress >= 1)
            {
                this.hide();
                this._widget._Str_11931._Str_25541();
            }
        }

        public function hide()
        {
            if (this._progressTimer != null)
            {
                this._progressTimer.stop();
            }
            if (this.container != null)
            {
                this.container.visible = false;
                this.container.procedure = null;
            }
        }

        public function show()
        {
            this._progressTimer.start();
            this._progress = 0;
            if (this.container != null)
            {
                this.container.visible = true;
                this.container.procedure = this.onTriggered;
            }
        }

        function onTriggered(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.DOWN)
            {
                return;
            }
            this._widget._Str_11931._Str_19691();
        }

        var container(get,never):IWindowContainer;
function  get_container():IWindowContainer
        {
            if (((!(this._widget != null)) || (!(this._widget.window != null))))
            {
                return null;
            }
            return Std.downcast(this._widget.window.findChildByName("progress_bar") , IWindowContainer);
        }
    }

