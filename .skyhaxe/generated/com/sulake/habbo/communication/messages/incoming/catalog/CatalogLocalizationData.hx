package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CatalogLocalizationData
    {
        var _images:Array<ASAny>;
        var _texts:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._images = new Array<ASAny>();
            this._texts = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._images.push(k.readString());
                _local_3++;
            }
            var _local_4= k.readInteger();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                this._texts.push(k.readString());
                _local_5++;
            }
        }

        public var images(get,never):Array<ASAny>;
public function  get_images():Array<ASAny>
        {
            return this._images;
        }

        public var texts(get,never):Array<ASAny>;
public function  get_texts():Array<ASAny>
        {
            return this._texts;
        }
    }

