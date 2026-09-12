package com.sulake.habbo.help.guidehelp
;
    import com.sulake.habbo.help._enum.GuideSessionStateEnum;

     class GuideSessionData 
    {
        public static inline final _Str_19558:UInt = 0;
        public static inline final _Str_15093:UInt = 1;
        public static inline final _Str_11013:UInt = 2;
        public static inline final _Str_14462= 0;
        public static inline final _Str_19034= 1;
        public static inline final _Str_21656= 2;

        var _role:UInt = 0;
        var _activeWindow:String;
        var _requestType:UInt = 0;
        var _requestDescription:String = "";
        var _userId:UInt = 0;
        var _userName:String = "";
        var _userFigure:String = "";
        var _guideId:UInt = 0;
        var _guideName:String = "";
        var _guideFigure:String = "";

        public function new()
        {
            this._activeWindow = GuideSessionStateEnum._Str_17314;
        }

        public function _Str_15842():Bool
        {
            return this._Str_5935() || this._Str_5908();
        }

        public function _Str_5935():Bool
        {
            return (this._role == _Str_11013) && ((((this._activeWindow == GuideSessionStateEnum.USER_CREATE) || (this._activeWindow == GuideSessionStateEnum.USER_PENDING)) || (this._activeWindow == GuideSessionStateEnum.USER_ONGOING)) || (this._activeWindow == GuideSessionStateEnum.USER_FEEDBACK));
        }

        public function _Str_5908():Bool
        {
            return (this._role == _Str_15093) && (((this._activeWindow == GuideSessionStateEnum.GUIDE_ACCEPT) || (this._activeWindow == GuideSessionStateEnum.GUIDE_ONGOING)) || (this._activeWindow == GuideSessionStateEnum.GUIDE_CLOSED));
        }

        public function _Str_14646():Bool
        {
            return (this._activeWindow == GuideSessionStateEnum.GUIDE_ONGOING) || (this._activeWindow == GuideSessionStateEnum.USER_ONGOING);
        }

        public var _Str_17222(never,set):UInt;
public function  set__Str_17222(k:UInt):UInt        {
            return this._role = k;
        }

        
        public var _Str_3201(get,set):String;
public function  get__Str_3201():String
        {
            return this._activeWindow;
        }
public function  set__Str_3201(k:String):String        {
            return this._activeWindow = k;
        }

        
        public var requestType(get,set):UInt;
public function  get_requestType():UInt
        {
            return this._requestType;
        }
public function  set_requestType(k:UInt):UInt        {
            return this._requestType = k;
        }

        
        public var _Str_8937(get,set):String;
public function  get__Str_8937():String
        {
            return this._requestDescription;
        }
public function  set__Str_8937(k:String):String        {
            return this._requestDescription = k;
        }

        
        public var userId(get,set):UInt;
public function  get_userId():UInt
        {
            return this._userId;
        }
public function  set_userId(k:UInt):UInt        {
            return this._userId = k;
        }

        
        public var userName(get,set):String;
public function  get_userName():String
        {
            return this._userName;
        }
public function  set_userName(k:String):String        {
            return this._userName = k;
        }

        
        public var _Str_7586(get,set):String;
public function  get__Str_7586():String
        {
            return this._userFigure;
        }
public function  set__Str_7586(k:String):String        {
            return this._userFigure = k;
        }

        
        public var _Str_5587(get,set):UInt;
public function  get__Str_5587():UInt
        {
            return this._guideId;
        }
public function  set__Str_5587(k:UInt):UInt        {
            return this._guideId = k;
        }

        
        public var guideName(get,set):String;
public function  get_guideName():String
        {
            return this._guideName;
        }
public function  set_guideName(k:String):String        {
            return this._guideName = k;
        }

        
        public var guideFigure(get,set):String;
public function  get_guideFigure():String
        {
            return this._guideFigure;
        }
public function  set_guideFigure(k:String):String        {
            return this._guideFigure = k;
        }
    }

