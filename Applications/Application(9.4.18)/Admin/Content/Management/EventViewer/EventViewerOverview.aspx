<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EventViewerOverview.aspx.vb" Inherits="Dynamicweb.Admin.EventViewerOverview" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Event viewer</title>
        <dw:ControlResources ID="ctrlResources" runat="server" >
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerOverview.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerOverview.css" />
        </Items>
    </dw:ControlResources>    
</head>
<body class="screen-container">
    <form id="form1" runat="server" onsubmit="EventViewerOverview.showWaitSpinner();">        
        <dw:Overlay ID="PleaseWait" runat="server" />

        <div class="card">
            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Indhold" runat="server" ID="tabContent">
                    <dw:RibbonBarGroup runat="server" Name="Rediger">
                        <dw:RibbonBarButton ID="EmailNotification" runat="server" Size="Small" Text="Email notification" Icon="Email" OnClientClick="EventViewerOverview.showEmailNotification();"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>				    
                </dw:RibbonBarTab>
            </dw:RibbonBar>
            <div id="EventListContent">
                <dw:List ID="eventList" runat="server" Title="Event viewer" ShowTitle="true" ShowPaging="true" Personalize="true">
                    <Filters>
                        <dw:ListAutomatedSearchFilter runat="server" ID="TextFilter" Priority="2" WaterMarkText=""/>                        
                        <dw:ListDropDownListFilter ID="LogEventLevelFilter" Width="100" Label="Minimum log-level" AutoPostBack="true" Priority="3" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="Information" Value="information,warning,error" />
                                <dw:ListFilterOption Text="Warning" Value="warning,error" selected="true" />
                                <dw:ListFilterOption Text="Error" Value="error" />                               
                            </Items>
                        </dw:ListDropDownListFilter>
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Paging size" AutoPostBack="true" Priority="4" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="5" Value="5" DoTranslate="false" />
                                <dw:ListFilterOption Text="20" Value="20" DoTranslate="false" />
                                <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" Selected="true"/>
                                <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                                <dw:ListFilterOption Text="500" Value="500" DoTranslate="false" />                                
                            </Items>
                        </dw:ListDropDownListFilter>
                        <dw:ListDropDownListFilter ID="DurationFilter" Width="150" Label="Time period" AutoPostBack="true" Priority="4" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="Any" Value="" DoTranslate="false" />
                                <dw:ListFilterOption Text="24 hours" Value="day" DoTranslate="false" Selected="true" />
                                <dw:ListFilterOption Text="Last week" Value="week" DoTranslate="false" Selected="true" />
                                <dw:ListFilterOption Text="Last month" Value="month" DoTranslate="false" />
                                <dw:ListFilterOption Text="Last 3 months" Value="quarter" DoTranslate="false" />
                                <dw:ListFilterOption Text="Last 6 months" Value="halfyear" DoTranslate="false" />
                                <dw:ListFilterOption Text="Last Year" Value="year" DoTranslate="false" />
                            </Items>
                        </dw:ListDropDownListFilter>
                    </Filters>
                </dw:List>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        if (doPostBack) {
            document.getElementsByClassName("submitImage input-group-addon")[0].click();
        }
    </script>
</body>
</html>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>