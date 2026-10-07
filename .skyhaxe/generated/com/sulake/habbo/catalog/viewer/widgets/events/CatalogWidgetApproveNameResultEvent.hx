package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetApproveNameResultEvent extends Event 
    {
        var _result:Int = 0;
        var _nameValidationInfo:String;

        public function new(k:Int, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(CatalogWidgetEvent.APPROVE_RESULT, _arg_3, _arg_4);
            this._result = k;
            this._nameValidationInfo = _arg_2;
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }

        public var nameValidationInfo(get,never):String;
public function  get_nameValidationInfo():String
        {
            return this._nameValidationInfo;
        }
    }

