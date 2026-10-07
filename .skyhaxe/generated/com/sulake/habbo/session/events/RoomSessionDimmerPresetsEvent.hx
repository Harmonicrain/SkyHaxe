package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionDimmerPresetsEvent extends RoomSessionEvent 
    {
        public static inline final RSDPE_PRESETS= "RSDPE_PRESETS";

        var _selectedPresetId:Int = 0;
        var _presets:Array<ASAny>;

        public function new(k:String, _arg_2:IRoomSession, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            this._presets = new Array<ASAny>();
            super(k, _arg_2, _arg_3, _arg_4);
        }

        
        public var _Str_6226(get,set):Int;
public function  get__Str_6226():Int
        {
            return this._selectedPresetId;
        }

        public var _Str_10888(get,never):Int;
public function  get__Str_10888():Int
        {
            return this._presets.length;
        }
public function  set__Str_6226(k:Int):Int        {
            return this._selectedPresetId = k;
        }

        public function storePreset(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            var _local_5= new RoomSessionDimmerPresetsEventPresetItem(k, _arg_2, _arg_3, _arg_4);
            this._presets[(k - 1)] = _local_5;
        }

        public function getPreset(k:Int):RoomSessionDimmerPresetsEventPresetItem
        {
            if (((k < 0) || (k >= (this._presets : ASAny).count)))
            {
                return null;
            }
            return this._presets[k];
        }
    }

