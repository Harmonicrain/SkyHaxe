package com.sulake.habbo.freeflowchat.viewer._enum
;
     class ChatMarkup
    {
        public static final COLOUR_ARRAY:Array<ASAny> = [(["red", 9115929] : Array<Dynamic>), (["cyan", 32639] : Array<Dynamic>), (["blue", 19609] : Array<Dynamic>), (["green", 32768] : Array<Dynamic>), (["purple", 4980812] : Array<Dynamic>)];
        static final WHITE_TEXT_COLOUR_ARRAY:Array<ASAny> = [(["red", 16738922] : Array<Dynamic>), (["cyan", 5233370] : Array<Dynamic>), (["blue", 6269183] : Array<Dynamic>), (["green", 6738794] : Array<Dynamic>), (["purple", 11767039] : Array<Dynamic>)];
        public static final COLOUR_NAMES:Array<ASAny> = (function():Array<ASAny>
        {
            var names:Array<ASAny> = [];
            var entry:Array<ASAny>;
            final _iter_ = COLOUR_ARRAY; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
                names.push(entry[0]);
            }
            return names;
        })();

        public function new()
        {
        }

        static function getColourArray(baseColour:UInt):Array<ASAny>
        {
            return baseColour == 0xFFFFFF ? WHITE_TEXT_COLOUR_ARRAY : COLOUR_ARRAY;
        }

        static function getHexColorForTag(tag:String, baseColour:UInt):String
        {
            var entry:Array<ASAny> = null;
            final _iter_ = getColourArray(baseColour); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
                if (entry[0] == tag)
                {
                    return "#" + (entry[1].toString(16) : ASAny).toUpperCase();
                }
            }
            return null;
        }

        public static function applyColourToChat(text:String, baseColour:UInt):String
        {
            var entry:Array<ASAny> = null;
            var hex:String = null;
            var body:String = null;
            final _iter_ = getColourArray(baseColour); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
                if (text.indexOf("@" + entry[0] + "@") == 0)
                {
                    hex = "#" + (entry[1].toString(16) : ASAny).toUpperCase();
                    body = text.substring(ASCompat.toInt(entry[0].length + 2), text.length);
                    if (body.charAt(0) == " ")
                    {
                        body = body.substr(1);
                    }
                    return "<font color=\"" + hex + "\">" + body + "</font>";
                }
            }
            return text;
        }

        public static function tokenize(text:String):Array<ASAny>
        {
var             i = 0;            var result:Array<ASAny> = [];
            var token= "";
            var insideTag= false;
            var i = 0;
            var ch:String = null;
            i= 0;while (i < text.length)
            {
                ch = text.charAt(i);
                if (ch == "[")
                {
                    if (token.length > 0)
                    {
                        result.push(token);
                        token = "";
                    }
                    insideTag = true;
                    token += ch;
                }
                else if (((ch == "]") && insideTag))
                {
                    token += ch;
                    result.push(token);
                    token = "";
                    insideTag = false;
                }
                else
                {
                    token += ch;
                }
i++;
            }
            if (token.length > 0)
            {
                result.push(token);
            }
            return result;
        }

        public static function applyToElements(text:String, baseColour:UInt):String
        {
var             i = 0;            var i = 0;
            var token:String = null;
            var tag:String = null;
            var closing = false;
            var open:ASObject = null;
            var hex:String = null;
            if (text.length == 0)
            {
                return "";
            }
            var tokens= tokenize(text);
            var stack:Array<ASAny> = [];
            i= 0;while (i < tokens.length)
            {
                token = tokens[i];
                if (((token.charAt(0) == "[") && (token.charAt(token.length - 1) == "]") && ((token.charAt(1) == "/") || ((token.length > 2) && (token.length <= 10)))))
                {
                    tag = token.substring(1, token.length - 1).toLowerCase();
                    closing = tag.charAt(0) == "/";
                    if (closing)
                    {
                        tag = tag.substr(1);
                        if (((stack.length > 0) && (stack[(stack.length - 1)].tag == tag)))
                        {
                            open = stack.pop();
                            if ((((tag == "b") || (tag == "i")) || (tag == "u")))
                            {
                                tokens[ASCompat.toInt(open.index)] = "<" + tag + ">";
                                tokens[i] = "</" + tag + ">";
                            }
                            else
                            {
                                hex = getHexColorForTag(tag, baseColour);
                                if (hex != null)
                                {
                                    tokens[ASCompat.toInt(open.index)] = "<font color=\"" + hex + "\">";
                                    tokens[i] = "</font>";
                                }
                            }
                        }
                    }
                    else if (((((tag == "b") || (tag == "i")) || (tag == "u")) || (COLOUR_NAMES.indexOf(tag) != -1)))
                    {
                        stack.push({tag:tag, index:i});
                    }
                }
i++;
            }
            return tokens.join("");
        }
    }

