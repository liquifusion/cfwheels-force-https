# CFWheels Force HTTPS Plugin

Adds support for forcing a user's connection to HTTPS if they're loading only the HTTP version of a given URL.

## Usage

Call the supplied `forceHttps()` initializer method from your controller's `init()` method.

### Arguments

	forceHttps( [ string environments, string only, string except ] )

<table>
	<thead>
		<tr>
			<th>Name</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><code>environments</code></td>
			<td>string</td>
			<td>No</td>
			<td><code>[empty&nbsp;string]</code></td>
			<td>
				List of environments in which to force the HTTPS connection. This is useful if you do not have SSL
				configured in your <code>design</code> and <code>development</code> environments, for example. This
				argument is aliased as <code>environment</code> if you want to use it for readability when specifying
				only one environment.
			</td>
		</tr>
		<tr>
			<td><code>only</code></td>
			<td>string</td>
			<td>No</td>
			<td><code>[empty&nbsp;string]</code></td>
			<td>
				Similar to the <code>only</code> argument for <code>filters()</code>, this allows you to specify a list
				of actions to only run the forced HTTPS on.
			</td>
		</tr>
		<tr>
			<td><code>except</code></td>
			<td>string</td>
			<td>No</td>
			<td><code>[empty&nbsp;string]</code></td>
			<td>
				Similar to the <code>except</code> argument for <code>filters()</code>, this allows you to specify a
				list of actions to exclude the forced HTTPS from running on.
			</td>
		</tr>
	</tbody>
</table>

*Note:* This plugin stores configuration information for each controller in the `application` scope. If you change the
`environments` argument in your call to `forceHttps()`, you'll need to [reload][1] your CFWheels application to see the
changes take place.

## Examples

### Example 1: Entire app should always be loaded via HTTPS

In `controllers/Controller.cfc`, add this call:

	<cfcomponent extends="Wheels">

		<cffunction name="init">
			<cfset forceHttps()>
		</cffunction>

	</cfcomponent>

Now all other controller files that extend `Controller` will force an HTTPS connection on the client.

### Example 2: Only force HTTPS in `maintenance` and `production` environments

If we wanted HTTPS only to be enforced in our `maintenance` and `production` environments, we can use the `environments`
argument like so:

	<cfset forceHttps(environments="maintenance,production")>

### Example 3: Excluding the forced HTTPS from a given action

Let's say that we want for our `index` action in a given controller to not force HTTPS:

	<cfset forceHttps(except="index", environments="maintenance,production")>

Or perhaps we only want HTTPS to be forced on our `create` and `update` actions:

	<cfset forceHttps(only="create,update", environments="maintenance,production")>

### Example 4: Using inheritance to force HTTPS on every action unless requested otherwise from a child controller

You can add arguments to the `init()` method in your controller to allow for exceptions for your forced HTTP connection.

The file at `controllers/Controller.cfc` would look something like this:

	<cfcomponent extends="Wheels">

		<cffunction name="init">
			<cfargument name="forceHttpsExcept" type="string" required="false" default="">
			<cfargument name="forceHttpsOnly" type="string" required="false" default="">

			<cfset forceHttps(except=arguments.forceHttpsExcept, only=arguments.forceHttpsOnly, environments="maintenance,production")>
		</cffunction>

	</cfcomponent>

Then let's say, for example, that we want for the `index` action in our `main` controller to not force HTTPS. The
`main` controller would take advantage of these extra arguments when calling its parent contructor:

	<cfcomponent extends="Controller">

		<cffunction name="init">
			<cfset super.init(forceHttpsExcept="index")>
		</cffunction>

	</cfcomponent>

That way other controllers can also extend the parent constructor without having the same constraints as the `main`
controller.

Here's an example `users` controller that wouldn't pass on any exceptions:

	<cfcomponent extends="Controller">

		<cffunction name="init">
			<cfset super.init()>
		</cffunction>

	</cfcomponent>

## Credits

This plugin was created by [Chris Peters][2] with support from [Liquifusion Studios][3].

[1]: http://cfwheels.org/docs/chapter/switching-environments
[2]: http://cfwheels.org/user/profile/1
[3]: http://liquifusion.com/