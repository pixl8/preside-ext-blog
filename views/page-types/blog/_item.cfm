<cfparam name="args.id" />
<cfparam name="args.title" />
<cfparam name="args.publish_date" />
<cfparam name="args.post_author" />
<cfparam name="args.teaser" />
<cfparam name="args.main_image" />
<cfparam name="args.mainImageDerivative" default="blogMainImageTeaserSmall" />

<cfscript>
    pageLink = event.buildLink( page=args.id );
</cfscript>

<cfoutput>
    <div class="articles-item">
        <div class="articles-item-image">
            <a href="#pageLink#">
                #renderAsset( assetId=args.main_image, args={ derivative=args.mainImageDerivative } )#
            </a>
        </div>
        <div class="articles-item-details">
            <h3><a href="#pageLink#">#args.title#</a></h3>
            <ul class="list-details">
                <!--- TODO: i18n date format --->
                <li>#dateFormat( args.publish_date, "dd mmm yyyy" )#</li>
                <li>#args.post_author#</li>
            </ul>
            <p>#args.teaser#</p>
        </div>
    </div>
</cfoutput>

