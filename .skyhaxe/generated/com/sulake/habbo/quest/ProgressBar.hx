package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import flash.geom.Point;

     class ProgressBar implements IDisposable 
    {
        static inline final _Str_17552= 3;
        static inline final _Str_16871= 10;

        var _questEngine:HabboQuestEngine;
        var _window:IWindowContainer;
        var _progressBarWidth:Int = 0;
        var _progressKey:String;
        var _hasFrame:Bool = false;
        var _currentAmount:Int = 0;
        var _maxAmount:Int = 0;
        var _scoreAtStartOfLevel:Int = 0;
        var _parentId:Int = 0;
        var _startProgressWidth:Int = 0;
        var _currentProgressWidth:Int = 0;
        var _update:Bool = false;

        public function new(k:HabboQuestEngine, _arg_2:IWindowContainer, _arg_3:Int, _arg_4:String, _arg_5:Bool, _arg_6:Point)
        {
            this._questEngine = k;
            this._window = _arg_2;
            this._progressBarWidth = _arg_3;
            this._progressKey = _arg_4;
            this._hasFrame = _arg_5;
            var _local_7= cast(this._window.findChildByName("progress_bar_cont"), IWindowContainer);
            if (_local_7 == null)
            {
                _local_7 = cast(this._questEngine.getXmlWindow("ProgressBar"), IWindowContainer);
                this._window.addChild(_local_7);
                _local_7.x = Std.int(_arg_6.x);
                _local_7.y = Std.int(_arg_6.y);
                _local_7.width = (this._progressBarWidth + _Str_16871);
            }
        }

        public function refresh(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            var _local_5= ((!(_arg_3 == this._parentId)) || (!(_arg_2 == this._maxAmount)));
            this._maxAmount = _arg_2;
            this._currentAmount = k;
            this._startProgressWidth = this._currentProgressWidth;
            this._parentId = _arg_3;
            this._scoreAtStartOfLevel = _arg_4;
            if ((_local_5 || ((this._currentAmount == 0) && (this._currentProgressWidth > 0))))
            {
                this._currentProgressWidth = this._Str_19753(this._currentAmount);
            }
            this._update = true;
            this.updateView();
        }

        public var visible(never,set):Bool;
public function  set_visible(k:Bool):Bool        {
            var _local_2= cast(this._window.findChildByName("progress_bar_cont"), IWindowContainer);
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
return k;
        }

        public function updateView()
        {
            var _local_11 = 0;
            if (!this._update)
            {
                return;
            }
            var k= this._window.findChildByName("bar_a_bkg");
            var _local_2= this._window.findChildByName("bar_a_c");
            var _local_3= this._window.findChildByName("bar_a_r");
            var _local_4= this._window.findChildByName("bar_l");
            var _local_5= this._window.findChildByName("bar_c");
            var _local_6= this._window.findChildByName("bar_r");
            _local_4.visible = this._hasFrame;
            _local_5.visible = this._hasFrame;
            _local_6.visible = this._hasFrame;
            if (this._hasFrame)
            {
                _local_5.width = this._progressBarWidth;
                _local_6.x = (this._progressBarWidth + _local_2.x);
            }
            var _local_7= this._Str_19753(this._currentAmount);
            if (this._currentProgressWidth < _local_7)
            {
                _local_11 = Std.int(Math.min(Math.abs((this._currentProgressWidth - _local_7)), Math.abs((this._startProgressWidth - _local_7))));
                this._currentProgressWidth = Std.int(Math.min(_local_7, (this._currentProgressWidth + Math.max(1, Math.fround(Math.sqrt(_local_11))))));
            }
            var _local_8:ASAny = (this._currentProgressWidth > 0);
            k.visible = _local_8;
            _local_2.visible = _local_8;
            _local_3.visible = _local_8;
            if (_local_8)
            {
                _local_2.blend = (1 - ((_local_7 - this._currentProgressWidth) / (_local_7 - this._startProgressWidth)));
                _local_2.width = this._currentProgressWidth;
                _local_3.x = (this._currentProgressWidth + _local_2.x);
                k.width = (_local_3.right - _local_2.left);
            }
            this._update = (this._currentProgressWidth < _local_7);
            var _local_9= this._window.findChildByName("progress_txt");
            var _local_10= Std.int(this._update ? Std.int(Math.fround(((this._currentProgressWidth / this._progressBarWidth) * this._maxAmount)) ): this._currentAmount);
            this._questEngine.localization.registerParameter(this._progressKey, "progress", ("" + Std.string(_local_10 + this._scoreAtStartOfLevel)));
            this._questEngine.localization.registerParameter(this._progressKey, "limit", ("" + Std.string(this._maxAmount + this._scoreAtStartOfLevel)));
            _local_9.caption = this._questEngine.localization.getLocalization(this._progressKey, this._progressKey);
            _local_9.x = Std.int((_Str_17552 + _local_2.x) + ((this._progressBarWidth - _local_9.width) / 2));
        }

        public function dispose()
        {
            this._questEngine = null;
            this._window = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        function _Str_19753(k:Int):Int
        {
            return Std.int(Math.max(0, Math.fround(((this._progressBarWidth * k) / this._maxAmount))));
        }
    }

