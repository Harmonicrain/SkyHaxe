package com.sulake.habbo.ui.widget.furniture.dimmer
;
	import com.sulake.habbo.ui.widget.furniture.dimmer.DimmerView;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events.RoomWidgetDimmerUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_5572;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.events._Str_6094;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDimmerPreviewMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDimmerSavePresetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDimmerChangeStateMessage;

     class DimmerFurniWidget extends RoomWidgetBase
    {
        static final _Str_17357:Array<ASAny> = [7665141, 21495, 15161822, 15353138, 15923281, 8581961, 0];
        static final _Str_18775:Array<ASAny> = [Std.int((0.3 * 0xFF)), Std.int((0.3 * 0xFF))];

        var _view:DimmerView;
        var _presets:Array<ASAny>;
        var _selectedPresetIndex:Int = 0;
        var _dimmerState:Int = 0;
        var _effectId:Int = 0;
        var _color:UInt = 0xFFFFFF;
        var _brightness:UInt = 0xFF;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        public var _Str_22519(get,never):Int;
public function  get__Str_22519():Int
        {
            return this._dimmerState;
        }

        public var _Str_8447(get,never):Array<ASAny>;
public function  get__Str_8447():Array<ASAny>
        {
            return this._presets;
        }

        public var colors(get,never):Array<ASAny>;
public function  get_colors():Array<ASAny>
        {
            return _Str_17357;
        }

        public var _Str_23750(get,never):Array<ASAny>;
public function  get__Str_23750():Array<ASAny>
        {
            return _Str_18775;
        }

        
        public var _Str_13894(get,set):Int;
public function  get__Str_13894():Int
        {
            return this._selectedPresetIndex;
        }
public function  set__Str_13894(k:Int):Int        {
            return this._selectedPresetIndex = k;
        }

        override public function dispose()
        {
            this._Str_7493();
            this._presets = null;
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetDimmerUpdateEvent.RWDUE_PRESETS, this._Str_20153);
            k.addEventListener(RoomWidgetDimmerUpdateEvent.RWDUE_HIDE, this._Str_21426);
            k.addEventListener(_Str_5572.RWDSUE_DIMMER_STATE, this._Str_20342);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetDimmerUpdateEvent.RWDUE_PRESETS, this._Str_20153);
            k.removeEventListener(RoomWidgetDimmerUpdateEvent.RWDUE_HIDE, this._Str_21426);
            k.removeEventListener(_Str_5572.RWDSUE_DIMMER_STATE, this._Str_20342);
        }

        function _Str_20153(k:RoomWidgetDimmerUpdateEvent)
        {
            var _local_3:_Str_6094 = null;
            var _local_4:DimmerFurniWidgetPresetItem = null;
            this._selectedPresetIndex = (k._Str_6226 - 1);
            this._presets = new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < k._Str_8447.length)
            {
                _local_3 = k._Str_8447[_local_2];
                _local_4 = new DimmerFurniWidgetPresetItem(_local_3.id, _local_3.type, _local_3.color, _local_3.brightness);
                this._presets.push(_local_4);
                _local_2++;
            }
            this.showInterface();
        }

        function _Str_21426(k:RoomWidgetDimmerUpdateEvent)
        {
            this._Str_7493();
        }

        function _Str_7493()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        function _Str_20342(k:_Str_5572)
        {
            var _local_2:RoomWidgetDimmerPreviewMessage = null;
            if (k == null)
            {
                return;
            }
            this._dimmerState = k.state;
            this._effectId = k.effectId;
            this._color = k.color;
            this._brightness = k.brightness;
            if (this._view != null)
            {
                this._view.update();
            }
            if (!this._Str_12911(this._brightness, this._effectId))
            {
                return;
            }
            _local_2 = new RoomWidgetDimmerPreviewMessage(this._color, ASCompat.toInt(this._brightness), (this._effectId == 2));
            messageListener.processWidgetMessage(_local_2);
        }

        function showInterface()
        {
            if (this._view == null)
            {
                this._view = new DimmerView(this);
            }
            if (this._view != null)
            {
                this._view.showInterface();
            }
        }

        public function _Str_19799(k:Bool)
        {
            var _local_7:RoomWidgetDimmerSavePresetMessage = null;
            if (this._dimmerState == 0)
            {
                return;
            }
            if (messageListener == null)
            {
                return;
            }
            var _local_2= (this._selectedPresetIndex + 1);
            if ((((this._presets == null) || (_local_2 < 0)) || (_local_2 > this._presets.length)))
            {
                return;
            }
            var _local_3= this._view._Str_7660;
            var _local_4= ASCompat.toUInt(this.colors[this._view._Str_4246]);
            var _local_5= this._view._Str_7404;
            var _local_6= ASCompat.dynamicAs(this._presets[this._selectedPresetIndex] , DimmerFurniWidgetPresetItem);
            if ((((((!(_local_6 == null)) && (_local_6.type == _local_3)) && (_local_6.color == _local_4)) && (_local_6.brightness == (_local_5 : UInt))) && (!k)))
            {
                return;
            }
            _local_6.type = _local_3;
            _local_6.color = _local_4;
            _local_6.brightness = _local_5;
            if (!this._Str_12911(_local_5, _local_3))
            {
                return;
            }
            _local_7 = new RoomWidgetDimmerSavePresetMessage(_local_2, _local_3, _local_4, _local_5, k);
            messageListener.processWidgetMessage(_local_7);
        }

        public function _Str_12547()
        {
            var k:RoomWidgetDimmerPreviewMessage = null;
            if (this._dimmerState == 0)
            {
                return;
            }
            if (messageListener == null)
            {
                return;
            }
            if (!this._Str_12911(this._view._Str_7404, this._view._Str_7660))
            {
                return;
            }
            k = new RoomWidgetDimmerPreviewMessage(ASCompat.toUInt(this.colors[this._view._Str_4246]), this._view._Str_7404, (this._view._Str_7660 == 2));
            messageListener.processWidgetMessage(k);
        }

        public function _Str_22483()
        {
            var k:RoomWidgetDimmerChangeStateMessage = null;
            if (messageListener != null)
            {
                k = new RoomWidgetDimmerChangeStateMessage();
                messageListener.processWidgetMessage(k);
            }
        }

        public function _Str_23566()
        {
            var k:RoomWidgetDimmerPreviewMessage = null;
            if (messageListener == null)
            {
                return;
            }
            if (!this._Str_12911(this._brightness, this._effectId))
            {
                return;
            }
            k = new RoomWidgetDimmerPreviewMessage(this._color, ASCompat.toInt(this._brightness), (this._effectId == 2));
            messageListener.processWidgetMessage(k);
        }

        function _Str_12911(k:UInt, _arg_2:Int):Bool
        {
            return true;
        }
    }

