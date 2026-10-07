package com.sulake.core.window.utils
;
    import com.sulake.core.utils.XMLVariableParser;
    import com.sulake.core.utils.Map;

     class XMLPropertyArrayParser extends XMLVariableParser 
    {
        public static function parse(xmlList:com.sulake.core.utils.xml.XMLList):Array<ASAny>
        {
            var values= new Map();
            var types= new Array<ASAny>();
            var properties= new Array<ASAny>();
            var variableCount= ASCompat.toInt(XMLVariableParser.parseVariableList(xmlList, values, types));
            var index = 0;
            while (index < variableCount)
            {
                properties.push(new PropertyStruct(values.getKey(index), values.getWithIndex(index), types[index], true));
                index++;
            }
            return properties;
        }

	public function new() { super(); }
    }

