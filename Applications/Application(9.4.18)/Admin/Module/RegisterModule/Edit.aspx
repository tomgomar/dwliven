<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Edit.aspx.vb" Inherits="Dynamicweb.Admin.RegisterModule.Edit" %>

<!DOCTYPE html>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <script type="text/javascript" src="js/edit.js"></script>
    <script type="text/javascript">
        function save(doClose){
            objform = document.forms[0];

		    if(objform.Name.value == ''){
			    alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
			    objform.Name.focus()
			    return false;
		    }
		    if(objform.SystemName.value == ''){
			    alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Systemnavn"))%>');
			    objform.SystemName.focus()
			    return false;
		    }
		
		    if (objform.SystemName.value.search(/[^\w\.]/) > -1)
		    {
			    alert("<%=Translate.JSTranslate("Ugyldige tegn i: %%", "%%", Translate.JsTranslate("Systemnavn"))%>");
			    objform.SystemName.focus()
			    return false;
		    }
		
            document.getElementById("close").value = doClose ? "True" : "False"

            objform.action = "save.aspx";
            objform.__VIEWSTATE.value = "";
		    objform.submit();
	    }

        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("registermodule", "modules.registermodule.edit")%>
	    }

    </script>
</head>
<body class="area-black screen-container">
    <div class="card">
    <form id="form1" method="post" runat="server">
    <input type="hidden" name="_ID" id="_ID" value="" runat="server" />
    <input type="hidden" name="close" id="close" value="" />
    <dw:RibbonBar ID="ModuleBar" runat="server">
        <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Content" runat="server" Visible="true">
            <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                <dw:RibbonBarButton ID="btnSaveNews" Text="Save" Title="Save" Icon="Save" Size="Small"
                    runat="server" OnClientClick="save(false);" />
                <dw:RibbonBarButton ID="btnSaveAndCloseNews" Text="Save and close" Icon="Save"
                    Size="Small" runat="server" OnClientClick="save(true);" />
                <dw:RibbonBarButton ID="btnCancel" Text="Close" Icon="Cancel" Size="Small" runat="server"
                    PerformValidation="false" OnClientClick="location = 'List.aspx';" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonBarGroup5" Name="Information" runat="server">
                <dw:RibbonBarRadioButton ID="ModuleRibbon" Text="Module" OnClientClick="ribbonTab(1);"
                    Checked="true" Group="group1" Icon="InfoCircle" Size="Small" runat="server" />
                <dw:RibbonBarRadioButton ID="SearchRibbon" Text="Search" OnClientClick="ribbonTab(2);"
                    Group="group1" Icon="Search" Size="Small" runat="server" />
                <dw:RibbonBarRadioButton ID="SecurityRibbon" Text="Security" Group="group1" OnClientClick="ribbonTab(3);"
                    Icon="Exchange" Size="Small" runat="server" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonBarGroup10" Name="Help" runat="server">
                <dw:RibbonBarButton ID="Help" Text="Help" Title="Help" Icon="Help" Size="Large"
                    runat="server" OnClientClick="help();" />
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>
    </dw:RibbonBar>
    <dw:StretchedContainer ID="OuterContainer" Scroll="Auto" Stretch="Fill" Anchor="document"
        runat="server">
        <div id="Tab1">
            <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Indstillinger"))%>
            <table>
                <tr>
                    <td width="170">
                        <%=Translate.Translate("Navn")%>
                    </td>
                    <td>
                        <input type="text" name="Name" id="Name" class="std" style="width:380px" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Systemnavn")%>
                    </td>
                    <td>
                        <input type="text" name="SystemName" id="SystemName" class="std" style="width:380px" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Path to custom admin page")%>
                    </td>
                    <td>
                        <input type="text" name="Script" title="Path should start with /CustomModules" id="Script" class="std" style="width:380px" runat="server"/>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align:top">
                        <%=Translate.Translate("Beskrivelse")%>
                    </td>
                    <td>
                        <textarea rows="3" cols="3" name="Description" id="Description" class="std" style="width:380px"  runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Enabled")%>
                    </td>
                    <td>
                        <input type="checkbox" name="Access" id="Access" value="1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Afsnitsmodul")%>
                    </td>
                    <td>
                        <input type="checkbox" name="Paragraph" id="Paragraph" value="1" runat="server" />
                    </td>
                </tr>
            </table>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
        </div>
        <div id="Tab2" style="display:none;">
            <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("System"))%>
            <table>
                <tr>
                    <td width="170">
                        <%=Translate.Translate("Database")%>
                    </td>
                    <td>
                        <input type="text" name="Database" id="Database" class="std" runat="server" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Item tabel")%>
                    </td>
                    <td>
                        <input type="text" name="ItemTable" id="ItemTable" class="std" runat="server" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Item query parameter")%>
                    </td>
                    <td>
                        <input type="text" name="ItemIDQueryParameterName" id="ItemIDQueryParameterName"
                            class="std" runat="server" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Kategori tabel")%>
                    </td>
                    <td>
                        <input type="text" name="CategoryTable" id="CategoryTable" class="std" runat="server" />
                    </td>
                </tr>
            </table>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Kategori Felter"))%>
            <table>
                <tr>
                    <td width="170">
                        <%=Translate.Translate("ID")%>
                    </td>
                    <td>
                        <input type="text" name="CategoryIdField" id="CategoryIdField" class="std" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Navn")%>
                    </td>
                    <td>
                        <input type="text" name="CategoryNameField" id="CategoryNameField" class="std" runat="server" />
                    </td>
                </tr>
            </table>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Item Felter"))%>
            <table>
                <tr>
                    <td width="170">
                        <%=Translate.Translate("ID")%>
                    </td>
                    <td>
                        <input type="text" name="ItemIdField" id="ItemIdField" class="std" runat="server" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Kategori ID")%>
                    </td>
                    <td>
                        <input type="text" name="ItemCategoryIdField" id="ItemCategoryIdField" class="std"
                            runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Overskrift")%>
                    </td>
                    <td>
                        <input type="text" name="ItemNameField" id="ItemNameField" class="std" runat="server" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Dato")%>
                    </td>
                    <td>
                        <input type="text" name="ItemDateField" id="ItemDateField" class="std" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Redigeret dato")%>
                    </td>
                    <td>
                        <input type="text" name="ItemLastModifiedDateField" id="ItemLastModifiedDateField"
                            class="std" runat="server" />
                    </td>
                </tr>
            </table>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Søgning"))%>
            <table>
                <tr>
                    <td width="170">
                        <%=Translate.Translate("Søg i")%>
                    </td>
                    <td>
                        <input type="text" name="ItemSearchFields" id="ItemSearchFields" class="std" runat="server" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Brødtekst")%>
                    </td>
                    <td>
                        <input type="text" name="ItemTextField" id="ItemTextField" class="std" runat="server" />*
                    </td>
                </tr>
            </table>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Publicering"))%>
            <table>
                <tr>
                    <td width="170">
                        <%=Translate.Translate("Aktiv")%>
                    </td>
                    <td>
                        <input type="text" name="ItemActiveField" id="ItemActiveField" class="std" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Aktiv fra")%>
                    </td>
                    <td>
                        <input type="text" name="ItemActiveFromDateField" id="ItemActiveFromDateField" class="std"
                            runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Aktiv til")%>
                    </td>
                    <td>
                        <input type="text" name="ItemActiveToDateField" id="ItemActiveToDateField" class="std"
                            runat="server" />
                    </td>
                </tr>
            </table>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
        </div>
        <div id="Tab3" style="display:none;">
            <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Indstillinger"))%>
            <table>
                <tr>
                    <td width="170">
                        <%=Translate.Translate("Database")%>
                    </td>
                    <td>
                        <input id="SecDatabase" runat="server" class="std" name="SecDatabase" type="text" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Kategori tabel")%>
                    </td>
                    <td>
                        <input id="SecTable" runat="server" class="std" name="SecTable" type="text" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("ID column")%>
                    </td>
                    <td>
                        <input id="SecFieldID" runat="server" class="std" name="SecFieldID" type="text" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Name column")%>
                    </td>
                    <td>
                        <input id="SecFieldName" name="SecFieldName" runat="server" class="std" type="text" />*
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=Translate.Translate("Where")%>
                    </td>
                    <td>
                        <input id="SecWhere" name="SecWhere" runat="server" class="std" type="text" />
                    </td>
                </tr>
            </table>
            <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd()%>
        </div>
    </dw:StretchedContainer>
    </form>
    </div>
    <%
        Translate.GetEditOnlineScript()
    %>
</body>
</html>
