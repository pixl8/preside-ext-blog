component {
	private function index( event, rc, prc, args={} ) {
		prc.includeDisqus       = prc.presidePage.allow_comments ?: false;
		prc.includeAddThis      = true;

		return renderView(
			  view          = 'page-types/blog_post/index'
			, presideObject = 'blog_post'
			, id            = event.getCurrentPageId()
			, args          = args
		);
	}
}
