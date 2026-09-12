package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RoomDimmerSavePresetMessageComposer implements IMessageComposer
    {
        var _presetNumber:Int = 0;
        var _effectTypeId:Int = 0;
        var _colorRgbHex:String;
        var _colorBrightness:Int = 0;
        var _setAsSelectedPreset:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Bool)
        {
            this._presetNumber = k;
            this._effectTypeId = _arg_2;
            this._colorRgbHex = _arg_3;
            this._colorBrightness = _arg_4;
            this._setAsSelectedPreset = _arg_5;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._presetNumber, this._effectTypeId, this._colorRgbHex, this._colorBrightness, this._setAsSelectedPreset];
        }

        public function dispose()
        {
        }
    }

