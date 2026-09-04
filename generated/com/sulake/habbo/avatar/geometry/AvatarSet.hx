package com.sulake.habbo.avatar.geometry
;

     class AvatarSet 
    {
        var _id:String;
        var _avatarSets:ASDictionary<ASAny,ASAny>;
        var _bodyParts:Array<ASAny>;
        var _allBodyParts:Array<ASAny>;
        var _isMain:Bool = false;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_3:AvatarSet;
            var _local_4:com.sulake.core.utils.xml.XML;
            var _local_5:com.sulake.core.utils.xml.XML;
            var _local_6:Array<ASAny>;
            this._id = k.attribute("id").toString();
            var _local_2= k.attribute("main").toString();
            this._isMain = ((_local_2 == null) ? false : ASCompat.toBool(ASCompat.parseInt(_local_2)));
            this._avatarSets = new ASDictionary<ASAny,ASAny>();
            this._bodyParts = new Array<ASAny>();
            for (_tmp_ in k.child("avatarset"))
            {
_local_4  = _tmp_;
                _local_3 = new AvatarSet(_local_4);
                this._avatarSets[_local_4.attribute("id").toString()] = _local_3;
            }
            for (_tmp_ in k.child("bodypart"))
            {
_local_5  = _tmp_;
                this._bodyParts.push(_local_5.attribute("id").toString());
            }
            _local_6 = this._bodyParts.copy();
            for (_tmp_ in this._avatarSets)
            {
_local_3  = _tmp_;
                _local_6 = _local_6.concat(_local_3.getBodyParts());
            }
            this._allBodyParts = _local_6;
        }

        public function findAvatarSet(k:String):AvatarSet
        {
            var _local_2:AvatarSet;
            if (k == this._id)
            {
                return this;
            }
            for (_tmp_ in this._avatarSets)
            {
_local_2  = _tmp_;
                if (_local_2.findAvatarSet(k) != null)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function getBodyParts():Array<ASAny>
        {
            return this._allBodyParts.copy();
        }

        public var id(get,never):String;
function  get_id():String
        {
            return this._id;
        }

        public var isMain(get,never):Bool;
function  get_isMain():Bool
        {
            var _local_1:AvatarSet;
            if (this._isMain)
            {
                return true;
            }
            for (_tmp_ in this._avatarSets)
            {
_local_1  = _tmp_;
                if (_local_1.isMain)
                {
                    return true;
                }
            }
            return false;
        }
    }

