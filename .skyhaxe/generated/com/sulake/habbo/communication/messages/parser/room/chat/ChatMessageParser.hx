package com.sulake.habbo.communication.messages.parser.room.chat
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ChatMessageParser implements IMessageParser 
    {
        var _userId:Int = 0;
        var _text:String = "";
        var _links:Array<ASAny>;
        var _gesture:Int = 0;
        var _animationLength:Int = -1;
        var _styleId:Int = 0;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var links(get,never):Array<ASAny>;
public function  get_links():Array<ASAny>
        {
            return this._links;
        }

        public var gesture(get,never):Int;
public function  get_gesture():Int
        {
            return this._gesture;
        }

        public var animationLength(get,never):Int;
public function  get_animationLength():Int
        {
            return this._animationLength;
        }

        public var styleId(get,never):Int;
public function  get_styleId():Int
        {
            return this._styleId;
        }

        public function flush():Bool
        {
            this._userId = 0;
            this._text = "";
            this._gesture = 0;
            this._links = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3 = 0;
            if (k == null)
            {
                return false;
            }
            this._userId = k.readInteger();
            this._text = k.readString();
            this._gesture = k.readInteger();
            this._styleId = k.readInteger();
            var _local_2= k.readInteger();
            if (_local_2 > 0)
            {
                this._links = new Array<ASAny>();
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    this._links.push(([k.readString(), k.readString(), k.readBoolean()] : Array<Dynamic>));
                    _local_3++;
                }
            }
            this._animationLength = k.readInteger();
            return true;
        }

	public function new() {}
    }

