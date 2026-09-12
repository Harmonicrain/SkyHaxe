package com.sulake.habbo.ui.widget.events
;
    import flash.display.BitmapData;

     class _Str_3085 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWOPPUE_OPEN_PET_PACKAGE_REQUESTED= "RWOPPUE_OPEN_PET_PACKAGE_REQUESTED";
        public static inline final RWOPPUE_OPEN_PET_PACKAGE_RESULT= "RWOPPUE_OPEN_PET_PACKAGE_RESULT";
        public static inline final RWOPPUE_OPEN_PET_PACKAGE_UPDATE_PET_IMAGE= "RWOPPUE_OPEN_PET_PACKAGE_UPDATE_PET_IMAGE";

        var _objectId:Int = -1;
        var _typeId:Int = -1;
        var _image:BitmapData = null;
        var _nameValidationStatus:Int = 0;
        var _nameValidationInfo:String = null;

        public function new(k:String, _arg_2:Int, _arg_3:BitmapData, _arg_4:Int, _arg_5:String, _arg_6:Int, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_7, _arg_8);
            this._objectId = _arg_2;
            this._image = _arg_3;
            this._nameValidationStatus = _arg_4;
            this._nameValidationInfo = _arg_5;
            this._typeId = _arg_6;
        }

        public var nameValidationStatus(get,never):Int;
public function  get_nameValidationStatus():Int
        {
            return this._nameValidationStatus;
        }

        public var nameValidationInfo(get,never):String;
public function  get_nameValidationInfo():String
        {
            return this._nameValidationInfo;
        }

        public var image(get,never):BitmapData;
public function  get_image():BitmapData
        {
            return this._image;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var typeId(get,never):Int;
public function  get_typeId():Int
        {
            return this._typeId;
        }
    }

