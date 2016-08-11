component {

    property name="blogService" inject="blogService";
    property name="sessionStorage"  inject="coldbox:plugin:sessionStorage";

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
        var addTagFilter    = rc.add_tag_filter     ?: "";
        var removeTagFilter = rc.remove_tag_filter  ?: "";
        var filterKey       = "blog_tag_filter" & event.getCurrentPageId();

        var tagFilters = sessionStorage.exists( filterKey ) ? sessionStorage.getVar( filterKey ) : [];

        if ( addTagFilter.len() && !tagFilters.containsNoCase( addTagFilter ) ) {
            tagFilters.append( addTagFilter );
        }

        if ( removeTagFilter.len() ) {
            var i = tagFilters.findNoCase( removeTagFilter );
            if ( i > 0 ) {
                tagFilters.deleteAt( i );
            }
        }

        sessionStorage.setVar( filterKey, tagFilters );

        var q = blogService.getFilteredBlogPosts(
              parentPage              = event.getCurrentPageId()
            , tags                    = tagFilters
            , maxRows                 = maxRows
            , includeTotalRecordCount = true
        );

        if ( arguments.rowgrouping > 0 ) {

            // duplicate required as otherwise the cache is manipulated
            q = duplicate( q );

            // transform so that it is easy to display in the view (it's e.g. a 2 column grid in which case each row has 2 blog post teasers)
            var rowIndex = 1;
            var colIndex = 1;

            q.addColumn("_row", "int", []);

            loop query="q" {
                q.setCell("_row", rowIndex, CurrentRow);
                colIndex++;
                if (colIndex gt arguments.rowgrouping) {
                    colIndex = 1;
                    rowIndex++;
                }
            }
        }

        prc.blogPosts = q;
        prc.filterTags = _getSessionFilterTags( event.getCurrentPageId() );
        prc.hasMore = !isEmpty( prc.blogPosts ) && prc.blogPosts._totalRecordCount > prc.blogPosts.recordCount;
    }

    private query function _getSessionFilterTags( required string blog ) {

        var filterKey  = "blog_tag_filter" & arguments.blog;
        var tagFilters = sessionStorage.exists( filterKey ) ? duplicate( sessionStorage.getVar( filterKey ) ) : [];

        if ( isEmpty( tagFilters ) ) {
            return queryNew( "dummy" );
        }

        return blogService.getBlogPostTags( parentPage=arguments.blog, tags=tagFilters );
    }
}