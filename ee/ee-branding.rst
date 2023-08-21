============
UI Branding
=============

Netmaker UI allows resellers to whitelabel and customize branding by building a custom docker image with the below environment variables set.

Open the `Dockerfile.standalone` file and set the following environment variables:

(1) **VITE_PRODUCT_NAME:** The name of the product. This is the name that will appear in the UI.
(2) **VITE_TENANT_LOGO_DARK_URL:** Logo to be used in dark mode.
(3) **VITE_TENANT_LOGO_LIGHT_URL:** Logo to be used in light mode.
(4) **VITE_TENANT_LOGO_DARK_SMALL_URL:** Small varient of logo to be used in dark mode. eg: when sidenav is collapsed (optional).
(5) **VITE_TENANT_LOGO_LIGHT_SMALL_URL:** Small varient of logo to be used in light mode. eg: when sidenav is collapsed (optional).
(6) **VITE_TENANT_LOGO_ALT_TEXT:** Alternative text for logo.
(7) **VITE_TENANT_FAVICON_LOGO:** Favicon to use in the web browser's tile bar or tab. Defaults to light logo if not specified.
(8) **VITE_TENANT_PRIMARY_COLOR:** UI primary color. Replace this with your brand color. eg: red, green, "#F00", "#00FF00" (Hex values need quoting)

You could use a URL to the respective logos or put the logos in the `/public` directory, then build the docker image.

Reference: https://github.com/gravitl/netmaker-ui-2/blob/master/Dockerfile.standalone

For more information on how to go about whitelabelling, reach out to us at https://www.netmaker.io/contact

