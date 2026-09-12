package com.sulake.habbo.avatar.alias
;
    import com.sulake.core.assets.AssetLibraryCollection;
    import com.sulake.habbo.avatar.AvatarRenderManager;
    import com.sulake.core.assets.IAsset;

     class AssetAliasCollection 
    {
        var _assets:AssetLibraryCollection;
        var _aliases:ASDictionary<ASAny,ASAny>;
        var _avatarRenderManager:AvatarRenderManager;
        var _missingAssetNames:Array<ASAny>;

        public function new(k:AvatarRenderManager, _arg_2:AssetLibraryCollection)
        {
            this._avatarRenderManager = k;
            this._aliases = new ASDictionary<ASAny,ASAny>();
            this._assets = _arg_2;
            this._missingAssetNames = [];
        }

        public function dispose()
        {
            this._assets = null;
            this._aliases = null;
        }

        public function reset()
        {
            this.init();
        }

        public function init()
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var k= this._assets.getManifests();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this.collectAliases(_local_2);
            }
        }

        function collectAliases(k:com.sulake.core.utils.xml.XML)
        {
            var child:com.sulake.core.utils.xml.XML = null;
            var name:String = null;
            final _iter_ = k.children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
child  = _tmp_;
                if (child.localName() == "alias")
                {
                    name = child.attribute("name").toString();
                    this._aliases[name] = new AssetAlias(child);
                }
                this.collectAliases(child);
            }
        }

        public function each(k:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            var _local_5= new com.sulake.core.utils.xml.XML("<alias name=\"\" link=\"\" fliph=\"0\" flipv=\"0\"/>")
            ;
            _local_5.setAttribute("name", k) ;
            _local_5.setAttribute("link", _arg_2) ;
            var _local_6= new AssetAlias(_local_5);
            this._aliases[k] = _local_6;
        }

        public function hasAlias(k:String):Bool
        {
            var _local_2= ASCompat.dynamicAs(this._aliases[k] , AssetAlias);
            return !(_local_2 == null);
        }

        public function getAliasByName(k:String):String
        {
            var _local_4:AssetAlias = null;
            var _local_2= k;
            var _local_3= 5;
            while ((this.hasAlias(_local_2) && (_local_3 >= 0)))
            {
                _local_4 = ASCompat.dynamicAs(this._aliases[_local_2] , AssetAlias);
                _local_2 = _local_4.link;
                _local_3--;
            }
            return _local_2;
        }

        public function getAssetByName(k:String):IAsset
        {
            k = this.getAliasByName(k);
            var _local_2= this._assets.getAssetByName(k);
            return _local_2;
        }
    }

