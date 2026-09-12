package com.hurlant.util
;
    import flash.system.System;

     class Memory 
    {
        public static function gc()
        {
ASCompat.pauseForGCIfCollectionImminent();
        }

        public static var used(get,never):UInt;
public static function  get_used():UInt
        {
            return System.totalMemory;
        }

	public function new() {}
    }

