package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class LiftedRoomData
    {
        var _flatId:Int = 0;
        var _areaId:Int = 0;
        var _image:String;
        var _caption:String;

        public function new(k:IMessageDataWrapper)
        {
            this._flatId = k.readInteger();
            this._areaId = k.readInteger();
            this._image = k.readString();
            this._caption = k.readString();
        }

        public var flatId(get,never):Int;
function  get_flatId():Int
        {
            return this._flatId;
        }

        public var areaId(get,never):Int;
function  get_areaId():Int
        {
            return this._areaId;
        }

        public var image(get,never):String;
function  get_image():String
        {
            return this._image;
        }

        public var caption(get,never):String;
function  get_caption():String
        {
            return this._caption;
        }
    }

