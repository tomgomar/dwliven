<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FoldersTree.aspx.vb" Inherits="Dynamicweb.Admin.OMC.SMP.FoldersTree" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Social Media Publishing" runat="server" />
    </title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/OMC/js/Default.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        function selectFolder(folderId, parentId, topFolderId, fromFolderId) {
            if (folderId || topFolderId) {
                var returnValue = new Object();
                returnValue.fromFolderId = fromFolderId;
                returnValue.folderId = folderId;
                returnValue.parentId = parentId;
                returnValue.topFolderId = topFolderId;
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
<body>
    <form id="form1" runat="server">
        <div class="cellTreeContainer">
            <dw:Tree ID="CustomFoldersTree" runat="server" SubTitle="Custom folders" Title="Social Media Publishing" ShowRoot="false"
            OpenAll="false" UseSelection="true" UseCookies="false" UseLines="true" AutoID="True"
            LoadOnDemand="true" CloseSameLevel="false" UseStatusText="false" InOrder="true"  ClientNodeComparator="OMC.MasterPage.get_current().compareTreeNodes">
                <dw:TreeNode ID="RootNode" NodeID="0" runat="server" Name="Root" ParentID="-1" ItemID="/"></dw:TreeNode>
            </dw:Tree>
        </div>
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
