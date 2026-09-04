package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.runtime.IDisposable;

     class IssueMessageData implements IDisposable
    {
        public static inline final _Str_5035= 1;
        public static inline final _Str_8056= 2;
        public static inline final _Str_17136= 3;

        var _issueId:Int = 0;
        var _state:Int = 0;
        var _categoryId:Int = 0;
        var _Str_21044:Int = 0;
        var _issueAgeInMilliseconds:Float = Math.NaN;
        var _priority:Int = 0;
        var _Str_9559:Int = 0;
        var _Str_21130:Int = 0;
        var _Str_19722:String;
        var _Str_2797:Int = 0;
        var _Str_5502:String;
        var _Str_9859:Int = 0;
        var _Str_21393:String;
        var _message:String;
        var _Str_10679:Int = 0;
        var _Str_15205:Array<ASAny>;
        var _disposed:Bool = false;
        var _Str_19084:Float = Math.NaN;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Float, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:String, _arg_10:Int, _arg_11:String, _arg_12:Int, _arg_13:String, _arg_14:String, _arg_15:Int, _arg_16:Array<ASAny>)
        {
            this._issueId = k;
            this._state = _arg_2;
            this._categoryId = _arg_3;
            this._Str_21044 = _arg_4;
            this._issueAgeInMilliseconds = _arg_5;
            this._priority = _arg_6;
            this._Str_9559 = _arg_7;
            this._Str_21130 = _arg_8;
            this._Str_19722 = _arg_9;
            this._Str_2797 = _arg_10;
            this._Str_5502 = _arg_11;
            this._Str_9859 = _arg_12;
            this._Str_21393 = _arg_13;
            this._message = _arg_14;
            this._Str_10679 = _arg_15;
            this._Str_15205 = _arg_16;
            this._Str_19084 = flash.Lib.getTimer();
        }

        public var _Str_2869(get,never):Int;
function  get__Str_2869():Int
        {
            return this._issueId;
        }

        public var state(get,never):Int;
function  get_state():Int
        {
            return this._state;
        }

        public var categoryId(get,never):Int;
function  get_categoryId():Int
        {
            return this._categoryId;
        }

        public var _Str_7437(get,never):Int;
function  get__Str_7437():Int
        {
            return this._Str_21044;
        }

        public var issueAgeInMilliseconds(get,never):Float;
function  get_issueAgeInMilliseconds():Float
        {
            return this._issueAgeInMilliseconds;
        }

        public var priority(get,never):Int;
function  get_priority():Int
        {
            return this._priority;
        }

        public var _Str_16842(get,never):Int;
function  get__Str_16842():Int
        {
            return this._Str_9559;
        }

        public var _Str_19929(get,never):Int;
function  get__Str_19929():Int
        {
            return this._Str_21130;
        }

        public var _Str_19615(get,never):String;
function  get__Str_19615():String
        {
            return this._Str_19722;
        }

        public var reportedUserId(get,never):Int;
function  get_reportedUserId():Int
        {
            return this._Str_2797;
        }

        public var reportedUserName(get,never):String;
function  get_reportedUserName():String
        {
            return this._Str_5502;
        }

        public var _Str_5547(get,never):Int;
function  get__Str_5547():Int
        {
            return this._Str_9859;
        }

        public var _Str_22164(get,never):String;
function  get__Str_22164():String
        {
            return this._Str_21393;
        }

        public var message(get,never):String;
function  get_message():String
        {
            return this._message;
        }

        public var _Str_20325(get,never):Int;
function  get__Str_20325():Int
        {
            return this._Str_10679;
        }

        public var _Str_26050(get,never):Array<ASAny>;
function  get__Str_26050():Array<ASAny>
        {
            return this._Str_15205;
        }

        public function dispose()
        {
            var k:PatternMatchData;
            if (this.disposed)
            {
                return;
            }
            for (_tmp_ in this._Str_15205)
            {
k  = _tmp_;
                k.dispose();
            }
            this._Str_15205 = [];
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_15885(k:Int):String
        {
            var _local_2= Std.int(((this._issueAgeInMilliseconds + k) - this._Str_19084) / 1000);
            var _local_3= Std.int(_local_2 / 60);
            var _local_4= (_local_3 % 60);
            var _local_5= Std.int(_local_3 / 60);
            var _local_6= (((_local_4 < 10) ? "0" : "") + _local_4);
            var _local_7= (((_local_5 < 10) ? "0" : "") + _local_5);
            return (_local_7 + ":") + _local_6;
        }
    }

