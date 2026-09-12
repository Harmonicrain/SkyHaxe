package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ForumData
    {
        var _groupId:Int = 0;
        var _name:String;
        var _description:String;
        var _icon:String;
        var _Str_6203:Int = 0;
        var _Str_19654:Int = 0;
        var _Str_5103:Int = 0;
        var _Str_5870:Int = 0;
        var _Str_6301:Int = 0;
        var _Str_6813:Int = 0;
        var _Str_6395:String;
        var _Str_6378:Int = 0;


        public static function _Str_4933(k:IMessageDataWrapper):ForumData
        {
            return fillFromMessage(Type.createInstance(ForumData, []), k);
        }

        @:allow(com.sulake.habbo.communication.messages.parser.groupforums) static function fillFromMessage(k:ForumData, _arg_2:IMessageDataWrapper):ForumData
        {
            k._groupId = _arg_2.readInteger();
            k._name = _arg_2.readString();
            k._description = _arg_2.readString();
            k._icon = _arg_2.readString();
            k._Str_6203 = _arg_2.readInteger();
            k._Str_19654 = _arg_2.readInteger();
            k._Str_5103 = _arg_2.readInteger();
            k._Str_5870 = _arg_2.readInteger();
            k._Str_6301 = _arg_2.readInteger();
            k._Str_6813 = _arg_2.readInteger();
            k._Str_6395 = _arg_2.readString();
            k._Str_6378 = _arg_2.readInteger();
            return k;
        }


        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

        public var icon(get,never):String;
public function  get_icon():String
        {
            return this._icon;
        }

        public var _Str_18760(get,never):Int;
public function  get__Str_18760():Int
        {
            return this._Str_6203;
        }

        public var _Str_25067(get,never):Int;
public function  get__Str_25067():Int
        {
            return this._Str_19654;
        }

        public var _Str_8598(get,never):Int;
public function  get__Str_8598():Int
        {
            return this._Str_5103;
        }

        public var _Str_18237(get,never):Int;
public function  get__Str_18237():Int
        {
            return this._Str_5870;
        }

        public var _Str_10610(get,never):Int;
public function  get__Str_10610():Int
        {
            return this._Str_6301;
        }

        public var _Str_8317(get,never):Int;
public function  get__Str_8317():Int
        {
            return this._Str_6813;
        }

        public var _Str_9601(get,never):String;
public function  get__Str_9601():String
        {
            return this._Str_6395;
        }

        public var _Str_8950(get,never):Int;
public function  get__Str_8950():Int
        {
            return this._Str_6378;
        }

        public function _Str_25309(k:ForumData)
        {
            this._Str_6203 = k._Str_6203;
            this._Str_5103 = k._Str_5103;
            this._Str_5870 = k._Str_5870;
            this._Str_6813 = k._Str_6813;
            this._Str_6395 = k._Str_6395;
            this._Str_6301 = k._Str_6301;
            this._Str_6378 = k._Str_6378;
        }

        
        public var _Str_12786(get,set):Int;
public function  get__Str_12786():Int
        {
            return this._Str_5103 - this._Str_5870;
        }
public function  set__Str_12786(k:Int):Int        {
            this._Str_5870 = (this._Str_5103 - k);
            if (this._Str_5870 < 0)
            {
                this._Str_5870 = 0;
            }
return k;
        }

        public function _Str_23783(k:GuildForumThread)
        {
            this._Str_6813 = k.lastUserId;
            this._Str_6395 = k.lastUserName;
            this._Str_6301 = k._Str_10610;
            this._Str_6378 = k.lastCommentTime;
            this._Str_6203++;
            this._Str_5103++;
            this._Str_5870 = 0;
        }

	public function new() {}
    }

