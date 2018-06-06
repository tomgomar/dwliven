<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="StatisticView.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.StatisticView" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ID="cHead" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" language="JavaScript" src="../images/AjaxAddInParameters.js"></script>
		<script type="text/javascript" language="JavaScript" src="/Admin/Images/Chart/JSClass/FusionCharts.js"></script>
		<script type="text/javascript" language="JavaScript" src="../images/layermenu.js"></script>
		<script type="text/javascript" language="JavaScript" src="../images/ObjectSelector.js"></script>

	    
	    
		
        <style type="text/css">
	    BODY.margin { MARGIN: 0px }
	    INPUT { FONT-SIZE: 11px; FONT-FAMILY: verdana,arial }
	    SELECT { FONT-SIZE: 11px; FONT-FAMILY: verdana,arial }
	    TEXTAREA { FONT-SIZE: 11px; FONT-FAMILY: verdana,arial }
	    
	    fieldset
	    {
	    	width: 98% !important;
	    }
	    
	    fieldset object
	    {
	    	z-index: -1;
	    }
	    
	    div.report-title,
	    div.report-subtitle
	    {
	    	padding-left: 5px;
	    	padding-top: 5px;
	    }
	    
	    div.report-title
	    {
	    	font-weight: bold;
	    	font-size: 16px;
	    }
	    
		</style>		
		
		<script type="text/javascript">
		
		function changeView(type) {
		    var elemShow;
		    var menuID = 'cmChartType', buttons = ['cmdLineChart', 'cmdPieChart', 'cmdColumnChart'], buttonID = '';
            
            document.getElementById("GraphLayer_Line").style.display = "none";
	        document.getElementById("GraphLayer_Pie").style.display = "none";
	        document.getElementById("GraphLayer_Column").style.display = "none";

	        if (type == "LINE") {
	            buttonID = 'cmdLineChart';
		        elemShow = document.getElementById("GraphLayer_Line");
		    }
		    if (type == "PIE") {
		        buttonID = 'cmdPieChart';
		        elemShow = document.getElementById("GraphLayer_Pie");
		    }
		    if (type == "COLUMN") {
		        buttonID = 'cmdColumnChart';
		        elemShow = document.getElementById("GraphLayer_Column");
		    }

		    elemShow.style.display = "block";
		    document.getElementById('Form1').graphType.value = type;

            /* Updating the current chart type image */
		    Ribbon.set_imagePath('chartRibbon', 'cmdChartType',
		        '/Admin/Images/Ribbon/Icons/' + type.toLowerCase() + '-chart.png');
		    
		    /* Updating the current chart type (selected button in the context-menu) */
		    for (var i = 0; i < buttons.length; i++) {
		        ContextMenu.set_isChecked(menuID, buttons[i], buttons[i] == buttonID);
		    }
		}

        function ShowData() {
            var elem = document.getElementById("DataLayer")
            if (elem.style.display == "none") {
                elem.style.display = "block";
                document.getElementById('Form1').showDataLines.value = "1";
                goToAnchor("DataAnchor")
            } else {
                elem.style.display = "none";
                document.getElementById('Form1').showDataLines.value = "";
            }
		}
		
		function printStat() {
		    window.open("StatisticView.aspx?AddIn=<%=StatAddInType%>&PrintMode=1&ecom7master=hidden");
		}
		
        function exportStat() {
            var url = "StatisticView.aspx?AddIn=<%=StatAddInType%>&XLSExport=1";
			EcomStatExport.document.location.href = url;
        }

        function goToAnchor(AnchorName) {
            location.href = "#" + AnchorName;
        }
		</script>
		
		<%=cAddInControl1.Jscripts%>
</asp:Content>
<asp:Content ID="cContent" ContentPlaceHolderID="ContentHolder" runat="server">
    <input type="hidden" name="graphType" />
	<input type="hidden" name="showDataLines" />
	
	<dw:RibbonBar ID="chartRibbon" HelpKeyword="ecom.statistics.view" runat="server">
	    <dw:RibbonBarTab ID="tabChart" Name="Chart" runat="server">
	        <dw:RibbonBarGroup ID="groupData" Name="Data" runat="server">
	            <dw:RibbonBarButton ID="cmdChartType" Text="Chart type" Size="Large" Icon="AreaChart" ContextMenuId="cmChartType" SplitButton="false" runat="server" />
	            <dw:RibbonBarCheckbox ID="chkShowList" Checked="false" Text="Show list" OnClientClick="ShowData();" Size="Small" Icon="Table" runat="server" />
	            <dw:RibbonBarButton ID="cmdSave" Text="Apply parameters" EnableServerClick="true" OnClick="cmdSave_Click" Icon="Check" IconColor="Default" Size="Small" runat="server" />
	        </dw:RibbonBarGroup>
	        <dw:RibbonBarGroup ID="groupExport" Name="Export" runat="server">
	            <dw:RibbonBarButton ID="cmdExportXLS" Text="Export to Excel" Size="Small" Icon="FileExelO" OnClientClick="exportStat();" runat="server" />
	            <dw:RibbonBarButton ID="cmdPrint" Text="Printable version" Size="Small" Icon="Print" OnClientClick="printStat();" runat="server" />
	        </dw:RibbonBarGroup>
	    </dw:RibbonBarTab>
	</dw:RibbonBar>
	
	<dw:StretchedContainer ID="strContainer" Anchor="body" Scroll="VerticalOnly" Stretch="Fill" runat="server">
	    <table border="0" cellpadding="0" cellspacing="0" <%=tableClass%> style="width: 98%; border-right: 0px solid black; border-bottom: 0px solid black; border-left: 0px solid black">
	        <tr valign="top">
	            <td>
	                <div class="report-title">
	                    <asp:Literal ID="litTitle" runat="server" />
	                </div>
	                <div class="report-subtitle">
	                    <asp:Literal ID="litSubTitle" runat="server" />
	                </div>
	            </td>
	        </tr>
		    <tr>
			    <td valign="top">
    			
			    <de:AddInSelector id="cAddInControl1" runat="server" AddInGroupName="Statistik" AddInTypeName="Dynamicweb.Ecommerce.Statistics.StatisticsProvider"></de:AddInSelector>

			    <div id="GraphLayer_Line" style="display:block;">
			    <fieldset style='width: 100%;margin:5px;'><legend class=gbTitle><%=Translate.Translate("Graph")%>&nbsp;</legend>
				    <asp:Literal id="LineGraph" runat="server"></asp:Literal>
			    </fieldset> 
			    </div>

			    <div id="GraphLayer_Pie" style="display:none;">
			    <fieldset style='width: 100%;margin:5px;'><legend class=gbTitle><%=Translate.Translate("Graph")%>&nbsp;</legend>
				    <asp:Literal id="PieGraph" runat="server"></asp:Literal>
			    </fieldset> 
			    </div>

			    <div id="GraphLayer_Column" style="display:none;">
			    <fieldset style='width: 100%;margin:5px;'><legend class=gbTitle><%=Translate.Translate("Graph")%>&nbsp;</legend>
				    <asp:Literal id="ColumnGraph" runat="server"></asp:Literal>
			    </fieldset> 
			    </div>

                <asp:Literal id="StatInfoData" runat="server"></asp:Literal>

			    <div id="DataLayer" style="display:none;">
			    <p/>
			    <a id="DataAnchor"></a>
			    <fieldset style='width: 100%;margin:5px;'><legend class=gbTitle><%=Translate.Translate("Data")%>&nbsp;</legend>
				    <asp:Literal id="StatList" runat="server"></asp:Literal>
			    </fieldset> 
			    </div>
			    </td>
		    </tr>
	    </table>
    	
	    <iframe frameborder="1" name="EcomStatExport" id="EcomStatExport" width="1" height="1" tabindex="-1" align="right" marginwidth="0" marginheight="0" border="0" src="StatisticView.aspx?XLSExport=0"></iframe>

        <input type="submit" id="SaveParameters" name="SaveParameters" style="display: none" />
            
        <%=cAddInControl1.LoadParameters%>
        	
    </dw:StretchedContainer>
   
    <dw:ContextMenu ID="cmChartType" runat="server">
        <dw:ContextMenuButton ID="cmdLineChart" Text="Line chart" Icon="LineChart" OnClientClick="changeView('LINE');" runat="server" />
        <dw:ContextMenuButton ID="cmdPieChart" Text="Pie chart" Icon="PieChart" OnClientClick="changeView('PIE');" runat="server" />
        <dw:ContextMenuButton ID="cmdColumnChart" Text="Column chart" Icon="BarChart" Checked="true" OnClientClick="changeView('COLUMN');" runat="server" />
    </dw:ContextMenu>
   
    <script type="text/javascript">
        /* 
            Setting the "wmode" property of a Flash movies to "Opaque".
            This will make the absolute-positioned elements (e.g. context-menus) to appear above the Flash content.
        */
        $$('object').each(function(elm) {
            elm.wmode = 'opaque';
        });
    </script>
   
    <asp:Literal id="JsBlock" runat="server"></asp:Literal>
    
    <%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
        %>
        
</asp:Content>
