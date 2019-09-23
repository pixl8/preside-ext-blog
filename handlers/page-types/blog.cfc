component {

    property name="blogService" inject="blogService";
    property name="blogFilters" inject="blogFilters";
    property name="siteTreeService" inject="siteTreeService";
    property name="feedGenerator"   inject="feedGenerator@cbfeeds";

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

    public any function rss( event, rc, prc, args={} ) {

        var blogId = rc.blogId ?: event.getCurrentPageId();

        var blogListingPage = siteTreeService.getPage(
              id           = blogId
            , selectFields = ["page.title","page.id","page.teaser"]
        );

        var blogPosts = blogService.getFilteredBlogPosts( parentPage=blogId );

        var blogFeed          = {};
        blogFeed.title        = XmlFormat( blogListingPage.title );
        blogFeed.link         = event.buildLink( page = blogListingPage.id );
        blogFeed.description  = XmlFormat( blogListingPage.teaser );
        blogFeed.atomSelfLink = event.buildLink( linkTo = 'page-types.blog.rss', queryString='blogId=#blogId#' );
        blogFeed.items        = queryNew( 'title,link,pubdate,content_encoded,description' );

        for ( var blogPost in blogPosts ) {

            blogFeed.items.addRow();
            blogFeed.items.setCell( "title"           , XmlFormat( blogPost.title )           );
            blogFeed.items.setCell( "link"            , event.buildLink( page = blogPost.id ) );
            blogFeed.items.setCell( "pubdate"         , blogPost.publish_date                 );
            blogFeed.items.setCell( "content_encoded" , UrlEncodedFormat( blogPost.teaser )   );
            blogFeed.items.setCell( "description"     , XmlFormat( blogPost.teaser )          );
        }

        var blogFeedSyndication = feedGenerator.createFeed( feedStruct=blogFeed );

        event.renderData( type="plain", data=blogFeedSyndication, contentType="text/xml" );
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