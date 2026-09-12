package adobe.serialization.json
;
     class JSONTokenizer 
    {
        final controlCharsRegExp:compat.RegExp = new compat.RegExp("[\\x00-\\x1F]");

        var strict:Bool = false;
        var obj:ASObject;
        var jsonString:String;
        var loc:Int = 0;
        var ch:String;

        public function new(s:String, strict:Bool)
        {
            this.jsonString = s;
            this.strict = strict;
            this.loc = 0;
            this.nextChar();
        }

        public function getNextToken():JSONToken
        {
            var possibleTrue:String = null;
            var possibleFalse:String = null;
            var possibleNull:String = null;
            var possibleNaN:String = null;
            var token:JSONToken = null;
            this.skipIgnored();
            switch (this.ch)
            {
                case "{":
                    token = JSONToken.create(JSONTokenType.LEFT_BRACE, this.ch);
                    this.nextChar();
                    
                case "}":
                    token = JSONToken.create(JSONTokenType.RIGHT_BRACE, this.ch);
                    this.nextChar();
                    
                case "[":
                    token = JSONToken.create(JSONTokenType.LEFT_BRACKET, this.ch);
                    this.nextChar();
                    
                case "]":
                    token = JSONToken.create(JSONTokenType.RIGHT_BRACKET, this.ch);
                    this.nextChar();
                    
                case ",":
                    token = JSONToken.create(JSONTokenType.COMMA, this.ch);
                    this.nextChar();
                    
                case ":":
                    token = JSONToken.create(JSONTokenType.COLON, this.ch);
                    this.nextChar();
                    
                case "t":
                    possibleTrue = ((("t" + this.nextChar()) + this.nextChar()) + this.nextChar());
                    if (possibleTrue == "true")
                    {
                        token = JSONToken.create(JSONTokenType.TRUE, true);
                        this.nextChar();
                    }
                    else
                    {
                        this.parseError(("Expecting 'true' but found " + possibleTrue));
                    }
                    
                case "f":
                    possibleFalse = (((("f" + this.nextChar()) + this.nextChar()) + this.nextChar()) + this.nextChar());
                    if (possibleFalse == "false")
                    {
                        token = JSONToken.create(JSONTokenType.FALSE, false);
                        this.nextChar();
                    }
                    else
                    {
                        this.parseError(("Expecting 'false' but found " + possibleFalse));
                    }
                    
                case "n":
                    possibleNull = ((("n" + this.nextChar()) + this.nextChar()) + this.nextChar());
                    if (possibleNull == "null")
                    {
                        token = JSONToken.create(JSONTokenType.NULL, null);
                        this.nextChar();
                    }
                    else
                    {
                        this.parseError(("Expecting 'null' but found " + possibleNull));
                    }
                    
                case "N":
                    possibleNaN = (("N" + this.nextChar()) + this.nextChar());
                    if (possibleNaN == "NaN")
                    {
                        token = JSONToken.create(JSONTokenType.NAN, Math.NaN);
                        this.nextChar();
                    }
                    else
                    {
                        this.parseError(("Expecting 'NaN' but found " + possibleNaN));
                    }
                    
                case '"':
                    token = this.readString();
                    
                default:
                    if ((this.isDigit(this.ch) || (this.ch == "-")))
                    {
                        token = this.readNumber();
                    }
                    else
                    {
                        if (this.ch == "")
                        {
                            token = null;
                        }
                        else
                        {
                            this.parseError((("Unexpected " + this.ch) + " encountered"));
                        }
                    }
            }
            return token;
        }

        final function readString():JSONToken
        {
            var backspaceCount = 0;
            var backspaceIndex = 0;
            var quoteIndex= this.loc;
            do 
            {
                quoteIndex = this.jsonString.indexOf('"', quoteIndex);
                if (quoteIndex >= 0)
                {
                    backspaceCount = 0;
                    backspaceIndex = (quoteIndex - 1);
                    while (this.jsonString.charAt(backspaceIndex) == "\\")
                    {
                        backspaceCount++;
                        backspaceIndex--;
                    }
                    if ((backspaceCount & 0x01) == 0)
                    {
                        break;
                    }
                    quoteIndex++;
                }
                else
                {
                    this.parseError("Unterminated string literal");
                }
            } while (true);
            var token= JSONToken.create(JSONTokenType.STRING, this.unescapeString(this.jsonString.substr(this.loc, (quoteIndex - this.loc))));
            this.loc = (quoteIndex + 1);
            this.nextChar();
            return token;
        }

        public function unescapeString(input:String):String
        {
            var nextSubstringStartPosition = 0;
            var escapedChar:String = null;
            var hexValue:String = null;
            var unicodeEndPosition = 0;
            var i = 0;
            var possibleHexChar:String = null;
            if ((this.strict && this.controlCharsRegExp.test(input)))
            {
                this.parseError("String contains unescaped control character (0x00-0x1F)");
            }
            var result= "";
            var backslashIndex = 0;
            nextSubstringStartPosition = 0;
            var len= input.length;
            do 
            {
                backslashIndex = input.indexOf("\\", nextSubstringStartPosition);
                if (backslashIndex >= 0)
                {
                    result = (result + input.substr(nextSubstringStartPosition, (backslashIndex - nextSubstringStartPosition)));
                    nextSubstringStartPosition = (backslashIndex + 2);
                    escapedChar = input.charAt((backslashIndex + 1));
                    switch (escapedChar)
                    {
                        case '"':
                            result = (result + escapedChar);
                            
                        case "\\":
                            result = (result + escapedChar);
                            
                        case "n":
                            result = (result + "\n");
                            
                        case "r":
                            result = (result + "\r");
                            
                        case "t":
                            result = (result + "\t");
                            
                        case "u":
                            hexValue = "";
                            unicodeEndPosition = (nextSubstringStartPosition + 4);
                            if (unicodeEndPosition > len)
                            {
                                this.parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
                            }
                            i = nextSubstringStartPosition;
                            while (i < unicodeEndPosition)
                            {
                                possibleHexChar = input.charAt(i);
                                if (!this.isHexDigit(possibleHexChar))
                                {
                                    this.parseError(("Excepted a hex digit, but found: " + possibleHexChar));
                                }
                                hexValue = (hexValue + possibleHexChar);
                                i++;
                            }
                            result = (result + ASCompat.stringFromCharCode(ASCompat.parseInt(hexValue, 16)));
                            nextSubstringStartPosition = unicodeEndPosition;
                            
                        case "f":
                            result = (result + "\x0C");
                            
                        case "/":
                            result = (result + "/");
                            
                        case "b":
                            result = (result + "\x08");
                            
                        default:
                            result = (result + ("\\" + escapedChar));
                    }
                }
                else
                {
                    result = (result + input.substr(nextSubstringStartPosition));
                    break;
                }
            } while (nextSubstringStartPosition < len);
            return result;
        }

        final function readNumber():JSONToken
        {
            var input= "";
            if (this.ch == "-")
            {
                input = (input + "-");
                this.nextChar();
            }
            if (!this.isDigit(this.ch))
            {
                this.parseError("Expecting a digit");
            }
            if (this.ch == "0")
            {
                input = (input + this.ch);
                this.nextChar();
                if (this.isDigit(this.ch))
                {
                    this.parseError("A digit cannot immediately follow 0");
                }
                else
                {
                    if (((!this.strict) && (this.ch == "x")))
                    {
                        input = (input + this.ch);
                        this.nextChar();
                        if (this.isHexDigit(this.ch))
                        {
                            input = (input + this.ch);
                            this.nextChar();
                        }
                        else
                        {
                            this.parseError('Number in hex format require at least one hex digit after "0x"');
                        }
                        while (this.isHexDigit(this.ch))
                        {
                            input = (input + this.ch);
                            this.nextChar();
                        }
                    }
                }
            }
            else
            {
                while (this.isDigit(this.ch))
                {
                    input = (input + this.ch);
                    this.nextChar();
                }
            }
            if (this.ch == ".")
            {
                input = (input + ".");
                this.nextChar();
                if (!this.isDigit(this.ch))
                {
                    this.parseError("Expecting a digit");
                }
                while (this.isDigit(this.ch))
                {
                    input = (input + this.ch);
                    this.nextChar();
                }
            }
            if (((this.ch == "e") || (this.ch == "E")))
            {
                input = (input + "e");
                this.nextChar();
                if (((this.ch == "+") || (this.ch == "-")))
                {
                    input = (input + this.ch);
                    this.nextChar();
                }
                if (!this.isDigit(this.ch))
                {
                    this.parseError("Scientific notation number needs exponent value");
                }
                while (this.isDigit(this.ch))
                {
                    input = (input + this.ch);
                    this.nextChar();
                }
            }
            var num= ASCompat.toNumber(input);
            if ((Math.isFinite(num) && (!Math.isNaN(num))))
            {
                return JSONToken.create(JSONTokenType.NUMBER, num);
            }
            this.parseError((("Number " + Std.string(num)) + " is not valid!"));
            return null;
        }

        final function nextChar():String
        {
            return this.ch = this.jsonString.charAt(this.loc++);
        }

        final function skipIgnored()
        {
            var originalLoc = 0;
            do 
            {
                originalLoc = this.loc;
                this.skipWhite();
                this.skipComments();
            } while (originalLoc != this.loc);
        }

        function skipComments()
        {
            if (this.ch == "/")
            {
                this.nextChar();
                switch (this.ch)
                {
                    case "/":
                        do 
                        {
                            this.nextChar();
                        } while (((!(this.ch == "\n")) && (!(this.ch == ""))));
                        this.nextChar();
                        return;
                    case "*":
                        this.nextChar();
                        while (true)
                        {
                            if (this.ch == "*")
                            {
                                this.nextChar();
                                if (this.ch == "/")
                                {
                                    this.nextChar();
                                    break;
                                }
                            }
                            else
                            {
                                this.nextChar();
                            }
                            if (this.ch == "")
                            {
                                this.parseError("Multi-line comment not closed");
                            }
                        }
                        return;
                    default:
                        this.parseError((("Unexpected " + this.ch) + " encountered (expecting '/' or '*' )"));
                }
            }
        }

        final function skipWhite()
        {
            while (this.isWhiteSpace(this.ch))
            {
                this.nextChar();
            }
        }

        final function isWhiteSpace(ch:String):Bool
        {
            if (((((ch == " ") || (ch == "\t")) || (ch == "\n")) || (ch == "\r")))
            {
                return true;
            }
            if (((!this.strict) && (ch.charCodeAt(0) == 160)))
            {
                return true;
            }
            return false;
        }

        final function isDigit(ch:String):Bool
        {
            return (ch >= "0") && (ch <= "9");
        }

        final function isHexDigit(ch:String):Bool
        {
            return (this.isDigit(ch) || ((ch >= "A") && (ch <= "F"))) || ((ch >= "a") && (ch <= "f"));
        }

        final public function parseError(message:String)
        {
            throw new JSONParseError(message, this.loc, this.jsonString);
        }
    }
//package adobe.serialization.json
