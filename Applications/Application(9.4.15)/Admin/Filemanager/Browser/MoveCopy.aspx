<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MoveCopy.aspx.vb" Inherits="Dynamicweb.Admin.MoveCopy" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Content.Files" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
	<title></title>
	<dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server" />
    <script type="text/javascript"> var ImagesFolderName = '<%=Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName()%>';</script>
    <script type="text/javascript" src="EntryContent.js"></script>
    <script type="text/javascript">
        var selectedFolder;

        function selectFolderInBrowseMode(folder, caller) {
            if (caller != "") {
                selObj = top.opener.document.getElementById(caller);
                selObj.value = folder;
                if (caller == 'FLDM_InboxFolder') {  
                    top.opener.location = '/Admin/Module/MediaDB/Files_inbox.aspx?InboxFolder=' + folder;
                } else {
                    Dynamicweb.Utilities.Events.fire(selObj, "change");
                }
                self.close();
            }
        }

        function selectFolder(folder) {
            selectedFolder = folder;
            if ("<%=Permission.HasRestrictedContent(RequestedFolder, _returnValue)%>" == "True" && selectedFolder.indexOf("Papirkurv") > -1) {
                alert("The folder can't be replaced to the trashbin because it has restricted content.");
            } else {
                DoMoveOrCopy();
            }
        }

        function DoMoveOrCopy() {
            if(selectedFolder){
                var returnValue = new Object();
                returnValue.folder = selectedFolder;
                window.returnValue = returnValue;
            }
            window.close();
        }
    </script>
    <style type="text/css">
	    .nav
        {
	        width: 247px;
        }
    
        .nav .tree
        {
	        width: 246px;
        }
    
        .nav .title
        {
	        width:246px;
        }
    
        .nav .subtitle
        {
	        width:246px;
        }
        body
        {
            overflow-x: hidden;
            overflow-y: auto;
        }
    </style>
</head>
<body id="body" runat="server">
    <input type="hidden" id="rootFolder" runat="server" />
    <form id="form1" runat="server">
        <dw:Tree ID="Tree1" runat="server" SubTitle="Mapper" Title="Filarkiv" ShowRoot="false"
            OpenAll="false" UseSelection="true" UseCookies="false" UseLines="true" AutoID="false"
            LoadOnDemand="false" CloseSameLevel="false" UseStatusText="false" InOrder="true"
            EnableViewState="false">
            <dw:TreeNode ID="TreeNode1" NodeID="0" runat="server" Name="Root" ParentID="-1">
            </dw:TreeNode>
        </dw:Tree>
    </form>
</body>

<%  Translate.GetEditOnlineScript()
    %>

</html>
