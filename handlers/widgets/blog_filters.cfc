component {

    property name="blogService" inject="blogService";
    property name="blogDao" inject="presidecms:object:blog";

	private function index( event, rc, prc, args={} ) {

        var blogId                 = args.blog ?: "";
        var includeAuthorFilter    = _convertBoolean( args, "include_author_filter"   );
        var includeArchiveFilter   = _convertBoolean( args, "include_archive_filter"  );
        var includeTagFilter       = _convertBoolean( args, "include_tag_filter"      );
        args.authorFilterExpanded  = _convertBoolean( args, "author_filter_expanded"  );
        args.archiveFilterExpanded = _convertBoolean( args, "archive_filter_expanded" );
        args.tagFilterExpanded     = _convertBoolean( args, "tag_filter_expanded"     );

        args.showAuthorFilter = false;
        args.showArchiveFilter = false;
        args.showTagFilter = false;

        if ( len( blogId ) ) {
            if ( includeAuthorFilter ) {
                args.blogPostAuthors = blogService.getBlogPostAuthors( parentPage=blogId );
                args.showAuthorFilter = !isEmpty( args.blogPostAuthors );
            }
            if ( includeArchiveFilter ) {
                args.blogPostArchive = blogService.getBlogPostArchive( parentPage=blogId );
                args.showArchiveFilter = !isEmpty( args.blogPostArchive );
            }
            if ( includeTagFilter ) {
                args.blogPostTags = blogService.getBlogPostTags( parentPage=blogId );
                args.showTagFilter = !isEmpty( args.blogPostTags );
            }
        }

		return renderView( view='widgets/blog_filters/index', args=args );
	}

	private function placeholder( event, rc, prc, args={} ) {

        var blog                 = blogDao.selectData( id=args.blog, selectFields=[ "page.title" ] );

        args.blogTitle           = blog.title;

        var includeAuthorFilter  = _convertBoolean( args, "include_author_filter"  );
        var includeArchiveFilter = _convertBoolean( args, "include_archive_filter" );
        var includeTagFilter     = _convertBoolean( args, "include_tag_filter"     );

        var authorFilterTitle    = args.author_filter_title  ?: "";
        var archiveFilterTitle   = args.archive_filter_title ?: "";
        var tagFilterTitle       = args.tag_filter_title     ?: "";

        var filterSections       = [];

        if ( includeAuthorFilter && len( authorFilterTitle ) ) {
            filterSections.append( authorFilterTitle );
        }

        if ( includeArchiveFilter && len( archiveFilterTitle ) ) {
            filterSections.append( archiveFilterTitle );
        }

        if ( includeTagFilter && len( tagFilterTitle ) ) {
            filterSections.append( tagFilterTitle );
        }

        args.filterSections = filterSections.toList( ", " );

		return renderView( view='widgets/blog_filters/placeholder', args=args );
	}

    private boolean function _convertBoolean( required struct args, required string key ) {
        return arguments.args.keyExists( arguments.key ) && isBoolean( arguments.args[ arguments.key ] ) && arguments.args[ arguments.key ] ? true : false;
    }
}