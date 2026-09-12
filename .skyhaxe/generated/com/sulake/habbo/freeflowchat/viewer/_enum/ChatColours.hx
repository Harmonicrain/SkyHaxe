package com.sulake.habbo.freeflowchat.viewer._enum
;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.ChatStyle;

     class ChatColours 
    {
        public static final COLOUR_ARRAY:Array<ASAny> = [(["@red@", 9115929] : Array<Dynamic>), (["@cyan@", 0x7F7F] : Array<Dynamic>), (["@blue@", 19609] : Array<Dynamic>), (["@green@", 0x8000] : Array<Dynamic>), (["@purple@", 0x4C004C] : Array<Dynamic>)];

        public static function _Str_25637(Item:ChatItem, Style:ChatStyle)
        {
            var COLOUR:Array<ASAny> = null;
            final _iter_ = COLOUR_ARRAY; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
COLOUR  = _tmp_;
                if (Item.text.indexOf(COLOUR[0]) == 0)
                {
                    Style.textFormat.color = COLOUR[1];
                    Item.text = Item.text.substr(ASCompat.toInt(COLOUR[0].length));
                }
            }

            Item.text = new compat.RegExp("\\[tag\\](.*?)\\[\\/tag\\]", "g").replace(Item.text, "<font color='#ff7800'><b>$1</b></font>");
        }

	public function new() {}
    }

