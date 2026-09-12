package com.sulake.habbo.friendbar.talent
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.parser.talent.TalentTrack;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.utils._Str_988;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;

     class TalentProgressMeter implements IDisposable 
    {
        static inline final _Str_22459= "talent_achieved_div";
        static inline final _Str_25810= "talent_unachieved_div";
        static inline final _Str_21230= "progress_divider_level_";
        static inline final _Str_12761= 10;

        var _disposed:Bool = false;
        var _habboTalent:HabboTalent;
        var _controller:TalentTrackController;
        var _talentTrack:TalentTrack;
        var _progressContainer:IWindowContainer;
        var _divider:IStaticBitmapWrapperWindow;
        var _progressNeedle:IWidgetWindow;
        var _achievedMid:IStaticBitmapWrapperWindow;
        var _unachievedMid:IStaticBitmapWrapperWindow;

        public function new(k:HabboTalent, _arg_2:TalentTrackController)
        {
            this._habboTalent = k;
            this._controller = _arg_2;
            this._talentTrack = this._controller.talentTrack;
            this._Str_24296();
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._controller.window.width;
        }

        public var _Str_19867(get,never):Int;
public function  get__Str_19867():Int
        {
            return Std.int(Math.ffloor(_Str_988._Str_1028(this._talentTrack.progressPerLevel, 0, this.width)));
        }

        function _Str_24296()
        {
            var _local_2:IStaticBitmapWrapperWindow = null;
            this._progressContainer = cast(this._controller.window.findChildByName("progress_container"), IWindowContainer);
            this._divider = cast(this._progressContainer.removeChild(this._progressContainer.findChildByName("progress_level_divider")), IStaticBitmapWrapperWindow);
            this._achievedMid = cast(this._progressContainer.findChildByName("achieved_mid"), IStaticBitmapWrapperWindow);
            this._unachievedMid = cast(this._progressContainer.findChildByName("unachieved_mid"), IStaticBitmapWrapperWindow);
            var k= 1;
            while (k < this._talentTrack.levels.length)
            {
                _local_2 = cast(this._divider.clone(), IStaticBitmapWrapperWindow);
                _local_2.name = (TalentProgressMeter._Str_21230 + Std.string(k));
                this._progressContainer.addChild(_local_2);
                k++;
            }
            this._progressNeedle = cast(this._progressContainer.findChildByName("progress_needle"), IWidgetWindow);
            cast(this._progressNeedle.widget, IAvatarImageWidget).figure = this._habboTalent._Str_20410.figure;
            this._progressContainer.setChildIndex(this._progressNeedle, (this._progressContainer.numChildren - 1));
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._divider != null)
                {
                    this._divider.dispose();
                    this._divider = null;
                }
                this._achievedMid = null;
                this._unachievedMid = null;
                this._progressNeedle = null;
                this._progressContainer = null;
                this._talentTrack = null;
                this._controller = null;
                this._habboTalent = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function resize()
        {
            var _local_5:IStaticBitmapWrapperWindow = null;
            var k= Std.int(Math.ffloor(_Str_988._Str_1028(this._talentTrack._Str_18600, 0, this.width)));
            this._progressContainer.width = this.width;
            this._unachievedMid.width = this.width;
            this._achievedMid.width = k;
            this._progressNeedle.x = Std.int(_Str_988._Str_2040((k - Std.int((this._progressNeedle.width / 2))), 0, (this.width - this._progressNeedle.width)));
            var _local_2= this._progressContainer.findChildByName("avatar_glow");
            _local_2.x = (this._progressNeedle.x - TalentProgressMeter._Str_12761);
            _local_2.y = (this._progressNeedle.y - TalentProgressMeter._Str_12761);
            _local_2.width = (this._progressNeedle.width + (2 * TalentProgressMeter._Str_12761));
            _local_2.height = (this._progressNeedle.height + (2 * TalentProgressMeter._Str_12761));
            var _local_3= this._progressContainer.findChildByName("progress_balloon");
            _local_3.x = Std.int(((this._progressNeedle.x + Math.ffloor((this._progressNeedle.width / 2))) - Math.ffloor((_local_3.width / 2))) + 5);
            var _local_4= 1;
            while (_local_4 < this._talentTrack.levels.length)
            {
                _local_5 = cast(this._progressContainer.findChildByName((TalentProgressMeter._Str_21230 + Std.string(_local_4))), IStaticBitmapWrapperWindow);
                _local_5.x = (_local_4 * this._Str_19867);
                if (_local_5.x < k)
                {
                    _local_5.assetUri = TalentProgressMeter._Str_22459;
                }
                else
                {
                    _local_5.assetUri = TalentProgressMeter._Str_25810;
                }
                _local_5.visible = true;
                _local_4++;
            }
            this._progressContainer.invalidate();
        }
    }

