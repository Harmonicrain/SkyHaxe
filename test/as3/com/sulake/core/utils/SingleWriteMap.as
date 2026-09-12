package com.sulake.core.utils
{
    public class SingleWriteMap extends Map
    {
        override public function setProperty(key:*, value:*):void
        {
            if (getValue(key) != null)
            {
                throw new Error("overwrite");
            }
            super.setProperty(key, value);
        }
    }
}
