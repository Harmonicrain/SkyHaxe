package com.sulake.core.window.iterators
;
    import com.sulake.core.window.utils.IIterator;


     class EmptyIterator implements IIterator 
    {
        public static final INSTANCE:EmptyIterator = Type.createInstance(EmptyIterator, []);


        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return 0;
        }

        public function indexOf(k:ASAny):Int
        {
            return -1;
        }

        public function getProperty(k:ASAny):ASAny
        {
            return null;
        }

        public function setProperty(k:ASAny, _arg_2:ASAny)
        {
        }

        public function nextNameIndex(k:Int):Int
        {
            return 0;
        }

        public function nextValue(k:Int):ASAny
        {
            return null;
        }

	public function new() {}
    }

