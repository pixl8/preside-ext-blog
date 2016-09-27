component {

    property name="blogPostDao" inject="presidecms:object:blog_post";

    private function index( event, rc, prc, args={} ) {

        prc.tags = blogPostDao.selectManyToManyData(
              propertyName = "tags"
            , selectFields = [ "distinct tags.id", "tags.label" ]
            , id           = event.getCurrentPageId()
            , orderBy      = "tags.label"
        );

        prc.includeDisqus  = prc.presidePage.allow_comments ?: false;
        prc.includeAddThis = true;

        return renderView(
              view          = 'page-types/blog_post/index'
            , presideObject = 'blog_post'
            , id            = event.getCurrentPageId()
            , args          = args
        );
    }
}
