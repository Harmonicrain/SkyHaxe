package com.sulake.core.utils
{
    public class Map
    {
        private var values:Object = {};

        public function setProperty(key:*, value:*):void
        {
            values[key] = value;
        }

        public function getValue(key:*):*
        {
            return values[key];
        }
    }
}
