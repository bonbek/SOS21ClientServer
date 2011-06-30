package amf.service {
	
	import flash.net.Responder;
	import ddgame.server.IDocumentServices;
	import ddgame.server.IDatabaseDocument;
	import amf.model.DatabaseDocument;
	
	/**
	 *	Délegation reponse à un chargement
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  23.06.2011
	 */
	public class LoadResponder extends Responder {
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function LoadResponder (	documentModel:Class,
													services:IDocumentServices,
													successCallBack:Function = null,
													faultCallBack:Function = null )
		{
			this.documentModel = documentModel;
			this.services = services;
			this.successCallBack = successCallBack;
			this.faultCallBack = faultCallBack;
			super(onResult, onFault);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var services:IDocumentServices;
		private var documentModel:Class;
		private var successCallBack:Function;
		private var faultCallBack:Function;
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception résulat
		 *	@param result Object
		 */
		private function onResult (result:Object) : void
		{
			if (!result)
			{
				if (faultCallBack != null)
					faultCallBack.apply(null, [result]);
			}
			else
			{
				var docs:Object;
				// On à une liste de data
				if (result is Array)
				{
					docs = [];
					for each (var res:Object in result)
					{
						docs.push(createDocument(res));
					}
				}
				else {
					docs = createDocument(result);
				}

				// dispatch
				if (successCallBack != null)
					successCallBack.apply(null, [docs]);
			}
			
			documentModel = null;
			services = null;
			successCallBack = null;
			faultCallBack = null;
		}
		
		/**
		 *	@param fault Object
		 */
		private function onFault (fault:Object) : void
		{ onResult(false); }
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		protected function createDocument (data:Object) : IDatabaseDocument
		{
			var doc:DatabaseDocument = new documentModel() as DatabaseDocument;
			doc.services = this.services;
			doc.setBackData(data);
			return doc;
		}
	
	}

}

