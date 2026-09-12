package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetDimmerUpdateEvent extends RoomWidgetUpdateEvent 
    {
        public static inline final RWDUE_PRESETS= "RWDUE_PRESETS";
        public static inline final RWDUE_HIDE= "RWDUE_HIDE";

        var _selectedPresetId:Int = 0;
        var _presets:Array<ASAny>;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            this._presets = new Array<ASAny>();
            super(k, _arg_2, _arg_3);
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

        public var _Str_8447(get,never):Array<ASAny>;
public function  get__Str_8447():Array<ASAny>
        {
            return this._presets;
        }
public function  set__Str_6226(k:Int):Int        {
            return this._selectedPresetId = k;
        }

        public function storePreset(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            var _local_5= new _Str_6094(k, _arg_2, _arg_3, _arg_4);
            this._presets[(k - 1)] = _local_5;
        }

        public function getPreset(k:Int):_Str_6094
        {
            if (((k < 0) || (k >= (this._presets : ASAny).count)))
            {
                return null;
            }
            return this._presets[k];
        }
    }

