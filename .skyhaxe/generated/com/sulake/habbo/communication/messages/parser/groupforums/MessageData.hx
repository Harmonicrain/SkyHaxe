package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MessageData
    {
        var _groupId:Int = 0;
        var _messageId:Int = 0;
        var _messageIndex:Int = 0;
        var _Str_21082:Int = 0;
        var _threadId:Int = 0;
        var _creationTime:Int = 0;
        var _messageText:String;
        var _Str_20600:String;
        var _Str_21796:String;
        var _state:Int = 0;
        var _Str_11523:Int = 0;
        var _Str_12139:String;
        var _Str_20143:Int = 0;
        var _Str_21485:Int = 0;


        public static function _Str_4933(k:IMessageDataWrapper):MessageData
        {
            var _local_2= Type.createInstance(MessageData, []);
            _local_2.messageId = k.readInteger();
            _local_2.messageIndex = k.readInteger();
            _local_2._Str_18036 = k.readInteger();
            _local_2._Str_6415 = k.readString();
            _local_2._Str_18957 = k.readString();
            _local_2._Str_6238 = k.readInteger();
            _local_2.messageText = k.readString();
            _local_2.state = k.readByte();
            _local_2._Str_9776 = k.readInteger();
            _local_2._Str_6110 = k.readString();
            _local_2._Str_20798 = k.readInteger();
            _local_2._Str_17584 = k.readInteger();
            return _local_2;
        }


        
        public var state(get,set):Int;
public function  get_state():Int
        {
            return this._state;
        }
public function  set_state(k:Int):Int        {
            return this._state = k;
        }

        
        public var _Str_9776(get,set):Int;
public function  get__Str_9776():Int
        {
            return this._Str_11523;
        }
public function  set__Str_9776(k:Int):Int        {
            return this._Str_11523 = k;
        }

        
        public var _Str_6110(get,set):String;
public function  get__Str_6110():String
        {
            return this._Str_12139;
        }
public function  set__Str_6110(k:String):String        {
            return this._Str_12139 = k;
        }

        
        public var _Str_20798(get,set):Int;
public function  get__Str_20798():Int
        {
            return this._Str_20143;
        }
public function  set__Str_20798(k:Int):Int        {
            return this._Str_20143 = k;
        }

        
        public var _Str_23476(get,set):Int;
public function  get__Str_23476():Int
        {
            return this._messageId;
        }
public function  set__Str_23476(k:Int):Int        {
            return this._messageId = k;
        }

        
        public var creationTime(get,set):Int;
public function  get_creationTime():Int
        {
            return this._creationTime;
        }
public function  set_creationTime(k:Int):Int        {
            return this._creationTime = k;
        }

        
        public var _Str_6415(get,set):String;
public function  get__Str_6415():String
        {
            return this._Str_20600;
        }
public function  set__Str_6415(k:String):String        {
            return this._Str_20600 = k;
        }

        
        public var _Str_18957(get,set):String;
public function  get__Str_18957():String
        {
            return this._Str_21796;
        }
public function  set__Str_18957(k:String):String        {
            return this._Str_21796 = k;
        }

        
        public var threadId(get,set):Int;
public function  get_threadId():Int
        {
            return this._threadId;
        }
public function  set_threadId(k:Int):Int        {
            return this._threadId = k;
        }

        
        public var messageId(get,set):Int;
public function  get_messageId():Int
        {
            return this._messageId;
        }
public function  set_messageId(k:Int):Int        {
            return this._messageId = k;
        }

        
        public var messageIndex(get,set):Int;
public function  get_messageIndex():Int
        {
            return this._messageIndex;
        }
public function  set_messageIndex(k:Int):Int        {
            return this._messageIndex = k;
        }

        public var groupID(never,set):Int;
public function  set_groupID(k:Int):Int        {
            return this._groupId = k;
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }

        
        public var _Str_18036(get,set):Int;
public function  get__Str_18036():Int
        {
            return this._Str_21082;
        }
public function  set__Str_18036(k:Int):Int        {
            return this._Str_21082 = k;
        }

        
        public var _Str_6238(get,set):Int;
public function  get__Str_6238():Int
        {
            return this._creationTime;
        }
public function  set__Str_6238(k:Int):Int        {
            return this._creationTime = k;
        }

        
        public var messageText(get,set):String;
public function  get_messageText():String
        {
            return this._messageText;
        }
public function  set_messageText(k:String):String        {
            return this._messageText = k;
        }

        
        public var _Str_17584(get,set):Int;
public function  get__Str_17584():Int
        {
            return this._Str_21485;
        }
public function  set__Str_17584(k:Int):Int        {
            return this._Str_21485 = k;
        }

	public function new() {}
    }

