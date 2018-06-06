<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PhraseSelection.aspx.vb" Inherits="Dynamicweb.Admin.PhraseSelection" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:controlresources id="ControlResources1" runat="server">
	</dw:controlresources>

    <script type="text/javascript">
        function choose(phrase) {
            phrase = phrase.toString();
            if (phrase.length == 0) {
                alert("Please specify word");
                return false;
            }
            location = "Optimize.aspx?id=<%=Dynamicweb.Context.Current.Request("ID")%>&phrase=" + encodeURIComponent(phrase);
        }
    </script>

    <script type="text/javascript">
        function help() {
            <%=Dynamicweb.SystemTools.Gui.Help("page.optimizeexpress")%>
        }
    </script>

    <link href="/Admin/Module/eCom_Catalog/dw7/css/Optimize.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <h2 class="subtitle">
            <dw:translatelabel id="TranslateLabel4" runat="server" text="Choose a phrase or keyword you want to optimize this page for." />
        </h2>

        <div id="Div1" class="optimize-phrase-list" runat="server">
            <table border="0">
                <tr id="rowNothingFound" runat="server" valign="top">
                    <td class="optimize-no-phrases">
                        <div>
                            <dw:translatelabel id="lbNothingFound" text="No phrases found" runat="server" />
                        </div>
                    </td>
                </tr>
                <asp:Literal ID="Phrase1" runat="server"></asp:Literal>
                <asp:Literal ID="Phrase2" runat="server"></asp:Literal>
                <asp:Literal ID="Phrase3" runat="server"></asp:Literal>
                <asp:Literal ID="Phrase4" runat="server"></asp:Literal>
                <asp:Literal ID="Phrase5" runat="server"></asp:Literal>
            </table>
        </div>

        <div class="optimize-phrase-custom">
            <span>
                <dw:translatelabel id="lbUserDefined" text="Brugerdefineret" runat="server" />
            </span>
            <input type="text" class="std" autocomplete="off" id="customPhrase" name="customPhrase" onfocus="this.select();" oncontextmenu="return false;" value="" />
            <i id="cmdSubmitPhrase" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Plus) %>" onclick="choose(document.getElementById('customPhrase').value); return false;" ></i>
        </div>
    </form>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
