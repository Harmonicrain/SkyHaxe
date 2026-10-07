package com.sulake.habbo.session.events
;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetFigureData;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetPackageEvent extends RoomSessionEvent 
    {
        public static inline final RSOPPE_OPEN_PET_PACKAGE_REQUESTED= "RSOPPE_OPEN_PET_PACKAGE_REQUESTED";
        public static inline final RSOPPE_OPEN_PET_PACKAGE_RESULT= "RSOPPE_OPEN_PET_PACKAGE_RESULT";

        var _objectId:Int = -1;
        var _figureData:PetFigureData;
        var _nameValidationStatus:Int = 0;
        var _nameValidationInfo:String = null;

        public function new(k:String, _arg_2:IRoomSession, _arg_3:Int, _arg_4:PetFigureData, _arg_5:Int, _arg_6:String, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_2, _arg_7, _arg_8);
            this._objectId = _arg_3;
            this._figureData = _arg_4;
            this._nameValidationStatus = _arg_5;
            this._nameValidationInfo = _arg_6;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var figureData(get,never):PetFigureData;
public function  get_figureData():PetFigureData
        {
            return this._figureData;
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
    }

