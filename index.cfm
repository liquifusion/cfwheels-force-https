<cfsetting enablecfoutputonly="true" />

<cfset forceHttps = {}>
<cfset forceHttps.version = "0.3">

<cfoutput>

<h1>Force HTTPS v#forceHttps.version#</h1>
<p>
	Adds support for forcing a user's connection to HTTPS if they're loading only the HTTP version of a URL.
</p>

<h2>Documentation</h2>
<p>
	See the README or the <a href="https://github.com/liquifusion/cfwheels-force-https">GitHub repo</a> for details on usage.
</p>

<h2>Credits</h2>
<p>
	Created by <a href="http://cfwheels.org/user/profile/1">Chris Peters</a> with support from
	<a href="http://liquifusion.com/">Liquifusion Studios</a>.
</p>

</cfoutput>

<cfsetting enablecfoutputonly="false">