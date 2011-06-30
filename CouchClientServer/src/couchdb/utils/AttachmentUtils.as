package couchdb.utils {

	import flash.events.*;
	import flash.utils.ByteArray;
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
	 *	@since  05.04.2011
	 */
	public class AttachmentUtils extends EventDispatcher {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const QUEUE_COMPLETE:String = "queueComplete";
		public static const DATA_UPDATED:String = "dataUpdated";
		public static const DATA_FAULT:String = "dataFault";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function AttachmentUtils ()
		{ super(); }
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var attachmentQueue:Array;
		private var loader:BulkLoader;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Empile des data de CouchAttachment à updater
		 *	@param attachment CouchAttachment
		 *	@param sourceFile url du fichier source qui serira les data
		 */
		public function queueData (attachment:CouchAttachment, sourceFile:String) : void
		{
			if (!attachmentQueue) attachmentQueue = [];
			if (!loader) loader = BulkLoader.createUniqueNamedLoader();
	
			loader.add(sourceFile, {id:attachment.fileName, type:BulkLoader.TYPE_BINARY});
			attachmentQueue.push(attachment);
		}
		
		/**
		 * Supprime des data de CouchAttachment à updater
		 *	@param attachment CouchAttachment
		 */
		public function unQueue (attachment:CouchAttachment) : void
		{
			if (!loader) return;
			
			if (loader.get(attachment.fileName))
			{
				attachmentQueue.splice(attachmentQueue.indexOf(attachment), 1);
				loader.remove(attachment.fileName);
			}
		}
		
		/**
		 * Flag data du CouchAttachment sont empilées pour update
		 *	@param attachment CouchAttachment
		 *	@return Boolean
		 */
		public function isQueued (attachment:CouchAttachment) : Boolean
		{ return attachmentQueue.indexOf(attachment) > -1; }
		
		/**
		 *	Lance la mise à jour des data CouchAttachment empilées
		 */
		public function processQueue () : void
		{
			if (loader.items.length > 0)
			{
				loader.addEventListener(Event.COMPLETE, onSourcesLoaded)
				loader.addEventListener(ErrorEvent.ERROR, onSourcesLoadedFault);
				loader.start();
			}
			else {
				// dispatchEvent(new )
				attachmentQueue = null;
			}
		}
		
		/**
		 * TODO documenter
		 */
		public static function createAttachment (fileName:String, sourceFile:String) : CouchAttachment
		{
			var fileExt:String = AttachmentUtils.findExtension(sourceFile);
			var contentType:String = AttachmentUtils.findContentType(sourceFile)
			
			if (!fileExt || !contentType)
				return null;			

			return new CouchAttachment(fileName, contentType);
		}
		
		/**
		 * Change le type d'un CouchAttachment depuis
		 * une url de fichier. Effectue les modifications sur l'extension et le content-type
		 * Ex :
		 * 	myAttachment{fileName:image.jpg, contentType:image/jpg}
		 * 	changeType(myAttachment, "images/newImage.png")
		 * 	> myAttachment{fileName:image.png, contentType:image/png}
		 *	@param attachment CouchAttachment
		 *	@param sourceFile String
		 */
		public static function changeType (attachment:CouchAttachment, sourceFile:String) : void
		{
			// Chagement d'extension du nom du fichier
			var fileName:String = attachment.fileName;
			attachment.fileName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + findExtension(sourceFile);
			// Chagement du content-type
			attachment.contentType = findContentType(sourceFile);
		}
		
		/**
		 * Retourne le content-type depuis une url fichier complete ou une
		 * extension. Ex : dossier/monFichier.png, ou .png ou png
		 * @param	source	 l'url du fichier ou extension
		 */
		public static function findContentType (source:String) : String
		{
			var ext:String = AttachmentUtils.findExtension(source);
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
			
			return contentType;
		}
		
		/**
		 * Retourne l'extension d'un fichier depuis son url
		 * @param	source	 l'url du fichier
		 */
		public static function findExtension (source:String) : String
		{
			return  source.substring((source.lastIndexOf(".") + 1)).toLowerCase();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@param event Event
		 */
		protected function onSourcesLoaded (event:Event) : void
		{
			loader.removeEventListener(Event.COMPLETE, onSourcesLoaded);
			loader.removeEventListener(ErrorEvent.ERROR, onSourcesLoadedFault);

			for each (var attachment:CouchAttachment in attachmentQueue)
			{
				var item:LoadingItem = loader.get(attachment.fileName);
 				attachment.contentType = AttachmentUtils.findContentType(item.url.url);
				var bytes:ByteArray = loader.getBinary(attachment.fileName, true);
				bytes.position = 0;
				attachment.data = bytes;
			}

			loader.clear();
			loader = null;
			dispatchEvent(new CouchEvent(AttachmentUtils.QUEUE_COMPLETE, attachmentQueue));
		}
		
		/**
		 *	@param event ErrorEvent
		 */
		private function onSourcesLoadedFault (event:ErrorEvent) : void
		{
			var failed:Array = loader.getFailedItems();
			var failedAttachment:Array = [];
			for each (var item:LoadingItem in failed)
			{
				for each (var attachment:CouchAttachment in attachmentQueue)
				{
					if (attachment.fileName == item.id) {
						dispatchEvent(new CouchEvent(AttachmentUtils.DATA_FAULT, attachment));
						failedAttachment.push(attachment);
					}
				}
			}
			// Suppression des attachments fautifs
			for each (attachment in failedAttachment)
				attachmentQueue.splice(attachmentQueue.indexOf(attachment), 1);

			loader.removeFailedItems();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

