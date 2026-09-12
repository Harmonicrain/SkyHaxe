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
            var _local_3:AvatarSet = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:Array<ASAny> = null;
            this._id = k.attribute("id").toString();
            var _local_2= k.attribute("main").toString();
            this._isMain = ((_local_2 == null) ? false : ASCompat.toBool(ASCompat.parseInt(_local_2)));
            this._avatarSets = new ASDictionary<ASAny,ASAny>();
            this._bodyParts = new Array<ASAny>();
            final _iter_ = k.child("avatarset"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_3 = new AvatarSet(_local_4);
                this._avatarSets[_local_4.attribute("id").toString()] = _local_3;
            }
            final _iter_ = k.child("bodypart"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                this._bodyParts.push(_local_5.attribute("id").toString());
            }
            _local_6 = this._bodyParts.copy();
            final _iter_ = this._avatarSets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_6 = _local_6.concat(_local_3.getBodyParts());
            }
            this._allBodyParts = _local_6;
        }

        public function findAvatarSet(k:String):AvatarSet
        {
            var _local_2:AvatarSet = null;
            if (k == this._id)
            {
                return this;
            }
            final _iter_ = this._avatarSets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
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
public function  get_id():String
        {
            return this._id;
        }

        public var isMain(get,never):Bool;
public function  get_isMain():Bool
        {
            var _local_1:AvatarSet = null;
            if (this._isMain)
            {
                return true;
            }
            final _iter_ = this._avatarSets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
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

