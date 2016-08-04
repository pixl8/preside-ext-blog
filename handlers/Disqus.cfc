component {
    public string function comments( event, rc, prc, args={} ) {
        return renderView(
            view="general/_disqus",
            args={
                  disqusShortname=getSystemSetting( "disqus", "short_name", "" )
                , pageUrl=event.getSiteUrl( includePath=false ) & event.getCurrentUrl()
                , pageIdentifier=event.getCurrentPageId()
                , enabled=prc.includeDisqus ?: false
            }
        );
    }
}