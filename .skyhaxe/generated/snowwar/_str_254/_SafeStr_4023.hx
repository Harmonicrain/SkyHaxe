package snowwar._str_254
;
    import snowwar._str_231._SafeStr_4028;

     class _SafeStr_4023 implements _SafeStr_4022 
    {
        var _SafeStr_18669:Int = -1;
        var _SafeStr_18670:Direction8;
        var _SafeStr_18671:_SafeStr_4022;
        var _SafeStr_18672:Int = 0;
        var _SafeStr_18673:Int = 0;
        var _disposed:Bool = false;

        public function dispose()
        {
            this._SafeStr_18670 = null;
            this._SafeStr_18671 = null;
            this._SafeStr_18672 = 0;
            this._SafeStr_18673 = 0;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var _SafeStr_18665(get,set):Direction8;
public function  get__SafeStr_18665():Direction8
        {
            return this._SafeStr_18670;
        }
public function  set__SafeStr_18665(k:Direction8):Direction8        {
            return this._SafeStr_18670 = k;
        }

        
        public var _SafeStr_18666(get,set):_SafeStr_4022;
public function  get__SafeStr_18666():_SafeStr_4022
        {
            return this._SafeStr_18671;
        }
public function  set__SafeStr_18666(k:_SafeStr_4022):_SafeStr_4022        {
            return this._SafeStr_18671 = k;
        }

        
        public var _SafeStr_18668(get,set):Int;
public function  get__SafeStr_18668():Int
        {
            return this._SafeStr_18672;
        }
public function  set__SafeStr_18668(k:Int):Int        {
            return this._SafeStr_18672 = k;
        }

        
        public var _SafeStr_18667(get,set):Int;
public function  get__SafeStr_18667():Int
        {
            return this._SafeStr_18673;
        }
public function  set__SafeStr_18667(k:Int):Int        {
            return this._SafeStr_18673 = k;
        }

        public function _SafeStr_8395(k:_SafeStr_4023):Int
        {
            var _local_2= (this._SafeStr_18673 + this._SafeStr_18672);
            var _local_3= (k._SafeStr_18673 + k._SafeStr_18672);
            if (_local_2 < _local_3)
            {
                return -1;
            }
            if (_local_2 > _local_3)
            {
                return 1;
            }
            return 0;
        }

        public function distanceTo(k:_SafeStr_4022):Int
        {
            return 0;
        }

        public function directionTo(k:_SafeStr_4022):Direction8
        {
            return null;
        }

        public function getNodeAt(direction:Direction8):_SafeStr_4022
        {
            return null;
        }

        public function directionIsBlocked(direction:Direction8, _arg_2:_SafeStr_4028):Bool
        {
            return false;
        }

        public function getPathCost(direction:Direction8, _arg_2:_SafeStr_4028):Int
        {
            return 0;
        }

	public function new() {}
    }

