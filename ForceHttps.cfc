<cfcomponent mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.0,1.0.1,1.0.2,1.0.3,1.0.4,1.0.5,1.0.6,1.1,1.1.1,1.1.2,1.1.3,1.1.4,1.1.5,1.1.6,1.1.7">
		<cfreturn this>
	</cffunction>

	<cffunction name="forceHttps" hint="Call this in a controller's `init()` method to add a before filter for forcing an HTTPS connection. If the requirement is not met, this will redirect the client to the HTTPS version of the URL.">
		<cfargument name="environments" type="string" required="false" default="" hint="List of environments in which to force the HTTPS connection. This is useful if you do not have SSL configured in your design and development environments, for example. This argument is aliased as `environment` if you want to use it for readability when specifying only one environment.">
		<cfargument name="only" type="string" required="false" default="" hint="Similar to the `only` argument for `filters()`, this allows you to specify a list of actions to only run the forced HTTPS on.">
		<cfargument name="except" type="string" required="false" default="" hint="Similar to the `except` argument for `filters()`, this allows you to specify a list of actions to exclude the forced HTTPS from running on.">
		<cfscript>
			var loc = {};
			loc.componentName = $getComponentNameKey();
			loc.reloadPassword = get('reloadPassword');

			// Allow app reload to clear settings
			if (
				StructKeyExists(url, "reload") && Len(url.reload)
				&& (!Len(loc.reloadPassword) || (StructKeyExists(url, "password") && loc.reloadPassword == url.password))
			)
			{
				StructDelete(application, "forceHttps");
			}

			// Argument is also aliased as `environment` singular
			if (!Len(arguments.environments) && StructKeyExists(arguments, "environment"))
				arguments.environments = arguments.environment;

			if (!StructKeyExists(application, "forceHttps"))
				application.forceHttps = {};

			if (!StructKeyExists(application.forceHttps, loc.componentName))
				application.forceHttps[loc.componentName] = {};

			if (!StructKeyExists(application.forceHttps[loc.componentName], "environments"))
				application.forceHttps[loc.componentName].environments = arguments.environments;

			filters(through="$forceHttps", only=arguments.only, except=arguments.except);
		</cfscript>
	</cffunction>

	<cffunction name="$forceHttps" hint="FILTER: Redirects user to HTTPS connection (same URL) if required for the current environment.">
		<cfset var loc = {}>
		<cfset loc.componentName = $getComponentNameKey()>

		<cfif
			ListFind(application.forceHttps[loc.componentName].environments, get("environment"))
			and not cgi.SERVER_PORT_SECURE
		>
			<cfscript>
				loc.redirectUrl = "https://" & cgi.SERVER_NAME & cgi.PATH_INFO;

				if (Len(cgi.QUERY_STRING))
					loc.redirectUrl &= "?" & cgi.QUERY_STRING;
			</cfscript>

			<cflocation url="#loc.redirectUrl#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="$getComponentNameKey" returntype="string" hint="Returns current component name minus `controllers.`.">
		<cfreturn Replace(GetMetaData(this).name, "controllers.", "", "all")>
	</cffunction>

</cfcomponent>