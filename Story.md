# Introduction
## The placement of Teams in Office 365
Teams is for teams, Yammer is for enterprise communication and curated discussions. Teams is like glasses for several services in Office 365: SharePoint, Skype, OneDrive for Business, Planner, Office Online Server etc.

## Mobile Apps
You can have a browser view, but you also have desktop clients across platforms and mobile clients across platforms. However, user experience on web and client apps will differ

## What happens when you create a team
* An Office 365 Group ("Unified Group") will be created
* A SharePoint Site Collection is created, unvisible in the SharePoint Admin Center
* A Mailbox is created
* An OneNote-Notebook is created

## Office 365 Admin Center
* Partial Administration, some settings on channel only
* No automation, but PowerShell-Module "under development" according to User Voice (https://microsoftteams.uservoice.com/forums/555103-public)

# Teams Walkthrough
## GUI Demonstration
## Create a Team
* Add Members
* If you are an Administrator, you can convert an existing Office 365 Group to a Team
* You can have 10 Owners at the moment, but this limit will be raised
* Owner means Full Control
* Limitations
    * No external sharing (heavily requested on Uservoice and was announced for end of June, but then postphoned)
    * Delete a Team does _not_ involve a recycle bin concept
    * Presence indicator counts for three minutes and is not synchronized with Skype for Business
## Channels
* Channels can have connectors
* Channels have same permissions as the Team
* Each channel means a Subfolder in the Teams Document Library
* You can follow a channel
* You can define a picture
* Emailing a channel is supported out of the box
    * You cannot delete this message
    * It will be placed in a subfolder
* Link to channel means link to open the channel directly in the browser
* When you delete a message, message stays on your site with a remark ("This message was deleted"), but disappears for others
* Groups as members are supported
    * But no dymanic membership, simple group expansion
    * Email-enabled Security Group, Distribution Group and Security Groups can be added and nested
    * Unified Groups ("Office 365 Groups") cannob be nested, but can be "added" to a team with instant expansion
## Tabs
* Tabs are used to link other functionality
* Are connected to a channel
* OneNote Notebook is saved in site assets on the site collection. Each channel gets his own section.
    * You can see all content by open this notebook directly
* Calendars are created in SharePoint, but can only be displayed on fat client apps. In the browser you will get a message that you need to open it in a new tab
    * You can circumvent this with a seperat calendar in a separate Sharepoint Site, modify the ASPX-Page with SharePoint Designer and then it will work. Add in line 9:
    ```` <WebPartPages:AllowFraming runat="server" />````
## Files
* You can add/upload files just as in SharePoint
* For editing, Office Online Server is embedded for OneNote, everything else will open in a new Browser Window.
* Files will be saved in a subfolder per Channel
## Connectors
* With connectors, you can bring in a lot of external services
* For posting to Teams, you can use Webhooks
# Other Notes from the field
* Exchange Online / Profile Pictures
* Limit the people who can create Teams (https://support.office.com/en-us/article/Manage-who-can-create-Office-365-Groups-4c46c8cb-17d0-44b5-9776-005fced8e618?ui=en-US&rs=en-US&ad=US)
* Office Group naming convention is not enforced by teams

Written by Matthias Gessenay, Corporate Software AG, 2017