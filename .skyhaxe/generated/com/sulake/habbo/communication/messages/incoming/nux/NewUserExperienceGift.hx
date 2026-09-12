package com.sulake.habbo.communication.messages.incoming.nux
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NewUserExperienceGift 
    {
        var _productOfferList:Vector<NewUserExperienceGiftProduct>;
        var _thumbnailUrl:String;

        public function new(k:IMessageDataWrapper)
        {
            this._thumbnailUrl = k.readString();
            if (this._thumbnailUrl == "")
            {
                this._thumbnailUrl = null;
            }
            this._productOfferList = new Vector<NewUserExperienceGiftProduct>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._productOfferList.push(new NewUserExperienceGiftProduct(k));
                _local_3++;
            }
        }

        public var _Str_13979(get,never):Vector<NewUserExperienceGiftProduct>;
public function  get__Str_13979():Vector<NewUserExperienceGiftProduct>
        {
            return this._productOfferList;
        }

        public var roomTemplateName(get,never):String;
public function  get_roomTemplateName():String
        {
            return this._thumbnailUrl;
        }
    }

