package com.sulake.habbo.room.object.visualization.avatar
;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar._Str_936;
    import com.sulake.core.assets.IAsset;

     class AvatarVisualizationData implements IRoomObjectVisualizationData 
    {
        var _avatarRenderer:IAvatarRenderManager = null;


        
        public var _Str_1458(get,set):IAvatarRenderManager;
function  get__Str_1458():IAvatarRenderManager
        {
            return this._avatarRenderer;
        }
function  set__Str_1458(k:IAvatarRenderManager):IAvatarRenderManager        {
            return this._avatarRenderer = k;
        }

        public function initialize(k:com.sulake.core.utils.xml.XML):Bool
        {
            return true;
        }

        public function dispose()
        {
            this._avatarRenderer = null;
        }

        public function _Str_8991(k:String, _arg_2:Float, _arg_3:String=null, _arg_4:IAvatarImageListener=null, _arg_5:_Str_936=null):IAvatarImage
        {
            var _local_6:IAvatarImage;
            if (this._avatarRenderer != null)
            {
                _local_6 = null;
                if (_arg_2 > 48)
                {
                    _local_6 = this._avatarRenderer.createAvatarImage(k, AvatarScaleType.LARGE, _arg_3, _arg_4, _arg_5);
                }
                else
                {
                    _local_6 = this._avatarRenderer.createAvatarImage(k, AvatarScaleType.SMALL, _arg_3, _arg_4, _arg_5);
                }
                return _local_6;
            }
            return null;
        }

        public function getLayerCount(k:String):Float
        {
            return 0;
        }

        public function getAvatarRendererAsset(k:String):IAsset
        {
            if (this._avatarRenderer == null)
            {
                return null;
            }
            return this._avatarRenderer.assets.getAssetByName(k);
        }
public function new(){}
    }

