========================================
User Management in Netmaker Professional
========================================

Since v0.25.0, the User Management feature is designed to streamline the administration of user roles, permissions, and access levels within a platform.
This robust system allows super admins to create and manage user accounts with varying levels of access, ensuring that each user has the appropriate permissions to perform their tasks effectively.
The feature supports multiple user types, including super admins, admins, service users, and platform users, each with distinct capabilities tailored to their roles within the organization.

At its core, the User Management feature enables the creation of user accounts through both invitation and direct addition methods.
Super admins can assign Platform Access Levels (PAL) to users, determining their access to various functionalities across the platform.
For instance, admins can manage user roles, invite new users, and oversee network configurations, while service users are limited to specific tasks without dashboard access, focusing instead on remote access via the RAC app.
This hierarchical structure promotes security and efficiency, allowing organizations to maintain control over their user base while facilitating collaboration.

Additionally, the feature includes functionalities for managing network roles and groups, enhancing the granularity of access control.
Admins can create network-specific roles and assign them to users, ensuring that they only have access to the resources necessary for their work.
Groups can be formed to bundle roles, simplifying the management of permissions for multiple users at once.
This flexibility is crucial for organizations with diverse teams and projects, as it allows for a tailored approach to user management that can adapt to changing needs and workflows.


Here is a breakdown of the different user types and their permissions (platform access levels):

- Super Admin: Possesses complete control over the platform, including creating and managing all other user types and their permissions.
- Admin: Has significant privileges to manage user accounts, assign roles, and oversee network configurations, but with limitations compared to the Super Admin (eg: cannot create other admins).
- Platform User: Has access to the dashboard and can interact with assigned resources based on granted permissions, suitable for team members needing specific functionalities.
- Service User: Designed for operational tasks without dashboard access, with permissions adjustable by Super Admins or Admins. The classic use case for this user type is remote access via the RAC app.


Adding users
============

There are two ways to create a user:

1. **Basic Auth:** Fill in the user's details and click **Create User**.
2. **User Invite:** Enter the different email addresses of the users you want to invite. They will receive an email with a link to create their account (Ensure you have set up the SMTP client for emailing).


Basic Auth
-----------

This method is more suited for creating individual users directly. The admin just types a username and password for the user, then specifies any group or additional custom roles they should have.

.. image:: /images/usr-mgmt/create-user-modal-groups.png
   :width: 80%
   :alt: create user basic auth
   :align: center


.. image:: /images/usr-mgmt/create-user-modal-custom-roles.png
   :width: 80%
   :alt: create user basic auth
   :align: center


User Invite
-------------

This method is more suited for inviting multiple users at once. The admin types in the email addresses of the users they want to invite, then specifies any group or additional custom roles they should have.

Users will receive an email with a link to create their account. They will have whatever roles and groups the admin assigned to them during the invite process.
Ensure you have set up the SMTP client config for emailing.

.. image:: /images/usr-mgmt/invite-user.png
   :width: 80%
   :alt: invite users
   :align: center


Network Roles
==============

Network roles are roles that are specific to a network. They are used to manage a user's access to a network. Network roles are signifact to platform and service users since admins can already access the entire Netmaker platform.

Network roles come in two flavors: *specific network roles* that affect particular networks, and *global network roles* that affect all networks.
There are only two global network roles: *global-network-admin*, which gives a user admin privileges over all networks and *global-network-user*, which gives a user basic view and connect only privileges across all networks.

The specific network roles follow the naming pattern of *<network id>-network-admin*, *<network id>-network-user* and *netID-<network id>-rag-<RAG name>*.

Breakdown

1. *<network id>-network-admin* gives a user admin privileges over that specific network.
2. *<network id>-network-user* gives a user basic view and connect only privileges over that specific network.
3. *netID-<network id>-rag-<RAG name>* gives a user connect-only access to a specific RAG in that network. If the user has *platform-user* access level, they would also be able to view the corresponding network.

The system provides a choice: administrators can opt for the precision of network-specific roles or the efficiency of global network roles. However, if a global network role isn't assigned, meticulous management is required to ensure consistent permissions across all networks, involving updates to individual network roles as needed.

In addition to the global network roles, default network roles are automatically created for any new network (admin and user), and default RAG roles are created for any new RAG created under a network. This eliminates the extra step of having to manually create such roles for user assignment.

Permissioning in Netmaker is additive. This implies if a user for instance has both global-network-admin and netID-mynet-rag-defaultgw, the user would not be restricted to defaultgw under the mynet network, but would instead have admin access to all RAGs and networks since the global-network-admin role gives them that right.

Managing user access to a remote access gateway (RAG)
=======================================================

From version 0.25.0, Netmaker Professional allows you to manage user access to a remote access gateway/network via roles.

- An *admin* or *super admin* user can access all gateways and all networks.
- A *platform user* or *service user* (does not have dashboard access) can only access the gateways they are assigned to.

To give a user access to an RAG, first ensure the gateway is already created. Then go to the User management page, click on the user you want to assign a gateway to, and assign them a role for the gateway.

To remove a user from a gateway, click on the user and remove the role for the gateway.


Transferring super admin rights
===============================

Super admin rights can be transferred only to another admin. To do this, on the users page, go to the superadmin row and hover over the ellipsis.
You will see an option to transfer admin rights. On clicking it, a dialog box will open allowing you to select any admin 
to transfer super admin rights to.

.. image:: /pro/images/users/transfer-super-admin-rights.png
   :width: 80%
   :alt: transfer super admin rights
   :align: center


Integrating OAuth
====================

Users are also allowed to join a Netmaker server via OAuth. They can do this by clicking the "Login with SSO" button on the dashboard's login page. Check out the :doc:`integrating oauth docs <../oauth>`.
