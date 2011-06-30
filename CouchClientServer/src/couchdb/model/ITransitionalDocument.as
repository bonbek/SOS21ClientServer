package couchdb.model {

	import ddgame.server.IDatabaseDocument;

	/**
	 *	Interface transition document de données couchDB
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  30.06.2011
	 */
	public interface ITransitionalDocument extends IDatabaseDocument {
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		function getCouchData () : Object;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		function get couchId () : String;
		function set couchId (val:String) : void;
		function get rev () : String;
		function set rev (val:String) : void;
	
	}

}

