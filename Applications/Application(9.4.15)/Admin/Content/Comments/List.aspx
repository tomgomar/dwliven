<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="List.aspx.vb" Inherits="Dynamicweb.Admin.List5" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
	<dw:ControlResources runat="server">
	</dw:ControlResources>
	<script type="text/javascript">
		var ItemID = '<%=ItemID %>';
		var Type = '<%=Type %>';
	    var LangID = '<%=LangID %>';
	    var titleEl = parent.document.getElementById("T_CommentsDialog");
	    var cleanTitle = titleEl.getAttribute("data-clean-title");
	    if (!cleanTitle) {
	        cleanTitle = titleEl.innerHTML;
	        titleEl.setAttribute("data-clean-title", cleanTitle);
	    }
	    titleEl.innerHTML = cleanTitle + ' (' + <%=CommentsCount %> + ')';
	</script>
	<script src="Comments.js" type="text/javascript"></script>
	<style type="text/css">
    body {
        overflow: hidden;
    }

	#CommentList_body tr
	{
		cursor:pointer;
	}
	.rightCorner
	{
		position:fixed;
		top:-1px;
		right:0px;
	}
    .list .container tbody[id]>tr.listRow>td, .list table.main_stretcher tr.listRow>td {
        line-height: normal;
    }
    .list .container .columnCell, .list .container .listRow td {
        padding: 5px 5px;
    }
	</style>
	<!--[if gt IE 7]>
	<style type="text/css">
	.rightCorner
	{
		position:fixed;
		top:0px;
		right:0px;
	}
	</style>
	<![endif]--> 
</head>
<body>
    <form id="form1" runat="server">
	    <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowStart="false">
            <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="PlusSquare" Text="Tilføj" OnClientClick="add();">
            </dw:ToolbarButton>
        </dw:Toolbar>
        <dw:List ID="CommentList" runat="server" Title="Kommentarer" PageSize="20" Height="320" ShowTitle="False">
	        <Columns>
		        <dw:ListColumn ID="ListColumn1" runat="server" Name="" Width="25" ItemAlign="Center">
		        </dw:ListColumn>
			    <dw:ListColumn ID="ListColumn2" runat="server" Name="Dato" Width="140">
		        </dw:ListColumn>
		         <dw:ListColumn ID="ListColumn3" runat="server" Name="Navn" Width="0">
		        </dw:ListColumn>
                <dw:ListColumn ID="ListColumn7" runat="server" Name="Active" Width="50" ItemAlign="Center">
		        </dw:ListColumn>
		        <dw:ListColumn ID="ListColumn6" runat="server" Name="Rating" Width="50" ItemAlign="Center">
		        </dw:ListColumn>
		        <dw:ListColumn ID="ListColumn4" runat="server" Name="Besked" Width="0">
		        </dw:ListColumn>
			    <dw:ListColumn ID="ListColumn5" runat="server" Name="" Width="25" ItemAlign="Center">
		        </dw:ListColumn>
		    </Columns>
	    </dw:List>
    </form>
</body>
</html>
