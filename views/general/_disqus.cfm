<cfparam name="args.enabled" default="false" />
<cfparam name="args.disqusShortname" default="" />
<cfparam name="args.pageUrl" default="" />
<cfparam name="args.pageIdentifier" default="" />

<cfif args.enabled && args.disqusShortname.len() && args.pageUrl.len() && args.pageIdentifier.len()>
    <cfoutput>
        <script>
            var disqus_config = function () {
                this.page.url = '#args.pageUrl#';
                this.page.identifier = '#args.pageIdentifier#';
            };
            (function() {
            var d = document, s = d.createElement('script');

            s.src = '//#args.disqusShortname#.disqus.com/embed.js';

            s.setAttribute('data-timestamp', +new Date());
            (d.head || d.body).appendChild(s);
            })();
        </script>
        <script id="dsq-count-scr" src="//#args.disqusShortname#.disqus.com/count.js" async></script>
        <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
    </cfoutput>
</cfif>