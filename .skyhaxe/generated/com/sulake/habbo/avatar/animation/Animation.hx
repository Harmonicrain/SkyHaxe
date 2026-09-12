package com.sulake.habbo.avatar.animation
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.avatar.AvatarStructure;
    import com.sulake.habbo.avatar.actions.IActionDefinition;

     class Animation implements IAnimation 
    {
        static final _Str_2211:Array<ASAny> = [];

        var _id:String;
        var _description:String;
        var _frames:Array<ASAny>;
        var _spriteData:Array<ASAny>;
        var _avatarData:AvatarDataContainer;
        var _directionData:DirectionDataContainer;
        var _removeData:Array<ASAny>;
        var _addData:Array<ASAny>;
        var _overriddenActions:Map;
        var _overrideFrames:Map;
        var _resetOnToggle:Bool = false;

        public function new(k:AvatarStructure, _arg_2:com.sulake.core.utils.xml.XML)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9:Array<ASAny> = null;
            this._frames = [];
            this._id = _arg_2.attribute("name").toString();
            if (_arg_2.hasOwnProperty("@desc"))
            {
                this._description = _arg_2.attribute("desc").toString();
            }
            else
            {
                this._description = this._id;
            }
            if (_arg_2.hasOwnProperty("@resetOnToggle"))
            {
                this._resetOnToggle = ASCompat.toBool(_arg_2.attribute("resetOnToggle"));
            }
            else
            {
                this._resetOnToggle = false;
            }
            if (_arg_2.hasOwnProperty("sprite"))
            {
                this._spriteData = [];
                final _iter_ = _arg_2.child("sprite"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    this._spriteData.push(new SpriteDataContainer(this , _local_3));
                }
            }
            if (_arg_2.hasOwnProperty("avatar"))
            {
                this._avatarData = new AvatarDataContainer(_arg_2.child("avatar").at(0));
            }
            if (_arg_2.hasOwnProperty("direction"))
            {
                this._directionData = new DirectionDataContainer(_arg_2.child("direction").at(0));
            }
            if (_arg_2.hasOwnProperty("remove"))
            {
                this._removeData = [];
                final _iter_ = _arg_2.child("remove"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    this._removeData.push(_local_4.attribute("id").toString());
                }
            }
            if (_arg_2.hasOwnProperty("add"))
            {
                this._addData = [];
                final _iter_ = _arg_2.child("add"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    this._addData.push(new AddDataContainer(_local_5));
                }
            }
            if (_arg_2.hasOwnProperty("override"))
            {
                this._overrideFrames = new Map();
                this._overriddenActions = new Map();
                final _iter_ = _arg_2.child("override"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_6  = _tmp_;
                    _local_7 = _local_6.attribute("name").toString();
                    _local_8 = _local_6.attribute("override").toString();
                    this._overriddenActions.add(_local_8, _local_7);
                    _local_9 = new Array<ASAny>();
                    this.parseFrames(_local_9, _local_6.child("frame"), k);
                    this._overrideFrames.add(_local_7, _local_9);
                }
            }
            this.parseFrames(this._frames, _arg_2.child("frame"), k);
        }

        function parseFrames(k:Array<ASAny>, _arg_2:com.sulake.core.utils.xml.XMLList, _arg_3:AvatarStructure)
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:IActionDefinition = null;
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:com.sulake.core.utils.xml.XML = null;
            var _local_11:AnimationLayerData = null;
            var _local_12:AnimationLayerData = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_6  = _tmp_;
                _local_7 = 1;
                if (ASCompat.toNumber(ASCompat.xmlListToString(_local_6.attribute("repeats"))) > 1)
                {
                    _local_7 = ASCompat.toInt(ASCompat.xmlListToString(_local_6.attribute("repeats")));
                }
                _local_8 = 0;
                while (_local_8 < _local_7)
                {
                    _local_4 = new Array<ASAny>();
                    final _iter_ = _local_6.child("bodypart"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_9  = _tmp_;
                        _local_5 = _arg_3._Str_1675(_local_9.attribute("action").toString());
                        _local_11 = new AnimationLayerData(_local_9, AnimationLayerData.BODYPART, _local_5);
                        _local_4.push(_local_11);
                    }
                    final _iter_ = _local_6.child("fx"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_10  = _tmp_;
                        _local_5 = _arg_3._Str_1675(_local_10.attribute("action").toString());
                        _local_12 = new AnimationLayerData(_local_10, AnimationLayerData.FX, _local_5);
                        _local_4.push(_local_12);
                        if (_local_5 != null)
                        {
                        }
                    }
                    k.push(_local_4);
                    _local_8++;
                }
            }
        }

        public function _Str_2185(k:String=null):Int
        {
            var _local_2:Array<ASAny> = null;
            if (!ASCompat.stringAsBool(k))
            {
                return this._frames.length;
            }
            if (this._overrideFrames != null)
            {
                _local_2 = this._overrideFrames.getValue(k);
                if (_local_2 != null)
                {
                    return _local_2.length;
                }
            }
            return 0;
        }

        public function hasOverriddenActions():Bool
        {
            if (this._overriddenActions == null)
            {
                return false;
            }
            return this._overriddenActions.length > 0;
        }

        public function overriddenActionNames():Array<ASAny>
        {
            if (this._overriddenActions == null)
            {
                return null;
            }
            return this._overriddenActions.getKeys();
        }

        public function overridingAction(k:String):String
        {
            if (this._overriddenActions == null)
            {
                return null;
            }
            return this._overriddenActions.getValue(k);
        }

        function getFrame(k:Int, _arg_2:String=null):Array<ASAny>
        {
            var _local_4:Array<ASAny> = null;
            var _local_3:Array<ASAny> = [];
            if (!ASCompat.stringAsBool(_arg_2))
            {
                if (this._frames.length > 0)
                {
                    _local_3 = this._frames[(k % this._frames.length)];
                }
            }
            else
            {
                _local_4 = ASCompat.dynamicAs(this._overrideFrames.getValue(_arg_2) , Array);
                if (((_local_4 != null) && (_local_4.length > 0)))
                {
                    _local_3 = _local_4[(k % _local_4.length)];
                }
            }
            return _local_3;
        }

        public function getAnimatedBodyPartIds(k:Int, _arg_2:String=null):Array<ASAny>
        {
            var _local_4:AnimationLayerData = null;
            var _local_5:AddDataContainer = null;
            var _local_3= new Array<ASAny>();
            final _iter_ = this.getFrame(k, _arg_2); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                if (_local_4.type == AnimationLayerData.BODYPART)
                {
                    _local_3.push(_local_4.id);
                }
                else
                {
                    if (_local_4.type == AnimationLayerData.FX)
                    {
                        if (this._addData != null)
                        {
                            final _iter_ = this._addData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                            {
_local_5  = _tmp_;
                                if (_local_5.id == _local_4.id)
                                {
                                    _local_3.push(_local_5.align);
                                }
                            }
                        }
                    }
                }
            }
            return _local_3;
        }

        public function getLayerData(k:Int, _arg_2:String, _arg_3:String=null):AnimationLayerData
        {
            var _local_4:AnimationLayerData = null;
            var _local_5:AddDataContainer = null;
            final _iter_ = this.getFrame(k, _arg_3); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                if (_local_4.id == _arg_2)
                {
                    return _local_4 ;
                }
                if (_local_4.type == AnimationLayerData.FX)
                {
                    final _iter_ = this._addData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_5  = _tmp_;
                        if (((_local_5.align == _arg_2) && (_local_5.id == _local_4.id)))
                        {
                            return _local_4 ;
                        }
                    }
                }
            }
            return null;
        }

        public function hasAvatarData():Bool
        {
            return !(this._avatarData == null);
        }

        public function hasDirectionData():Bool
        {
            return !(this._directionData == null);
        }

        public function hasAddData():Bool
        {
            return !(this._addData == null);
        }

        public function getAddData(k:String):AddDataContainer
        {
            var _local_2:AddDataContainer = null;
            if (this._addData != null)
            {
                final _iter_ = this._addData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.id == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var spriteData(get,never):Array<ASAny>;
public function  get_spriteData():Array<ASAny>
        {
            return (this._spriteData != null) ? this._spriteData : _Str_2211;
        }

        public var avatarData(get,never):AvatarDataContainer;
public function  get_avatarData():AvatarDataContainer
        {
            return this._avatarData;
        }

        public var directionData(get,never):DirectionDataContainer;
public function  get_directionData():DirectionDataContainer
        {
            return this._directionData;
        }

        public var removeData(get,never):Array<ASAny>;
public function  get_removeData():Array<ASAny>
        {
            return (this._removeData != null) ? this._removeData : _Str_2211;
        }

        public var addData(get,never):Array<ASAny>;
public function  get_addData():Array<ASAny>
        {
            return (this._addData != null) ? this._addData : _Str_2211;
        }

        public function toString():String
        {
            return this._description;
        }

        public var resetOnToggle(get,never):Bool;
public function  get_resetOnToggle():Bool
        {
            return this._resetOnToggle;
        }
    }

