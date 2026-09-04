package com.sulake.habbo.avatar
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.avatar.alias.AssetAliasCollection;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar._enum.AvatarAction;

     class PlaceholderAvatarImage extends AvatarImage 
    {
        @:allow(com.sulake.habbo.avatar) static var CACHE:Map = new Map();

        public function new(k:AvatarStructure, _arg_2:AssetAliasCollection, _arg_3:AvatarFigureContainer, _arg_4:String, _arg_5:EffectAssetDownloadManager)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, null);
        }

        override public function dispose()
        {
            if (!_Str_580)
            {
                if (_Str_586 != null)
                {
                    _Str_586.dispose();
                    _Str_586 = null;
                }
                _Str_581 = null;
                _assets = null;
                _Str_1708 = null;
                _figure = null;
                _avatarDataContainer = null;
                _Str_614 = null;
                if (((!_Str_1586) && (_image != null)))
                {
                    _image.dispose();
                }
                _image = null;
                _Str_903 = null;
                _Str_580 = true;
            }
        }

        override function getFullImage(k:String):BitmapData
        {
            return CACHE.getValue(k);
        }

        override function cacheFullImage(k:String, _arg_2:BitmapData)
        {
            if (CACHE.getValue(k))
            {
                ASCompat.dynamicAs(CACHE.getValue(k) , BitmapData).dispose();
                CACHE.remove(k);
            }
            CACHE.setValue(k, _arg_2);
        }

        override public function appendAction(k:String,  _args:Array<ASAny> = null):Bool
        {
if (_args == null) _args = [];
            var _local_3:String = null;
            if (((!(_args == null)) && (_args.length > 0)))
            {
                _local_3 = _args[0];
            }
            switch (k)
            {
                case AvatarAction.POSTURE:
                    switch (_local_3)
                    {
                        case AvatarAction.POSTURE_LAY
                           | AvatarAction.POSTURE_WALK
                           | AvatarAction.POSTURE_STAND
                           | AvatarAction.POSTURE_SWIM
                           | AvatarAction.POSTURE_FLOAT
                           | AvatarAction.POSTURE_SIT:
                            super.appendAction(k, [_local_3]);
                            
                    }
                    
                case AvatarAction.EFFECT
                   | AvatarAction.DANCE
                   | AvatarAction.EXPRESSION_WAVE
                   | AvatarAction.SIGN
                   | AvatarAction.CARRY_OBJECT
                   | AvatarAction.USE_OBJECT
                   | AvatarAction.EXPRESSION_BLOW_A_KISS:
                    super.addActionData(k, ((_local_3 == null) ? "" : _local_3));
                    
            }
            return true;
        }

        override public function isPlaceholder():Bool
        {
            return true;
        }
    }

