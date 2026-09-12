package com.sulake.core.window.iterators
;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.SelectorController;
    import com.sulake.core.window.components.ISelectableWindow;


     class SelectorIterator implements IIterator 
    {
        var _iterable:SelectorController;

        public function new(k:SelectorController)
        {
            this._iterable = k;
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return this._iterable.numSelectables;
        }

        public function indexOf(k:ASAny):Int
        {
            return this._iterable.getSelectableIndex(k);
        }

        public function getProperty(k:ASAny):ASAny
        {
            return this._iterable.getChildAt(ASCompat.toInt(ASCompat.toUInt(k)));
        }

        public function setProperty(k:ASAny, _arg_2:ASAny)
        {
            var _local_4 = 0;
            var _local_3= ASCompat.dynamicAs(_arg_2 , ISelectableWindow);
            if (_local_3 != null)
            {
                _local_4 = this._iterable.getSelectableIndex(_local_3);
                if (_local_4 == k)
                {
                    return;
                }
                if (_local_4 > -1)
                {
                    this._iterable.removeSelectable(_local_3);
                }
                this._iterable.addSelectableAt(_local_3, ASCompat.toInt(ASCompat.toUInt(k)));
            }
            else
            {
                _local_4 = this._iterable.getChildIndex(_arg_2);
                if (_local_4 == k)
                {
                    return;
                }
                if (_local_4 > -1)
                {
                    this._iterable.removeChild(_local_3);
                }
                this._iterable.addChildAt(_arg_2, ASCompat.toInt(ASCompat.toUInt(k)));
            }
        }

        public function nextNameIndex(k:Int):Int
        {
            return ((k : UInt) < this._iterable.numSelectables) ? (k + 1) : 0;
        }

        public function nextValue(k:Int):ASAny
        {
            return this._iterable.getSelectableAt(ASCompat.toInt(ASCompat.toUInt(k) - 1));
        }
    }

