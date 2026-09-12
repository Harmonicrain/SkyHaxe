package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CategoriesWithVisitorCountData implements IDisposable implements  MsgWithRequestId
    {
        var _categoryToCurrentUserCountMap:Map;
        var _categoryToMaxUserCountMap:Map;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            this._categoryToCurrentUserCountMap = new Map();
            this._categoryToMaxUserCountMap = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                _local_6 = k.readInteger();
                this._categoryToCurrentUserCountMap.add(_local_4, _local_5);
                this._categoryToMaxUserCountMap.add(_local_4, _local_6);
                _local_3++;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._categoryToCurrentUserCountMap = null;
            this._categoryToMaxUserCountMap = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var categoryToCurrentUserCountMap(get,never):Map;
public function  get_categoryToCurrentUserCountMap():Map
        {
            return this._categoryToCurrentUserCountMap;
        }

        public var categoryToMaxUserCountMap(get,never):Map;
public function  get_categoryToMaxUserCountMap():Map
        {
            return this._categoryToMaxUserCountMap;
        }
    }

