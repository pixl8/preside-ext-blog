/**
 * @allowedChildPageTypes  blog_post
 */
component  {
    property name="initial_max_rows" type="numeric" dbtype="int" default="5" control="spinner";
    property name="sidebar_content" type="string" dbtype="text" required=false control="richeditor";
}