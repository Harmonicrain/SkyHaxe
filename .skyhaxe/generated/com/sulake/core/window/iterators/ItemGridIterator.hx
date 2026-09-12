package com.sulake.core.window.iterators
;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.ItemGridController;
    import com.sulake.core.window.IWindow;


     class ItemGridIterator implements IIterator 
    {
        var _iterable:ItemGridController;

        public function new(k:ItemGridController)
        {
            this._iterable = k;
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return this._iterable.numGridItems;
        }

        public function indexOf(k:ASAny):Int
        {
            return this._iterable.getGridItemIndex(k);
        }

        public function getProperty(k:ASAny):ASAny
        {
            return this._iterable.getGridItemAt(ASCompat.toUInt(k));
        }

        public function setProperty(k:ASAny, _arg_2:ASAny)
        {
            var _local_3= ASCompat.dynamicAs(_arg_2 , IWindow);
            var _local_4= this._iterable.getGridItemIndex(_local_3);
            if (_local_4 == k)
            {
                return;
            }
            if (_local_4 > -1)
            {
                this._iterable.removeGridItem(_local_3);
            }
            this._iterable.addGridItemAt(_local_3, ASCompat.toUInt(k));
        }

        public function nextNameIndex(k:Int):Int
        {
            return ((k : UInt) < this._iterable.numGridItems) ? (k + 1) : 0;
        }

        public function nextValue(k:Int):ASAny
        {
            return this._iterable.getGridItemAt((ASCompat.toUInt(k) - 1));
        }
    }

