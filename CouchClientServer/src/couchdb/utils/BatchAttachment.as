package couchdb.utils {
	
	import flash.events.*;
	import flash.utils.ByteArray;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import br.com.stimuli.loading.*;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import com.custardbelly.as3couchdb.core.*;
	import com.custardbelly.as3couchdb.event.CouchEvent;
	import com.custardbelly.as3couchdb.core.CouchServiceFault;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  24.03.2011
	 */
	public class BatchAttachment {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CREATE:String = "attachmentsCreate";
		public static const FAULT:String = "attachmentsFault";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		function BatchAttachment (document:CouchDocument) : void
		{
			this.document = document;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var document:CouchDocument;
		protected var loader:BulkLoader;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		protected function get attachments () : Vector.<CouchAttachment>
		{ return document.attachments; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Créé une liste d'attachments
		 *	@param descriptor Array
		 */
		public function createFromDescriptor (descriptor:Array) : void
		{
			loader = BulkLoader.createUniqueNamedLoader();
			document.attachments = new Vector.<CouchAttachment>();
			var attachment:CouchAttachment;
			for each (var des:Object in descriptor)
			{
				attachment = createAttachment(des.fileName, des.source);
				loader.add(des.source, {id:attachment.fileName, type:BulkLoader.TYPE_BINARY});
				attachments.push(attachment);				
			}
			
			if (loader.items.length > 0)
			{
				loader.addEventListener(Event.COMPLETE, onAttachementSourcesLoaded)
				loader.addEventListener(ErrorEvent.ERROR, onAttachementSourcesLoadedFault);
				loader.start();
			}
		}
		
		/**
		 *	@param fileName String
		 *	@param source String
		 *	@return CouchAttachment
		 */
		public function createAttachment (fileName:String, source:String) : CouchAttachment
		{
			// Recup de l'extension
			var ext:String = source.substring((source.lastIndexOf(".") + 1), source.length).toLowerCase();
			var contentType:String;
			switch (ext)
			{
				case "jpg" :
					contentType = "image/jpg";
					break;
				case "png" :
					contentType = "image/png";			
					break;
				case "swf" :
					contentType = "application/x-shockwave-flash";
					break;
				case "mp3" :
					contentType = "audio/mpeg";
					break;
			}

			return new CouchAttachment(fileName + "." + ext, contentType);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@param event Event
		 */
		protected function onAttachementSourcesLoaded (event:Event) : void
		{
			loader.removeEventListener(Event.COMPLETE, onAttachementSourcesLoaded);
			loader.removeEventListener(ErrorEvent.ERROR, onAttachementSourcesLoadedFault);

			for each (var attachment:CouchAttachment in attachments)
			{
				var bytes:ByteArray = loader.getBinary(attachment.fileName, true);
				bytes.position = 0;
				attachment.data = bytes;
			}

			loader.clear();
			loader = null;
			document.dispatchEvent( new CouchEvent( BatchAttachment.CREATE, null ) );
		}
		
		/**
		 *	@param event ErrorEvent
		 */
		private function onAttachementSourcesLoadedFault (event:ErrorEvent) : void
		{
			var failed:Array = loader.getFailedItems();
			var failedAttachment:Array = [];
			for each (var item:LoadingItem in failed)
			{
				for each (var attachment:CouchAttachment in attachments)
				{
					if (attachment.fileName == item.id) {
						var faultMsg:String = "Can't create attachment " + attachment.fileName + " with source file " + item.url.url;
						document.dispatchEvent( new CouchEvent( BatchAttachment.FAULT, new CouchServiceFault("FAULT", 200, faultMsg) ) );
						failedAttachment.push(attachment);
					}
				}
			}
			// Suppression des attachments fautifs
			for each (attachment in failedAttachment)
				attachments.splice(attachments.indexOf(attachment), 1);

			loader.removeFailedItems();

			if (attachments.length == 0)
			{
				loader.removeEventListener(Event.COMPLETE, onAttachementSourcesLoaded);
				loader.removeEventListener(ErrorEvent.ERROR, onAttachementSourcesLoadedFault);
				loader.clear();
				loader = null;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

