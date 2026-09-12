package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabbiconMessengerContent
    {
        public static inline final MESSAGE_TYPE_TEXT= 0;
        public static inline final MESSAGE_TYPE_HABBICON= 1;

        var _messageType:Int = 0;
        var _messageText:String;
        var _habbiconId:Int = 0;

        public function new(wrapper:IMessageDataWrapper = null)
        {
            if (wrapper != null)
            {
                this.parse(wrapper);
            }
        }

        public function parse(wrapper:IMessageDataWrapper)
        {
            this._messageType = wrapper.readInteger();
            if (this._messageType == MESSAGE_TYPE_HABBICON)
            {
                this._habbiconId = wrapper.readInteger();
                this._messageText = "";
            }
            else
            {
                this._messageText = wrapper.readString();
                this._habbiconId = 0;
            }
        }

        public var messageType(get,never):Int;
public function  get_messageType():Int
        {
            return this._messageType;
        }

        public var messageText(get,never):String;
public function  get_messageText():String
        {
            return this._messageText;
        }

        public var habbiconId(get,never):Int;
public function  get_habbiconId():Int
        {
            return this._habbiconId;
        }
    }

