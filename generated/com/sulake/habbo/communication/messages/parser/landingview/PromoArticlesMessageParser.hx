package com.sulake.habbo.communication.messages.parser.landingview
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.landingview.PromoArticleData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PromoArticlesMessageParser implements IMessageParser
    {
        var _articles:Array<ASAny>;


        public var articles(get,never):Array<ASAny>;
function  get_articles():Array<ASAny>
        {
            return this._articles;
        }

        public function flush():Bool
        {
            this._articles = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._articles.push(new PromoArticleData(k));
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

