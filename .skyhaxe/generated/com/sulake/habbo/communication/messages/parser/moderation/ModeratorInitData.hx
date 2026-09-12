package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModeratorInitData implements IDisposable
    {
        var _messageTemplates:Array<ASAny>;
        var _roomMessageTemplates:Array<ASAny>;
        var _issues:Array<ASAny>;
        var _cfhPermission:Bool = false;
        var _chatlogsPermission:Bool = false;
        var _alertPermission:Bool = false;
        var _kickPermission:Bool = false;
        var _banPermission:Bool = false;
        var _roomAlertPermission:Bool = false;
        var _roomKickPermission:Bool = false;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            var _local_2= new IssueInfoMessageParser();
            this._issues = [];
            this._messageTemplates = [];
            this._roomMessageTemplates = [];
            var _local_3= k.readInteger();
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                if (_local_2.parse(k))
                {
                    this._issues.push(_local_2._Str_22192);
                }
                _local_4++;
            }
            _local_3 = k.readInteger();
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                this._messageTemplates.push(k.readString());
                _local_4++;
            }
            _local_3 = k.readInteger();
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                k.readString();
                _local_4++;
            }
            this._cfhPermission = k.readBoolean();
            this._chatlogsPermission = k.readBoolean();
            this._alertPermission = k.readBoolean();
            this._kickPermission = k.readBoolean();
            this._banPermission = k.readBoolean();
            this._roomAlertPermission = k.readBoolean();
            this._roomKickPermission = k.readBoolean();
            _local_3 = k.readInteger();
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                this._roomMessageTemplates.push(k.readString());
                _local_4++;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._messageTemplates = null;
            this._roomMessageTemplates = null;
            this._issues = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_15690(get,never):Array<ASAny>;
public function  get__Str_15690():Array<ASAny>
        {
            return this._messageTemplates;
        }

        public var _Str_18336(get,never):Array<ASAny>;
public function  get__Str_18336():Array<ASAny>
        {
            return this._roomMessageTemplates;
        }

        public var issues(get,never):Array<ASAny>;
public function  get_issues():Array<ASAny>
        {
            return this._issues;
        }

        public var _Str_24070(get,never):Bool;
public function  get__Str_24070():Bool
        {
            return this._cfhPermission;
        }

        public var _Str_12765(get,never):Bool;
public function  get__Str_12765():Bool
        {
            return this._chatlogsPermission;
        }

        public var _Str_18465(get,never):Bool;
public function  get__Str_18465():Bool
        {
            return this._alertPermission;
        }

        public var _Str_20397(get,never):Bool;
public function  get__Str_20397():Bool
        {
            return this._kickPermission;
        }

        public var _Str_21242(get,never):Bool;
public function  get__Str_21242():Bool
        {
            return this._banPermission;
        }

        public var _Str_24851(get,never):Bool;
public function  get__Str_24851():Bool
        {
            return this._roomAlertPermission;
        }

        public var _Str_24333(get,never):Bool;
public function  get__Str_24333():Bool
        {
            return this._roomKickPermission;
        }
    }

