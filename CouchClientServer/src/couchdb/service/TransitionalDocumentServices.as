package couchdb.service {
	
	import ddgame.server.IDatabaseDocument;
	import ddgame.server.IDocumentServices;
	import couchdb.model.ITransitionalDocument;
	import com.gravityblast.couchdb.Database;
		
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  30.06.2011
	 */
	public class TransitionalDocumentServices implements IDocumentServices {
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function TransitionalDocumentServices (database:Database, amfServices:IDocumentServices)
		{
			this.database = database;
			this.amfServices = amfServices;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var database:Database;
		public var amfServices:IDocumentServices;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * 
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function load (	params:Object,
										successCallBack:Function = null,
										faultCallBack:Function = null	) : void
		{
			amfServices.load(params, successCallBack, faultCallBack);
		}
		
		public function create (data:Object = null) : IDatabaseDocument
		{
			return amfServices.create(data);
		}
		
		/**
		 * Gestion du référencement des documents CouchDB / amf
		 *	@param document IDatabaseDocument
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function save (	document:IDatabaseDocument, params:Object = null,
										successCallBack:Function = null, faultCallBack:Function = null	) : void
		{
			var castDocument:ITransitionalDocument = document as ITransitionalDocument;
			var delegate:SaveDelegate = new SaveDelegate(amfServices, castDocument, params,
																		successCallBack, faultCallBack);
			
			// Check si le document est déjà référencé
			// dans la base CouchDB
			var couchData:Object = castDocument.getCouchData();
			if (castDocument.couchId && castDocument.rev)
			{
				couchData._id = castDocument.couchId;
				couchData._rev = castDocument.rev;
			}

			database.saveDocument(couchData, delegate.handleCouchRest);
		}
		
		public function destroy (	document:IDatabaseDocument,
											successCallBack:Function = null, faultCallBack:Function = null	) : void
		{
			trace("Warning: Not implemented", this);
		}
	
	}

}

import ddgame.server.IDocumentServices;
import couchdb.model.ITransitionalDocument;
import com.gravityblast.couchdb.events.CouchRestEvent;

/**
 *	Délegation sauvegarde.
 * Réceptionne la sauvegarde CouchDB effectue la
 * mise à jour identifiant / revision du document amf
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author toffer
 */
internal class SaveDelegate {

	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------

	public function SaveDelegate (	amfServices:IDocumentServices,
												document:ITransitionalDocument, params:Object = null,
												successCallBack:Function = null, faultCallBack:Function = null	)
	{
		this.amfServices = amfServices;
		this.document = document;
		this.successCallBack = successCallBack;
		this.faultCallBack = faultCallBack;
	}

	//--------------------------------------
	//  PRIVATE VARIABLES
	//--------------------------------------

	private var amfServices:IDocumentServices;
	private var document:ITransitionalDocument;
	private var params:Object;
	private var successCallBack:Function;
	private var faultCallBack:Function;

	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------
	
	/**
	 * Réception résultat CouchDB
	 *	@param event CouchRestEvent
	 */
	public function handleCouchRest (event:CouchRestEvent) : void
	{
		if (event.json.ok)
		{
			document.couchId = event.json.id;
			document.rev = event.json.rev;
		}			
		
		amfServices.save(document, params, successCallBack, faultCallBack);
		amfServices = null;
		document = null;
		params = null;
		successCallBack = null;
		faultCallBack = null;
	}
	
	//--------------------------------------
	//  EVENT HANDLERS
	//--------------------------------------

	//--------------------------------------
	//  PRIVATE & PROTECTED INSTANCE METHODS
	//--------------------------------------

}