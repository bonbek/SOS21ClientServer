package amf.service {
	
	import com.sos21.net.Service;
	import ddgame.server.IDocumentServices;
	import amf.service.DocumentServices;

	/**
	 *	Class générique services de documents
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  29.06.2011
	 */
	public class GenericDocumentServices extends DocumentServices implements IDocumentServices {
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		public function GenericDocumentServices (	connection:Service,
																servicesName:String,
																documentModel:Class	)
		{
			super();
			this.connection = connection
			this.servicesName = servicesName;
			this.documentModel = documentModel;
			this.documentServices = this;
		}
	
	}

}

