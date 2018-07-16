<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MessageList.aspx.vb" Inherits="Dynamicweb.Admin.OMC.SMP.MessageList" MasterPageFile="~/Admin/Module/OMC/EntryContent.Master" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        function socialMessageSelected() {
            if (List && List.getSelectedRows('lstSocialMessages').length > 0) {
                parent.$('cmdDelete').setAttribute('onclick', 'OMC.MasterPage.get_current().confirmDeleteSocialMessage(<%=FolderId%>, <%=TopFolderId%>);');
                parent.Toolbar.setButtonIsDisabled('cmdDelete', false);
                parent.$('cmdMove').setAttribute('onclick', 'OMC.MasterPage.get_current().moveSocialMessage(null, <%=FolderId%> , <%=TopFolderId%>);');
                parent.Toolbar.setButtonIsDisabled('cmdMove', false);
            } else {
                parent.$('cmdDelete').setAttribute('onclick', '');
                parent.Toolbar.setButtonIsDisabled('cmdDelete', true);
                parent.$('cmdMove').setAttribute('onclick', '');
                parent.Toolbar.setButtonIsDisabled('cmdMove', true);
            }
        }

        function setSocialMessageToOpener(id, name) {
            //var form = opener.document.<%=openerForm%>;
            var titleContainer = opener.document.getElementById('Title_<%=openerId%>');
            var idContainer = opener.document.getElementById('<%=openerId%>');
            titleContainer.value = name;
            idContainer.value = id;
            window.close();
        }
     </script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <dw:StretchedContainer ID="SMPStretchedContainer" Scroll="Hidden" Stretch="Fill" Anchor="document" runat="server" ClientIDMode="Static">
        <dw:List ID="lstSocialMessages" runat="server" ShowTitle="false" ShowPaging="true" PageSize="25" OnClientSelect="socialMessageSelected();" StretchContent="True" AllowMultiSelect="true">
            <Columns>
                <dw:ListColumn ID="PageIcon" runat="server" HeaderAlign="Center" ItemAlign="Center" Width="25"></dw:ListColumn>
                <dw:ListColumn ID="DateColumn" EnableSorting="true" runat="server" Name="Date" Width="150"></dw:ListColumn>
                <dw:ListColumn ID="NameColumn" EnableSorting="true" runat="server" Name="Name"></dw:ListColumn>
                <dw:ListColumn ID="MediaColumn" EnableSorting="true" runat="server" Name="Media"></dw:ListColumn>
                <dw:ListColumn ID="PublishedColumn" EnableSorting="true" runat="server" Name="Published" Width="150"></dw:ListColumn>
                <dw:ListColumn ID="FirstlineColumn" EnableSorting="true" runat="server" Name="Text"></dw:ListColumn>
                <dw:ListColumn ID="ImageColumn" EnableSorting="true" runat="server" Name="Image"></dw:ListColumn>
                <dw:ListColumn ID="LinkColumn" EnableSorting="true" runat="server" Name="Link"></dw:ListColumn>
            </Columns>
        </dw:List>
    </dw:StretchedContainer>

    <dw:ContextMenu ID="menuEditMessage" OnShow="" runat="server">
        <dw:ContextMenuButton ID="cmdEditSocialMessage" Text="Edit message" Icon="Pencil" OnClientClick="" runat="server" />
        <dw:ContextMenuButton ID="cmdMoveSocialMessage" Text="Move message" Icon="ArrowRight" OnClientClick="" runat="server" />
        <dw:ContextMenuButton ID="cmdDeleteSocialMessage" Text="Delete message" Icon="Delete" OnClientClick="" runat="server" />
    </dw:ContextMenu>
        
    <script type="text/javascript">
        window.onload = function () {
            if ($('SMPStretchedContainer') && $('SMPStretchedContainer').style.height.length <= 3) {
                $('SMPStretchedContainer').style.height = window.frameElement.clientHeight + "px";
            }
            if (navigator.appVersion.indexOf('MSIE 9.0') != -1) {
                setTimeout(function () { window.resizeTo(window.frameElement.clientWidth, window.frameElement.clientHeight - 1); }, 100);
            }
        }
    </script>
</asp:Content>

