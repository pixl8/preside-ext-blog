component {

    property name="blogService" inject="blogService";
    property name="blogFilters" inject="blogFilters";

    private function index( event, rc, prc, args={} ) {

        _getBlogPosts( event=event, rc=rc, prc=prc );

        return renderView(
              view          = 'page-types/blog/index'
            , presideObject = 'blog'
            , id            = event.getCurrentPageId()
            , args          = args
        );
    }

    private function twocol( event, rc, prc, args={} ) {

        _getBlogPosts( event=event, rc=rc, prc=prc, rowgrouping=2 );
        
        return renderView(
              view          = 'page-types/blog/twocol'
            , presideObject = 'blog'
            , id            = event.getCurrentPageId()
            , args          = args
        );
    }

    private void function _getBlogPosts( event, rc, prc, numeric rowgrouping=0 ) {

        var blog            = prc.presidePage       ?: {};
        var initialMaxRows  = blog.initial_max_rows ?: 10;
        var maxRows         = rc.maxRows            ?: initialMaxRows;
        var blogId          = event.getCurrentPageId();

        blogFilters.manage(
              blogId = blogId
            , action = rc.filterAction ?: ""
            , type   = rc.filterType   ?: ""
            , value  = rc.filterValue  ?: ""
        );

        var q = blogService.getFilteredBlogPosts(
              parentPage              = blogId
            , tags                    = blogFilters.getTagFilterIds( blogId )
            , postAuthors             = blogFilters.getAuthorFilterIds( blogId )
            , archives                = blogFilters.getArchiveFilterKeys( blogId )
            , maxRows                 = maxRows
            , includeTotalRecordCount = true
        );

        prc.blogPosts      = _handleRowGrouping( q, arguments.rowgrouping );
        prc.tagFilters     = blogFilters.getTagFilters( blogId );
        prc.authorFilters  = blogFilters.getAuthorFilters( blogId );
        prc.archiveFilters = blogFilters.getArchiveFilters( blogId );
        prc.hasMore        = !isEmpty( prc.blogPosts ) && prc.blogPosts._totalRecordCount > prc.blogPosts.recordCount;
    }

    private query function _handleRowGrouping( required query q, required numeric rowGrouping ) {

        if ( arguments.rowGrouping <= 0 ) {
            return q;
        }

        // duplicate required as otherwise the cache is manipulated
        var result = duplicate( arguments.q );

        // transform so that it is easy to display in the view (it's e.g. a 2 column grid in which case each row has 2 blog post teasers)
        var rowIndex = 1;
        var colIndex = 1;

        result.addColumn( "_row", "int", [] );

        loop query="result" {
            result.setCell( "_row", rowIndex, CurrentRow );
            colIndex++;
            if ( colIndex > arguments.rowgrouping ) {
                colIndex = 1;
                rowIndex++;
            }
        }

        return result;
    }
}