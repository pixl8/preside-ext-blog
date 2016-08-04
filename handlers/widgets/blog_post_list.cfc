component {

    property name="blogService" inject="blogService";

    private function index( event, rc, prc, args={} ) {

        var topPostsOnly    = args.top_posts_only    ?: false;
        var mostViewed      = args.most_viewed       ?: false;
        var showPublishDate = args.show_publish_date ?: false;
        var showAuthorName  = args.show_author_name  ?: false;
        var maxRows         = args.max_items         ?: 5;

        // TODO: find a better solution to make sure that it's always a boolean (e.g. not an empty string)
        topPostsOnly        = isBoolean( topPostsOnly ) && topPostsOnly       ? true    : false;
        mostViewed          = isBoolean( mostViewed ) && mostViewed           ? true    : false;
        showPublishDate     = isBoolean( showPublishDate ) && showPublishDate ? true    : false;
        showAuthorName      = isBoolean( showAuthorName ) && showAuthorName   ? true    : false;
        maxRows             = isValid("integer", maxRows) && maxRows > 0      ? maxRows : 5;

        prc.blogPosts = blogService.getFilteredBlogPosts(
              parentPage=args.blog ?: "invalidId"
            , topPostsOnly=topPostsOnly
            , mostViewed=mostViewed
            , maxRows=maxRows
        );

        // cache busting
        prc.blogPosts = duplicate( prc.blogPosts );

        prc.blogPosts.addColumn( "subline", "varchar", [] );

        if ( showPublishDate || showAuthorName ) {
            loop query="prc.blogPosts" {
                if ( showPublishDate && showAuthorName ) {
                    prc.blogPosts.setCell( "subline", dateFormat( publish_date, "dd mmm yyyy" ) & " - " & postAuthor, currentRow );
                }
                else if ( showPublishDate ) {
                    prc.blogPosts.setCell( "subline", dateFormat( publish_date, "dd mmm yyyy" ), currentRow );
                }
                else if ( showAuthorName ) {
                    prc.blogPosts.setCell( "subline", postAuthor, currentRow );
                }
            }
        }

        return renderView( view='widgets/blog_post_list/index', args=args );
    }

    private function placeholder( event, rc, prc, args={} ) {
        // TODO: create your handler logic here
        return renderView( view='widgets/blog_post_list/placeholder', args=args );
    }
}