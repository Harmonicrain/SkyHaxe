package adobe.serialization.json
;
     class JSONDecoder 
    {
        var strict:Bool = false;
        var value:ASAny;
        var tokenizer:JSONTokenizer;
        var token:JSONToken;

        public function new(s:String, strict:Bool)
        {
            this.strict = strict;
            this.tokenizer = new JSONTokenizer(s, strict);
            this.nextToken();
            this.value = this.parseValue();
            if ((strict && (!(this.nextToken() == null))))
            {
                this.tokenizer.parseError("Unexpected characters left in input stream");
            }
        }

        public function getValue():ASAny
        {
            return this.value;
        }

        final function nextToken():JSONToken
        {
            return this.token = this.tokenizer.getNextToken();
        }

        final function nextValidToken():JSONToken
        {
            this.token = this.tokenizer.getNextToken();
            this.checkValidToken();
            return this.token;
        }

        final function checkValidToken()
        {
            if (this.token == null)
            {
                this.tokenizer.parseError("Unexpected end of input");
            }
        }

        final function parseArray():Array<ASAny>
        {
            var a= new Array<ASAny>();
            this.nextValidToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACKET)
            {
                return a;
            }
            if (((!this.strict) && (this.token.type == JSONTokenType.COMMA)))
            {
                this.nextValidToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    return a;
                }
                this.tokenizer.parseError(("Leading commas are not supported.  Expecting ']' but found " + this.token.value));
            }
            while (true)
            {
                a.push(this.parseValue());
                this.nextValidToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    return a;
                }
                if (this.token.type == JSONTokenType.COMMA)
                {
                    this.nextToken();
                    if (!this.strict)
                    {
                        this.checkValidToken();
                        if (this.token.type == JSONTokenType.RIGHT_BRACKET)
                        {
                            return a;
                        }
                    }
                }
                else
                {
                    this.tokenizer.parseError(("Expecting ] or , but found " + this.token.value));
                }
            }
            return null; //dead code
        }

        final function parseObject():ASObject
        {
            var key:String;
            var o:ASObject = new ASObject();
            this.nextValidToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACE)
            {
                return o;
            }
            if (((!this.strict) && (this.token.type == JSONTokenType.COMMA)))
            {
                this.nextValidToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACE)
                {
                    return o;
                }
                this.tokenizer.parseError(("Leading commas are not supported.  Expecting '}' but found " + this.token.value));
            }
            while (true)
            {
                if (this.token.type == JSONTokenType.STRING)
                {
                    key = ASCompat.toString(this.token.value);
                    this.nextValidToken();
                    if (this.token.type == JSONTokenType.COLON)
                    {
                        this.nextToken();
                        o[key] = this.parseValue();
                        this.nextValidToken();
                        if (this.token.type == JSONTokenType.RIGHT_BRACE)
                        {
                            return o;
                        }
                        if (this.token.type == JSONTokenType.COMMA)
                        {
                            this.nextToken();
                            if (!this.strict)
                            {
                                this.checkValidToken();
                                if (this.token.type == JSONTokenType.RIGHT_BRACE)
                                {
                                    return o;
                                }
                            }
                        }
                        else
                        {
                            this.tokenizer.parseError(("Expecting } or , but found " + this.token.value));
                        }
                    }
                    else
                    {
                        this.tokenizer.parseError(("Expecting : but found " + this.token.value));
                    }
                }
                else
                {
                    this.tokenizer.parseError(("Expecting string but found " + this.token.value));
                }
            }
            return null; //dead code
        }

        final function parseValue():ASObject
        {
            this.checkValidToken();
            switch (this.token.type)
            {
                case JSONTokenType.LEFT_BRACE:
                    return this.parseObject();
                case JSONTokenType.LEFT_BRACKET:
                    return this.parseArray();
                case JSONTokenType.STRING
                   | JSONTokenType.NUMBER
                   | JSONTokenType.TRUE
                   | JSONTokenType.FALSE
                   | JSONTokenType.NULL:
                    return this.token.value;
                case JSONTokenType.NAN:
                    if (!this.strict)
                    {
                        return this.token.value;
                    }
                    this.tokenizer.parseError(("Unexpected " + this.token.value));
                    return null;
                default:
                    this.tokenizer.parseError(("Unexpected " + this.token.value));
            }
            return null;
        }
    }
//package adobe.serialization.json
