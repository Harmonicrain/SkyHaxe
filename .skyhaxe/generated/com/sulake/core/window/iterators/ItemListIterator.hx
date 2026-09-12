package com.sulake.core.window.iterators
;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.components.ItemListController;
    import com.sulake.core.window.IWindow;


     class ItemListIterator implements IIterator 
    {
        var _iterable:ItemListController;

        public function new(k:ItemListController)
        {
            this._iterable = k;
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return this._iterable.numListItems;
        }

        public function indexOf(k:ASAny):Int
        {
            return this._iterable.getListItemIndex(k);
        }

        public function getProperty(k:ASAny):ASAny
        {
            return this._iterable.getListItemAt(ASCompat.toUInt(k));
        }

        public function setProperty(k:ASAny, _arg_2:ASAny)
        {
            var _local_3= ASCompat.dynamicAs(_arg_2 , IWindow);
            var _local_4= this._iterable.getListItemIndex(_local_3);
            if (_local_4 == k)
            {
                return;
            }
            if (_local_4 > -1)
            {
                this._iterable.removeListItem(_local_3);
            }
            this._iterable.addListItemAt(_local_3, ASCompat.toUInt(k));
        }

        public function nextNameIndex(k:Int):Int
        {
            return (k < this._iterable.numListItems) ? (k + 1) : 0;
        }

        public function nextValue(k:Int):ASAny
        {
            return this._iterable.getListItemAt((ASCompat.toUInt(k) - 1));
        }
    }

