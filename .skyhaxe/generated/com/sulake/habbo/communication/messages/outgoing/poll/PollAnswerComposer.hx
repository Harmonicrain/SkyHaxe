package com.sulake.habbo.communication.messages.outgoing.poll
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PollAnswerComposer implements IMessageComposer 
    {
        var _data:Array<ASAny>;

        public function new(pollId:Int, questionId:Int, answers:Array<ASAny>)
        {
            this._data = [pollId, questionId];
            this._data.push(answers.length);
            var _local_4 = 0;
            while (_local_4 < answers.length)
            {
                this._data.push(ASCompat.toString(answers[_local_4]));
                _local_4++;
            }
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = null;
        }
    }

