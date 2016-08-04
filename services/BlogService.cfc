 /**
  * @singleton true
  */
 component {

// CONSTRUCTOR
	/**
	 * @blogPostDao.inject         presidecms:object:blog_post
	 */
	public any function init( required any blogPostDao ) {
		_setBlogPostDao( arguments.blogPostDao );

		return this;
	}

// PUBLIC API METHODS
	public query function getFilteredBlogPosts(
		  string  parentPage			  = ""
		, array   tags  	    		  = []
		, array   postAuthors   		  = []
		, numeric maxRows       		  = 10
		, numeric startRow      		  = 1
		, boolean topPostsOnly			  = false
		, boolean mostViewed			  = false
		, boolean includeTotalRecordCount = false
	) {

		var filter 		 = "1 = 1";
		var params 		 = {};
		var selectFields = [ "distinct page.id", "page.main_image", "page.title", "blog_post.publish_date", "blog_author.name as postAuthor", "page.teaser", "page.page_views" ];
		var orderBy 	 = arguments.mostViewed ? "page.page_views DESC, blog_post.publish_date DESC" : "blog_post.publish_date DESC";

		if ( arguments.parentPage.len() ) {
			filter &= " and page.parent_page = :parentPage";
			params["parentPage"] = { value=arguments.parentPage, type="varchar" };
		}
		if ( arguments.tags.len() ) {
			filter &= " and tags.id in (:blog_tag.id)";
			params[ "blog_tag.id" ] = arguments.tags;
		}

		if ( arguments.postAuthors.len() ) {
			filter &= " and blog_author.id in (:blog_author.id)";
			params[ "blog_author.id" ] = arguments.postAuthors;
		}

		if ( arguments.topPostsOnly ) {
			filter &= " and blog_post.top_post = 1";
		}

		var q = _getBlogPostDao().selectData(
			  selectFields = selectFields
			, filter       = filter
			, filterParams = params
			, savedFilters = [ "livePages" ]
			, orderBy      = orderBy
			, maxRows      = arguments.maxRows
			, startRow     = arguments.startRow
		);

		if ( arguments.includeTotalRecordCount ) {

			// cache buster
			q = duplicate( q );

			q.addColumn( "_totalrecordcount", "integer", [] );
			var totalRecordCount = _getBlogPostDao().selectData(
				  selectFields = [ "count(distinct page.id) as rowcount" ]
				, filter       = filter
				, filterParams = params
				, savedFilters = [ "livePages" ]
			);
			loop query="q" {
				q.setCell("_totalrecordcount", totalRecordCount.rowcount, currentrow);
			}
		}

		return q;
	}

	public query function getBlogPostTags( string parentPage = "", boolean featuredOnly=false, array tags=[] ) {

		// workaround to be able to use the saved filter, otherwise page table is not joined at all
		var filter = "page.active = 1";
		var params 		 = {};

		if ( arguments.parentPage.len() ) {
			filter &= " and page.parent_page = :parentPage";
			params.parentPage = { value=arguments.parentPage, type="varchar" };
		}

		if ( arguments.featuredOnly ) {
			filter &= " and blog_tag.featured = 1"
		}

		if ( arguments.tags.len() ) {
			filter &= " and tags.id in (:blog_tag.id)";
			params[ "blog_tag.id" ] = arguments.tags;
		}

		return _getBlogPostDao().selectData(
			  selectFields = [ "distinct blog_tag.id", "blog_tag.label", "count(*) as post_count" ]
			, filter       = filter
			, filterParams = params
			, savedFilters = [ "livePages" ]
			, groupBy      = "blog_tag.id, blog_tag.label"
		);
	}

// GETTERS AND SETTERS
	private any function _getBlogPostDao() {
		return _blogPostDao;
	}
	private void function _setBlogPostDao( required any blogPostDao ) {
		_blogPostDao = arguments.blogPostDao;
	}
}