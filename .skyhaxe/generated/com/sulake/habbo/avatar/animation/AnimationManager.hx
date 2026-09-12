package com.sulake.habbo.avatar.animation
;
    import com.sulake.habbo.avatar.AvatarStructure;

     class AnimationManager implements IAnimationManager 
    {
        var _animations:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._animations = new ASDictionary<ASAny,ASAny>();
        }

        public function registerAnimation(k:AvatarStructure, _arg_2:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_3= _arg_2.attribute("name").toString();
            this._animations[_local_3] = new Animation(k, _arg_2);
            return true;
        }

        public function getAnimation(k:String):IAnimation
        {
            return this._animations[k];
        }

        public function getLayerData(k:String, _arg_2:Int, _arg_3:String):IAnimationLayerData
        {
            var _local_4= ASCompat.dynamicAs(this._animations[k] , Animation);
            if (_local_4 != null)
            {
                return _local_4.getLayerData(_arg_2, _arg_3);
            }
            return null;
        }

        public var animations(get,never):ASDictionary<ASAny,ASAny>;
public function  get_animations():ASDictionary<ASAny,ASAny>
        {
            return this._animations;
        }
    }

