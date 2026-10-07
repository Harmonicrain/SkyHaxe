package com.sulake.habbo.ui.widget.events
;
     class _Str_4899 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWCFUE_CREDIT_FURNI_UPDATE= "RWCFUE_CREDIT_FURNI_UPDATE";

        var _objectId:Int = 0;
        var _Str_12356:Float = Math.NaN;
		var _furniType:String;
        public function new(k:String, furniType:String, _arg_2:Int, _arg_3:Float, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._Str_12356 = _arg_3;
            this._objectId = _arg_2;
			this._furniType = furniType;
        }

        public var _Str_22599(get,never):Float;
public function  get__Str_22599():Float
        {
            return this._Str_12356;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

		public var furniType(get,never):String;
public function  get_furniType():String
		{
			return this._furniType;
		}    }

