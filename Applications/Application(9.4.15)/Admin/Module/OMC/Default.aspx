<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.OMC._Default" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls.Charts" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Marketing" runat="server" />
    </title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/js/Default.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/css/Default.css" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
</head>
<body class="area-teal">
    <form id="MainForm" runat="server">
        <table id="mainTab" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top">
                <td id="cellTreeCollapsed" style="display: none">
                    <i id="imgShowNav" runat="server"></i>
                </td>
                <td id="cellTree" style="width: 350px;">
                    <div class="cellTreeContainer">
                        <dw:Tree ID="MainTree" UseCookies="false" ShowRoot="false" EnableControlMenu="true" Title="Marketing" ShowSubTitle="false" LoadOnDemand="true" UseSelection="true" OpenAll="false" UseLines="true" InOrder="true" ClientNodeComparator="OMC.MasterPage.get_current().compareTreeNodes" runat="server">
                            <dw:TreeNode ID="nodeRoot" NodeID="0" ParentID="-1" Name="Root" ItemID="/" runat="server" />
                            <%If Not isFromParameterEditor Then%>
								<dw:TreeNode ID="nodeLeads" NodeID="3" ParentID="0" Name="Leads" HasChildren="true" ItemID="/Leads" runat="server" />
								<dw:TreeNode ID="nodeSplitTesting" NodeID="4" ParentID="0" Name="Split tests" HasChildren="false" ItemID="/Experiments" Href="javascript:OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/OMC/Experiments/Overview.aspx');" runat="server" />
								<%If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("Profiling") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("Profiling") Then%>
								<dw:TreeNode ID="nodeProfiling" NodeID="5" ParentID="0" Name="Personalization" HasChildren="true" ItemID="/Profiles" ContextMenuID="menuProfiles" runat="server" />
								<%End If%>
								<%End If%>
								<%If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("EmailMarketing") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("EmailMarketing") Then%>
								<dw:TreeNode ID="nodeNewsletters" NodeID="6" ParentID="0" Name="Email Marketing" HasChildren="true" ItemID="/EmailMarketing" ContextMenuID="menuEmailMarketing" runat="server" />
								<%End If%>
								<%If Not isFromParameterEditor Then%>
								<%If False Then 'Dynamicweb.Modules.UserManagement.License.IsModuleAvailable("Campaigns") Then%>
								<dw:TreeNode ID="nodeAutomations" NodeID="8" ParentID="0" Name="Campaigns" HasChildren="true" ItemID="/Automations" ContextMenuID="MenuAutomation" runat="server" />
								<%End If%>
								<%If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("SocialMediaPublishing") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("SocialMediaPublishing") Then%>
								<dw:TreeNode ID="nodeSocialMediaPublishing" NodeID="7" ParentID="0" Name="Social Media Publishing" HasChildren="true" ItemID="/SocialMediaPublishing" ContextMenuID="menuSocialMediaPublishing" runat="server" />
								<%End If%>
								<%If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("Sms") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("Sms") Then%>
								<dw:TreeNode ID="TreeNode1" NodeID="8" ParentID="0" Name="SMS" HasChildren="false" ItemID="/Sms" ContextMenuID="menuSms" Href="javascript:OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/Sms/SmsList.aspx');" runat="server" />
								<%End If%>
                            <%End If%>
                        </dw:Tree>
                    </div>
                    <div id="treeEndMarker" style="height: 1px">
                    </div>
                </td>
                <td id="slider">
                    <div id="sliderHandle">
                        &nbsp;
                    </div>
                </td>
                <td id="cellContent">
                    <div id="cellContentLoading" style="display: none">
                        <div class="omc-loading-container">
                            <div class="omc-loading-container-inner">
                                <img src="/Admin/Images/Ribbon/UI/Overlay/wait.gif" alt="" title="" />
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Refresh, True)%> fa-spin"></i>
                                <div class="omc-loading-container-text">
                                    <dw:TranslateLabel ID="lbPleaseWait" Text="One moment please..." runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="screen-container">
                        <div id="entryContainer" style="display: none">                                
                            <div id="entryTitle">
                            </div>
                            <div id="entryToolbarLoading" style="display: none">
                                <div class="omc-toolbar-loading">
                                    <div class="omc-toolbar-loading-inner">
                                        <div class="omc-toolbar-loading-contents">
                                            <span>
                                                <dw:TranslateLabel ID="lbLoadingToolbar" Text="Initializing toolbar..." runat="server" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="omc-clear">
                                    </div>
                                </div>
                            </div>
                            <div id="entryToolbar" style="display: none">
                            </div>                                
                            <iframe id="ContentFrame" src="about:blank" frameborder="0" width="100%" scrolling="auto" onload="OMC.MasterPage.get_current().contentLoaded();" height="100%" marginheight="0" marginwidth="0"></iframe>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <dw:ContextMenu ID="menuReport" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdEditReport" Text="Edit report" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().editReport();" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteReport" Divide="Before" Text="Delete report" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuCategory" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateReport" Text="Create new report" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().createReport(null);" runat="server" />
            <dw:ContextMenuButton ID="cmdCreateCategory" Text="Create new category" Divide="Before" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateReportCategory(null);" runat="server" />
            <dw:ContextMenuButton ID="cmdEditCategory" Text="Edit category" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().beginEditReportCategory(null);" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteCategory" Divide="Before" Text="Delete category" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuReports" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateReportGeneral" Text="Create new report" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/OMC/Reports/ReportBuilder.aspx');" runat="server" />
            <dw:ContextMenuButton ID="cmdCreateCategoryGeneral" Text="Create new category" Divide="Before" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateReportCategory(null);" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuTheme" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateTheme" Text="Create new theme" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().editTheme();" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuReportTheme" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdEditTheme" Text="Edit theme" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().editTheme();" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteTheme" Divide="Before" Text="Delete theme" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuProfiles" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateProfile" Text="Create new profile" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().editProfile();" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuProfile" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdEditProfile" Text="Edit profile" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().editProfile();" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteProfile" Divide="Before" Text="Delete profile" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuDraftEmails" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateNewsletter" Text="Create new email" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().editNewsletter(null, null, ContextMenu.callingItemID, true);" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuEmailMarketing" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateTopFolder" Text="Create new top folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().editTopFolder();" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuSocialMediaPublishing" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="ContextMenuButton3"  Text="Create new top folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().editSMPTopFolder();" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuDefaultTopFolder" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdDefaultCreateEmail" Text="Create new email" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().editNewsletter(null, null, ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdDefaultCreateCucstomFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateEmailFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdDefaultEditTopFolder" Text="Edit top folder" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().editTopFolder(ContextMenu.callingItemID);" runat="server" />
            <%If Me.HasPermissionsAccess Then%>
            <dw:ContextMenuButton ID="cmdDefaultTopFolderPermissions" Text="Permissions" Icon="Lock" OnClientClick="OMC.MasterPage.get_current().editTopFolderPermissions(ContextMenu.callingItemID);" runat="server" />
            <%End If%>
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuDefaultSMPTopFolder" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateMessage" Text="Create new message" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().createMessage(null, null, ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdCreateSMPFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateSMPFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdEditDefaultSMPTopFolder" Text="Edit top folder" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().editSMPTopFolder(ContextMenu.callingItemID);" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuSMPTopFolder" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateNewMessage" Text="Create new message" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().createMessage(null, null, ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdCreateSMPCustomFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateSMPFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdEditSMPTopFolder" Text="Edit top folder" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().editSMPTopFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteSMPTopFolder" Divide="Before" Text="Delete top folder" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="cmdUserSMPFolder" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateUserSMPFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateSMPFolder(null);" runat="server" />
            <dw:ContextMenuButton ID="cmdEditUserSMPFolder" Text="Edit folder" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().beginEditSMPFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteSMPFolder" Divide="Before" Text="Delete folder" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuTopFolder" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateEmail" Text="Create new email" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().editNewsletter(null, null, ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdCreateCucstomFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateEmailFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdEditTopFolder" Text="Edit top folder" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().editTopFolder(ContextMenu.callingItemID);" runat="server" />
            <%If Me.HasPermissionsAccess Then%>
            <dw:ContextMenuButton ID="cmdTopFolderPermissions" Text="Permissions" Icon="Lock" OnClientClick="OMC.MasterPage.get_current().editTopFolderPermissions(ContextMenu.callingItemID);" runat="server" />
            <%End If%>
            <dw:ContextMenuButton ID="cmdDeleteTopFolder" Divide="Before" Text="Delete top folder" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuAllEmails" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <%If Me.HasPermissionsAccess Then%>
            <dw:ContextMenuButton ID="cmdAllEmailsFolderPermissions" Text="Permissions" Icon="Lock" OnClientClick="OMC.MasterPage.get_current().editTopFolderPermissions(ContextMenu.callingItemID);" runat="server" />
            <%End If%>
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuEmailUserFolder" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateUserFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateEmailFolder(null);" runat="server" />
            <dw:ContextMenuButton ID="cmdEditEmaiFolder" Text="Edit folder" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().beginEditEmailFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteEmailFolder" Divide="Before" Text="Delete folder" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="menuAllAutomations" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateNewAutomation" Text="Create new campaign" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/OMC/Automations/EditAutomation.aspx?New=True');" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="MenuAutomations" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateNewAutomationInFolder" Text="Create new campaign" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/OMC/Automations/EditAutomation.aspx?New=True&caller='+ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdCreateNewAutomationFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateAutomationFolder(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton ID="cmdEditAutomationFolder" Text="Edit folder" Icon="Pencil" OnClientClick="OMC.MasterPage.get_current().beginEditAutomationFolder(ContextMenu.callingItemID);;" runat="server" />
            <dw:ContextMenuButton ID="cmdDeleteAutomationFolder" Divide="Before" Text="Delete folder" Icon="Delete" OnClientClick="" runat="server" />
        </dw:ContextMenu>
        <dw:ContextMenu ID="MenuAutomation" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="cmdCreateNewTopAutomationFolder" Text="Create new folder" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().beginCreateAutomationFolder(ContextMenu.callingItemID);" runat="server" />
        </dw:ContextMenu>

        <dw:ContextMenu ID="menuUnpublishedMessage" OnShow="OMC.MasterPage.get_current().get_tree().get_dynamic().highlight(ContextMenu.callingID);" runat="server">
            <dw:ContextMenuButton ID="ContextMenuButton1" Text="Create new message" Icon="PlusSquare" OnClientClick="OMC.MasterPage.get_current().createMessage(null, null, ContextMenu.callingItemID, true);" runat="server" />
        </dw:ContextMenu>
        <!-- Hosting control for rendering controls asynchronously. Needed in order to have a reference to the current page -->
        <asp:Panel ID="pHostingControl" runat="server">
        </asp:Panel>

        <dw:Dialog runat="server" ID="pwDialog"  ShowOkButton="true" ShowCancelButton="true"  ShowClose="true" HidePadding="true">
            <iframe id="pwDialogFrame" ></iframe>
        </dw:Dialog>
    </form>

    <script type="text/javascript">
        //<![CDATA[
        $(document.body).observe('unload', function () {
            OMC.MasterPage.get_current().dispose();
        });

        var nodeLeadsID = 3;

        var onTreeAfterExpandAjax = function (sender, args) {
            if (args.ParentNodeID == nodeLeadsID) {
                if (args.ChildrenNodes.length > 0 && args.ChildrenNodes[0].url && args.ChildrenNodes[0].url != '') {
                    var firstNode = args.ChildrenNodes[0];
                    OMC.MasterPage.get_current().get_tree().s(firstNode._ai);
                    try {
                        eval(firstNode.url);
                    } catch (e) {; }
                }
            }
        };

        OMC.MasterPage.get_current().set_controlID('<%=Me.UniqueID%>');
            OMC.MasterPage.get_current().set_dialog('pwDialog');

        OMC.MasterPage.get_current().initialize(function () {
            var open = '<%=Core.Converter.ToString(MyBase.Request.QueryString("Open")).Replace("'", "\'")%>';

                if (open && open.length) {
                    OMC.MasterPage.get_current().set_contentUrl(OMC.MasterPage.Action.getAction(open));
                } else {
                    OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
                }

                OMC.MasterPage.get_current().get_tree().add_afterExpandAjax(onTreeAfterExpandAjax);
            });

        <%If isFromParameterEditor Then%>
        OMC.MasterPage.get_current()._isFromParameterEditor = true;
        OMC.MasterPage.get_current()._parameterEditorOpenerID = '<%=Dynamicweb.Context.Current.Request("openerid")%>';
            //OMC.MasterPage.get_current().reload("/EmailMarketing/-1", { highlightNode: true });
            OMC.MasterPage.get_current().showEmailsList(-1, -1, false);
        <%End If%>
        //]]>
    </script>

    <%Translate.GetEditOnlineScript()%>
</body>
</html>
