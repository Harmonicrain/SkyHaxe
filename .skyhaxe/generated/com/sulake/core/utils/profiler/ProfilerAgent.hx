package com.sulake.core.utils.profiler
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     class ProfilerAgent extends ProfilerAgentTask implements IDisposable 
    {
        var _receiver:IUpdateReceiver;

        public function new(k:IUpdateReceiver)
        {
            this._receiver = k;
            var _local_2= getQualifiedClassName(this._receiver);
            super(_local_2.substring((_local_2.lastIndexOf(":") + 1), _local_2.length));
        }

        public var receiver(get,never):IUpdateReceiver;
public function  get_receiver():IUpdateReceiver
        {
            return this._receiver;
        }

        override public function dispose()
        {
            this._receiver = null;
            super.dispose();
        }

        public function update(k:Int)
        {
            if (!paused)
            {
                super.start();
                this._receiver.update(k);
                super.stop();
            }
        }
    }

