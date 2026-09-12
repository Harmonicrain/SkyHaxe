package com.sulake.core.window.iterators
;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.IWindow;


     class ContainerIterator implements IIterator 
    {
        var _iterable:WindowController;

        public function new(k:WindowController)
        {
            this._iterable = k;
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return this._iterable.numChildren;
        }

        public function indexOf(k:ASAny):Int
        {
            return this._iterable.getChildIndex(k);
        }

        public function getProperty(k:ASAny):ASAny
        {
            return this._iterable.getChildAt(ASCompat.toInt(ASCompat.toUInt(k)));
        }

        public function setProperty(k:ASAny, _arg_2:ASAny)
        {
            var _local_3= ASCompat.dynamicAs(_arg_2 , IWindow);
            var _local_4= this._iterable.getChildIndex(_local_3);
            if (_local_4 == k)
            {
                return;
            }
            if (_local_4 > -1)
            {
                this._iterable.removeChild(_local_3);
            }
            this._iterable.addChildAt(_local_3, ASCompat.toInt(ASCompat.toUInt(k)));
        }

        public function nextNameIndex(k:Int):Int
        {
            return (k < this._iterable.numChildren) ? (k + 1) : 0;
        }

        public function nextValue(k:Int):ASAny
        {
            return this._iterable.getChildAt(ASCompat.toInt(ASCompat.toUInt(k) - 1));
        }
    }

