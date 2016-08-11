<cfparam name="args.blogTitle" default="" />
<cfparam name="args.filterSections" default="" />

<cfscript>
    widgetTitle = translateResource( uri="widgets.blog_filters:title" );
    sectionsLabel = translateResource( uri="widgets.blog_filters:sections.label" );
    blogPagetypeName = translateResource( uri="page-types.blog:name" );

    widgetConfigurationDetails = [];

    if ( len( blogPagetypeName ) && len( args.blogTitle ) ) {
        widgetConfigurationDetails.append( blogPagetypeName & ": " & args.blogTitle );
    }

    if ( len( sectionsLabel ) && len( args.filterSections ) ) {
        widgetConfigurationDetails.append( sectionsLabel & ": " & args.filterSections );
    }

    placeholder = widgetTitle;

    if ( !isEmpty( widgetConfigurationDetails ) ) {
        placeholder &= " (" & widgetConfigurationDetails.toList( ", ") & ")";
    }
</cfscript>
<cfoutput>#placeholder#</cfoutput>