package amf.service {
	
	import com.adobe.serialization.json.JSON;
	import com.sos21.net.Service;
	import ddgame.server.IDocumentServices;
	import ddgame.server.IDatabaseDocument;
	import amf.model.DatabaseDocument;

	/**
	 *	Class template pour IDocumentServices
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  23.06.2011
	 */
	public class DocumentServices {
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var connection:Service;
		public var servicesName:String;
		public var documentModel:Class;
		public var documentServices:IDocumentServices;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function load (	params:Object,
										successCallBack:Function = null,
										faultCallBack:Function = null	) : void
		{
			var responder:LoadResponder = new LoadResponder(documentModel, documentServices,
																			successCallBack, faultCallBack);
			connection.call(servicesName, responder, "load", params);
		}
		
		/**
		 *	@param data Object
		 *	@return IDatabaseDocument
		 */
		public function create (data:Object = null) : IDatabaseDocument
		{
			var document:DatabaseDocument = new documentModel() as DatabaseDocument;
			document.services = documentServices;
			if (data) document.setData(data);

			return document;
		}

		/**
		 *	@param document IDatabaseDocument
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function save (	document:IDatabaseDocument, params:Object = null,
										successCallBack:Function = null, faultCallBack:Function = null	) : void
		{
			var castDocument:DatabaseDocument = document as DatabaseDocument;
			if (!castDocument.id)
			{
				// On à un document qui n'est pas encore référencé
				connection.call(	servicesName,
										new CreateResponder(castDocument, successCallBack, faultCallBack),
										"create", castDocument.getBackData()	);
			}
			else
			{
				var sdata:Object = castDocument.getBackData(params);
				sdata.keys = castDocument.id;
				var responder:SaveResponder = new SaveResponder(successCallBack, faultCallBack);
				connection.call(servicesName, responder, "save", sdata);
			}
		}
		
		/**
		 * TODO
		 *	@param document IDatabaseDocument
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function destroy (	document:IDatabaseDocument,
											successCallBack:Function = null, faultCallBack:Function = null	) : void
		{
			trace("Warning: Not implemented", this);
		}
	
	}

}

