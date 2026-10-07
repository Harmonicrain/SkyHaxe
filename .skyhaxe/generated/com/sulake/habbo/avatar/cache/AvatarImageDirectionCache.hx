package com.sulake.habbo.avatar.cache
;
    import com.sulake.habbo.avatar.AvatarImageBodyPartContainer;
    import com.sulake.habbo.avatar.AvatarImagePartContainer;

     class AvatarImageDirectionCache 
    {
        var _partList:Array<ASAny>;
        var _images:ASDictionary<ASAny,ASAny>;

        public function new(k:Array<ASAny>)
        {
            this._images = new ASDictionary<ASAny,ASAny>();
            this._partList = k;
        }

        public function dispose()
        {
            var k:AvatarImageBodyPartContainer = null;
            final _iter_ = this._images; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k != null)
                {
                    k.dispose();
                }
            }
            this._images = null;
        }

        public function _Str_1699():Array<ASAny>
        {
            return this._partList;
        }

        public function getImageContainer(k:Int):AvatarImageBodyPartContainer
        {
            var _local_2= this.getCacheKey(k);
            return this._images[_local_2];
        }

        public function updateImageContainer(k:AvatarImageBodyPartContainer, _arg_2:Int)
        {
            var _local_4:AvatarImageBodyPartContainer = null;
            var _local_3= this.getCacheKey(_arg_2);
            if (this._images[_local_3])
            {
                _local_4 = ASCompat.dynamicAs(this._images[_local_3] , AvatarImageBodyPartContainer);
                if (_local_4 != null)
                {
                    _local_4.dispose();
                }
            }
            this._images[_local_3] = k;
        }

        function getCacheKey(k:Int):String
        {
            var _local_3:AvatarImagePartContainer = null;
            var _local_2= "";
            final _iter_ = this._partList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_2 = (_local_2 + (_local_3.getCacheableKey(k) + "/"));
            }
            return _local_2;
        }

        function _Str_587(k:String)
        {
        }
    }

