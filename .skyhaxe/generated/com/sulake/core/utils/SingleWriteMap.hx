package com.sulake.core.utils
;


     class SingleWriteMap extends Map 
    {
        override public function setProperty(key:ASAny, value:ASAny)
        {
            if (hasKey(key))
            {
                throw new ASError(((("Trying to overwrite value in SingleWriteMap - key: " + key) + ", value: ") + value));
            }
            super.setProperty(key, value);
        }

	public function new() { super(); }
    }

