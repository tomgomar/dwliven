<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ChannelList.aspx.vb" Inherits="Dynamicweb.Admin.ChannelList" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script language="javascript" type="text/javascript">
        function Add() {
            if (!Toolbar.buttonIsDisabled('cmdAdd')) { { location.href = 'ChannelEdit.aspx'; } }
        }

        function GetHelp() {
            <%=Dynamicweb.SystemTools.Gui.Help("socialmedia", "omc.management.socialmedia.channels")%>
        }

        function SelectItem(id, isAvailable) {
            var url = 'ChannelEdit.aspx?id=' + id;
            if (!isAvailable)
                url += '&notAvailable=true';
            location.href = url;
        }
        function ChangeStatus(id) {
            location.href = 'ChannelList.aspx?id=' + id + '&cmd=ChangeStatus';
        }
    </script>

</head>
<body class="area-teal screen-container">
    <form id="form1" runat="server">
        <div class="card">
            <div class="card-header">
                <h2 class="subtitle">
                    <dw:TranslateLabel ID="lbSetup" Text="Social Media Channels" runat="server" />
                </h2>
            </div>

            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="false" Divide="None" Icon="PlusSquare" OnClientClick="Add()" Text="Add" />
                <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="GetHelp()" />
            </dw:Toolbar>

            <dw:List ID="lstChannels" ShowPaging="true" ShowTitle="false" runat="server" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colIcon" EnableSorting="false" Width="25" runat="server" ItemAlign="Center" />
                    <dw:ListColumn ID="colName" EnableSorting="true" Name="Channel Name" Width="175" runat="server" />
                    <dw:ListColumn ID="colEnabled" ItemAlign="left" EnableSorting="false" Name="Active" Width="75" runat="server" />
                </Columns>
            </dw:List>
        </div>
    </form>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
