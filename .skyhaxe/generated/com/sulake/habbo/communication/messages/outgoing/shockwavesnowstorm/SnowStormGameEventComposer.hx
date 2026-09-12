package com.sulake.habbo.communication.messages.outgoing.shockwavesnowstorm
;
    import com.sulake.core.communication.util.Byte;

     final class SnowStormGameEventComposer extends SnowStormComposerBase
    {
        public function new(instanceId:Int, sequence:Int, subtype:Int, fields:Array<ASAny> = null)
        {
            super();
            fields = fields == null ? [] : fields.copy();
            if (subtype < 0 || subtype > 4) throw new ArgumentError("Invalid SnowStorm action subtype");
            if ((subtype == 0 && fields.length != 2) || (subtype == 1 && fields.length != 2)
                || (subtype == 2 && fields.length != 3) || (subtype >= 3 && fields.length != 0))
                throw new ArgumentError("Invalid SnowStorm action fields");
            if (subtype == 1) fields[1] = new Byte(ASCompat.toInt(fields[1]));
            else if (subtype == 2) fields[2] = new Byte(ASCompat.toInt(fields[2]));
            this._message = ([instanceId, sequence, new Byte(subtype)] : Array<Dynamic>).concat(fields);
        }
    }

