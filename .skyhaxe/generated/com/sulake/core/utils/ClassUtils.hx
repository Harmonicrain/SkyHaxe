package com.sulake.core.utils
;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import flash.utils.*;

     class ClassUtils 
    {
        public static function implementsInterface(testedClass:Class<Dynamic>, interfaceClass:Class<Dynamic>):Bool
        {
            return ASCompat.describeType(testedClass).child("factory").child("implementsInterface").filterAttributeEquals("type", getQualifiedClassName(interfaceClass)).length() > 0;
        }

        public static function getSimpleQualifiedClassName(k:ASAny):String
        {
            var name= getQualifiedClassName(k);
            var namespaceIndex= name.indexOf("::");
            if (namespaceIndex > 0)
            {
                return name.substr((namespaceIndex + 2), name.length);
            }
            return name;
        }

	public function new() {}
    }

