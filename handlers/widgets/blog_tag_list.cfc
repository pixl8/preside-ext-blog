component {

	property name="blogService" inject="blogService";

	private function index( event, rc, prc, args={} ) {

		prc.tags = blogService.getBlogPostTags( parentPage=( args.blog ?:"invalidId" ), featuredOnly=args.featured ?: false );
		
		return renderView( view='widgets/blog_tag_list/index', args=args );
	}

	private function placeholder( event, rc, prc, args={} ) {
		return renderView( view='widgets/blog_tag_list/placeholder', args=args );
	}
}
