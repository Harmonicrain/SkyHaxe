package com.probertson.utils
;
    import flash.utils.ByteArray;

     class GZIPFile 
    {
        var _gzipFileName:String;
		var _compressedData:com.sulake.core.utils.ByteArray;
		var _headerFileName:String;
		var _headerComment:String;
		var _fileModificationTime:Date;
		var _originalFileSize:UInt = 0;

        public function new(compressedData:com.sulake.core.utils.ByteArray, 
									originalFileSize:UInt, 
									fileModificationTime:Date, 
									gzipFileName:String="", 
									headerFileName:String=null,
									headerComment:String=null)
		{
			_compressedData = compressedData;
			_originalFileSize = originalFileSize;
			_fileModificationTime = fileModificationTime;
			_gzipFileName = gzipFileName;
			_headerFileName = headerFileName;
			_headerComment = headerComment;
		}
		
		
		// ------- Public properties -------
		public var gzipFileName(get,never):String;
public function  get_gzipFileName():String
		{
			return _gzipFileName;
		}
		
		
		public var headerFileName(get,never):String;
public function  get_headerFileName():String
		{
			return _headerFileName;
		}
		
		
		public var headerComment(get,never):String;
public function  get_headerComment():String
		{
			return _headerComment;
		}
		
		
		public var fileModificationTime(get,never):Date;
public function  get_fileModificationTime():Date
		{
			return _fileModificationTime;
		}
		
		
		public var originalFileSize(get,never):UInt;
public function  get_originalFileSize():UInt
		{
			return _originalFileSize;
		}
		
		
		// ------- Public methods -------
		/**
		 * Retrieves a copy of the compressed data bytes extracted from the GZIP file.
		 * Modifications to the result ByteArray, including uncompressing, do not
		 * alter the result of future calls to this method.
		 * 
		 * @returns	A copy of the compressed data bytes contained in the ByteArray.
		 * 			Call the new XML("<code>ByteArray.inflate()</code>") method on the result
		 * 			for the uncompressed data.
		 * 
		 * @see flash.data.ByteArray#inflate()
		 */
		public function getCompressedData():com.sulake.core.utils.ByteArray
		{
			var result= new com.sulake.core.utils.ByteArray();
			_compressedData.position = 0;
			_compressedData.readBytes(result, 0, _compressedData.length);
			return result;
		}
    }

