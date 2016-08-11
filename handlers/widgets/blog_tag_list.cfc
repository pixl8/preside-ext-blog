component {

	property name="blogService" inject="blogService";
    property name="blogDao" inject="presidecms:object:blog";

	private function index( event, rc, prc, args={} ) {

		args.tags = blogService.getBlogPostTags( parentPage=( args.blog ?:"invalidId" ), featuredOnly=args.featured ?: false );
		
		return renderView( view='widgets/blog_tag_list/index', args=args );
	}

	private function placeholder( event, rc, prc, args={} ) {

        var blog       = blogDao.selectData( id=args.blog, selectFields=[ "page.title" ] );
        args.blogTitle = blog.title;

		return renderView( view='widgets/blog_tag_list/placeholder', args=args );
	}
}