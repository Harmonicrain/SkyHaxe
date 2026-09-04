package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureMannequinVisualization extends FurnitureVisualization implements IAvatarImageListener 
    {
        static inline final AVATAR_IMAGE= "avatar_image";
        static var _customPlaceholders:ASDictionary<ASAny,ASAny>;
        static var _instanceCount:Int = 0;

        static inline final _Str_20434= "hd-99999-99998";

        var _figure:String;
        var _gender:String;
        var _scale:Int = 0;
        var _needsUpdate:Bool = false;
        var _dynamicAssetName:String;
        var _data__com_sulake_habbo_room_object_visualization_furniture_FurnitureMannequinVisualization/*redefined private*/:FurnitureMannequinVisualizationData;
        var _disposed:Bool = false;

        public function new()
        {
            super();
            _instanceCount++;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        override public function dispose()
        {
            var k:IAvatarImage;
            if (!this._disposed)
            {
                this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureMannequinVisualization = null;
                this._disposed = true;
                if ((ASCompat.stringAsBool(this._dynamicAssetName) && (assetCollection != null)))
                {
                    assetCollection.disposeAsset(this._dynamicAssetName);
                    this._dynamicAssetName = null;
                }
                super.dispose();
                _instanceCount--;
                if (((_instanceCount == 0) && (_customPlaceholders != null)))
                {
                    for (_tmp_ in _customPlaceholders)
                    {
k  = _tmp_;
                        k.dispose();
                    }
                    _customPlaceholders = null;
                }
            }
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureMannequinVisualization = Std.downcast(k , FurnitureMannequinVisualizationData);
            super.initialize(k);
            return true;
        }

        override function updateObject(k:Float, _arg_2:Float):Bool
        {
            var _local_3= super.updateObject(k, _arg_2);
            if (_local_3)
            {
                if (this._scale != k)
                {
                    this._scale = Std.int(k);
                    this.addAvatarAsset();
                }
            }
            return _local_3;
        }

        function addAvatarAsset(k:Bool=false)
        {
            var _local_2:IAvatarImage;
            var _local_3:IAvatarImage;
            if (((!this.isAvatarAssetReady()) || k))
            {
                _local_2 = this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureMannequinVisualization._Str_8991(this._figure, this._scale, this._gender, this);
                if (_local_2 != null)
                {
                    if (_local_2.isPlaceholder())
                    {
                        _local_2.dispose();
                        _local_3 = this.getCustomPlaceholder(this._scale);
                        _local_3.setDirection(AvatarSetType.FULL, direction);
                        assetCollection.addAsset(this.getAvatarAssetName(), _local_3.getImage(AvatarSetType.FULL, true), true);
                        this._needsUpdate = true;
                        return;
                    }
                    _local_2.setDirection(AvatarSetType.FULL, direction);
                    if (ASCompat.stringAsBool(this._dynamicAssetName))
                    {
                        assetCollection.disposeAsset(this._dynamicAssetName);
                    }
                    assetCollection.addAsset(this.getAvatarAssetName(), _local_2.getImage(AvatarSetType.FULL, true), true);
                    this._dynamicAssetName = this.getAvatarAssetName();
                    this._needsUpdate = true;
                    _local_2.dispose();
                }
            }
        }

        override public function getSpriteList():Array<ASAny>
        {
            var k= this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureMannequinVisualization._Str_8991(this._figure, this._scale, this._gender, this);
            if (k == null)
            {
                return super.getSpriteList();
            }
            k.setDirection(AvatarSetType.FULL, direction);
            return k._Str_1009();
        }

        function getCustomPlaceholder(k:Int):IAvatarImage
        {
            if (_customPlaceholders == null)
            {
                _customPlaceholders = new ASDictionary<ASAny,ASAny>();
            }
            var _local_2:IAvatarImage = _customPlaceholders[k];
            if (_local_2 == null)
            {
                _local_2 = this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureMannequinVisualization._Str_8991(FurnitureMannequinVisualization._Str_20434, k, null, null);
                _customPlaceholders[k] = _local_2;
            }
            return _local_2;
        }

        override function updateModel(k:Float):Bool
        {
            var _local_3:IRoomObject;
            var _local_4:IRoomObjectModel;
            var _local_5:String;
            var _local_2= super.updateModel(k);
            if (_local_2)
            {
                _local_3 = object;
                if (_local_3 != null)
                {
                    _local_4 = _local_3.getModel();
                    if (_local_4 != null)
                    {
                        _local_5 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_FIGURE);
                        if (ASCompat.stringAsBool(_local_5))
                        {
                            this._gender = _local_4.getString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_GENDER);
                            this._figure = ((_local_5 + ".") + FurnitureMannequinVisualization._Str_20434);
                            this.addAvatarAsset();
                        }
                    }
                }
            }
            _local_2 = (_local_2 || this._needsUpdate);
            this._needsUpdate = false;
            return _local_2;
        }

        function isAvatarAssetReady():Bool
        {
            return ASCompat.stringAsBool(this._figure) && (!(getAsset(this.getAvatarAssetName()) == null));
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            var _local_3= getSpriteTag(k, direction, _arg_2);
            if ((((!(this._figure == null)) && (_local_3 == AVATAR_IMAGE)) && this.isAvatarAssetReady()))
            {
                return this.getAvatarAssetName();
            }
            return super.getSpriteAssetName(k, _arg_2);
        }

        function getAvatarAssetName():String
        {
            var k= object;
            if (k == null)
            {
                return null;
            }
            return (((((("mannequin_" + this._figure) + "_") + this._scale) + "_") + direction) + "_") + k.getId();
        }

        public function avatarImageReady(k:String)
        {
            if (k == this._figure)
            {
                this.addAvatarAsset(true);
            }
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= getSpriteTag(k, _arg_2, _arg_3);
            if (((_local_4 == AVATAR_IMAGE) && this.isAvatarAssetReady()))
            {
                return Std.int(-getSprite(_arg_3).width / 2);
            }
            return super.getSpriteXOffset(k, _arg_2, _arg_3);
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= getSpriteTag(k, _arg_2, _arg_3);
            if (((_local_4 == AVATAR_IMAGE) && this.isAvatarAssetReady()))
            {
                return -getSprite(_arg_3).height;
            }
            return super.getSpriteYOffset(k, _arg_2, _arg_3);
        }
    }

