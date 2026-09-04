package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.SlideObjectMessageData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SlideObjectBundleMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _objectList:Array<ASAny>;
        var _avatar:SlideObjectMessageData = null;


        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var avatar(get,never):SlideObjectMessageData;
function  get_avatar():SlideObjectMessageData
        {
            return this._avatar;
        }

        public var objectList(get,never):Array<ASAny>;
function  get_objectList():Array<ASAny>
        {
            return this._objectList;
        }

        public function flush():Bool
        {
            this._id = -1;
            this._avatar = null;
            this._objectList = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var userIndex:Int;
            var movedObject:SlideObjectMessageData;
            var oldVector:Vector3d;
            var newVector:Vector3d;
            var oldZ:Float;
            var newZ:Float;
            if (k == null)
            {
                return false;
            }
            var oldX:Float = k.readInteger();
            var oldY:Float = k.readInteger();
            var newX:Float = k.readInteger();
            var newY:Float = k.readInteger();
            var movedObjects= k.readInteger();
            this._objectList = new Array<ASAny>();
            var _local_13 = 0;
            while (_local_13 < movedObjects)
            {
                userIndex = k.readInteger();
                oldZ = ASCompat.toNumber(k.readString());
                newZ = ASCompat.toNumber(k.readString());
                oldVector = new Vector3d(oldX, oldY, oldZ);
                newVector = new Vector3d(newX, newY, newZ);
                movedObject = new SlideObjectMessageData(userIndex, oldVector, newVector);
                this._objectList.push(movedObject);
                _local_13++;
            }
            this._id = k.readInteger(); //furni itemId
            if (k.bytesAvailable == 0)
            {
                return true;
            }
            //Moved avatar
            var type= k.readInteger();
            switch (type)
            {
                case 0:
                    
                case 1:
                    userIndex = k.readInteger();
                    oldZ = ASCompat.toNumber(k.readString());
                    newZ = ASCompat.toNumber(k.readString());
                    oldVector = new Vector3d(oldX, oldY, oldZ);
                    newVector = new Vector3d(newX, newY, newZ);
                    this._avatar = new SlideObjectMessageData(userIndex, oldVector, newVector, SlideObjectMessageData.MV);
                    
                case 2:
                    userIndex = k.readInteger();
                    oldZ = ASCompat.toNumber(k.readString());
                    newZ = ASCompat.toNumber(k.readString());
                    oldVector = new Vector3d(oldX, oldY, oldZ);
                    newVector = new Vector3d(newX, newY, newZ);
                    this._avatar = new SlideObjectMessageData(userIndex, oldVector, newVector, SlideObjectMessageData.SLD);
                    
                default:
                    Logger.log("** Incompatible character movetype!");
            }
            return true;
        }

	public function new() {}
    }

