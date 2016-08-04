/**
 * @allowedParentPageTypes blog
 * @allowedChildPageTypes  none
 * @showInSiteTree         false
 */
component {
    property name="postAuthor"     relationship="many-to-one"  relatedTo="blog_author"  required=true;
    property name="tags"           relationship="many-to-many" relatedTo="blog_tag" relatedvia="blog_blog_tag";

    property name="publish_date"   type="date"    dbtype="date"     required=false                  indexes="blogPostPublished";
    property name="allow_comments" type="boolean" dbtype="boolean"  required=false default=true;
    property name="top_post"       type="boolean" dbtype="boolean"  required=false default=false;
}