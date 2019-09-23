component {

	public void function configure( required struct config ) {
		var conf         = arguments.config;
		var settings     = conf.settings            ?: {};
		var coldbox      = conf.coldbox             ?: {};
		var assetManager = settings.assetManager    ?: {};
		var derivatives  = assetManager.derivatives ?: {};

		derivatives.blogPostBanner = {
			  permissions = "inherit"
			, transformations = [
				  { method="Resize", args={ width=1440, height=567, maintainaspectratio=true } }
			  ]
		};

		derivatives.blogPostAuthor = {
			  permissions = "inherit"
			, transformations = [
				  { method="Resize", args={ width=81, height=81, maintainaspectratio=false } }
			  ]
		};

		derivatives.blogMainImageTeaserSmall = {
			  permissions = "inherit"
			, transformations = [
				  { method="Resize", args={ width=302, height=142, maintainaspectratio=true } }
			  ]
		};

		derivatives.blogMainImageTeaser = {
			  permissions = "inherit"
			, transformations = [
				  { method="Resize", args={ width=413, height=195, maintainaspectratio=true } }
			  ]
		};

		coldbox.modulesExternalLocation = coldbox.modulesExternalLocation ?: [];
		coldbox.modulesExternalLocation.append( "/app/extensions/preside-ext-blog/modules" )
	}
}