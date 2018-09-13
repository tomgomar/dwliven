<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Statistics.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.Statistics" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls.Charts" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" TagName="ValidationList" Src="~/Admin/Module/OMC/Controls/ValidationList.ascx" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>


<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <script>
        var markers = null;

        function showUniqueLinks(type) {
            if (type == 'total') {
                document.getElementById("UniqueLinksDiv").style.display = "none";
                document.getElementById("TotalLinksDiv").style.display = "block";
            } else {
                document.getElementById("UniqueLinksDiv").style.display = "block";
                document.getElementById("TotalLinksDiv").style.display = "none";
            }
        }


        function ShowLinkPopup(emailId, linkId) {
            var act = <%=GetShowLinkDetailsDialogAction().ToJson()%>;
            Action.Execute(act, {
                emailId: emailId,
                linkId: linkId
            });
        }

        function retryEmail(emailId) {
            var url = "/Admin/Module/OMC/Emails/Statistics.aspx?OpType=RetryEmail&newsletterID=" + emailId;
            dwGlobal.marketing.navigate(url);
        }

        function refreshStatistics() {
            var url = "/Admin/Module/OMC/Emails/Statistics.aspx?newsletterID=<%=Request("newsletterID")%>";
            dwGlobal.marketing.navigate(url);
        }

        function showBounces() {
            var emailId = "<%=Request("newsletterID")%>";
            var title = "<%= Translate.Translate("Failures")%>";
                dwGlobal.marketing.showDialog(
                                        '/Admin/Module/OMC/Emails/ValidateEmail.aspx?EmailId=' + emailId + '&Failures=true',
                                        800,
                                        600,
                                        { title: title, hideCancelButton: true });
        }

        var gmarkers = [];
        var gicons = [];
        var map = null;
        var infowindow = null;
        var getInfoWindow = function () {
            infowindow = infowindow || new google.maps.InfoWindow();
            return infowindow;
        }

        function initializeMap() {

            if (navigator.userAgent.indexOf('MSIE') != -1) {
                $('UserLocationContainer').style.width = "850px";
            } else {
                $('UserLocationContainer').style.width = "895px";
            }

            var myLatlng = new google.maps.LatLng(55.41, 12.34);
            var myOptions = {
                zoom: 8,
                center: myLatlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }

            myOptions.center = myLatlng;
            map = new google.maps.Map(document.getElementById("UserLocationContainer"), myOptions);

            for (var i = 0; i < markers.length; i++) {
                if (markers[i]) {
                    var lat = markers[i][0];
                    var lng = markers[i][1];
                    var point = new google.maps.LatLng(lat, lng);
                    var name = markers[i][2];
                    var email = markers[i][3];
                    var html = "";

                    if (name.indexOf("N/A") != -1) {
                        html = "<b>" + email + "<\/b><p>";
                    } else {
                        html = "<b>" + name + "<\/b><p>" + email;
                    }

                    if (markers[i][6] && markers[i][7] > 0) {
                        html += "<br><p><a href=\"#\" onclick=\"ShowUserPopup(" + markers[i][6] + "," + markers[i][7] + ',\'' + name + '\');\">Recipient details</a>';
                    }

                    var country = markers[i][4];
                    var category = markers[i][5];
                    var marker = createMarker(point, name, category, country, html);
                }
            }

            google.maps.event.addListener(map, 'click', function () {
                var iw = getInfoWindow();
                if (iw) {
                    iw.close();
                }
            });

            google.maps.event.addListener(map, 'zoom_changed', function () {
                showMarkersClaster();
            });

            showCategory("opened");
            hideCategory("clicked");
            hideCategory("bought");
            hideCategory("unsubscribed");

            showMarkersClaster();
            makeSidebar();
        }

        function createMarker(latlng, name, category, country, html) {
            var contentString = html;
            var marker = new google.maps.Marker({
                position: latlng,
                map: map,
                title: name
            });

            marker.markerCategory = category;
            marker.markerName = name;
            marker.markerCountry = country;
            gmarkers.push(marker);

            google.maps.event.addListener(marker, 'click', function () {
                var iw = getInfoWindow();
                if (iw) {
                    iw.setContent(contentString);
                    iw.open(map, marker);
                }
            });
        }

        function showCategory(category) {
            for (var i = 0; i < gmarkers.length; i++) {
                if (gmarkers[i] && gmarkers[i].markerCategory == category) {
                    gmarkers[i].setVisible(true);
                }
            }
            $("ch" + category).checked = true;
        }

        function hideCategory(category) {
            for (var i = 0; i < gmarkers.length; i++) {
                if (gmarkers[i] && gmarkers[i].markerCategory == category) {
                    gmarkers[i].setVisible(false);
                }
            }
            $("ch" + category).checked = false;
            var iw = getInfoWindow();
            if (iw) {
                iw.close();
            }
        }

        function showMarkers(box, category) {
            if (box.checked) {
                showCategory(category);
            } else {
                hideCategory(category);
            }
            makeSidebar();
            showMarkersClaster();
        }

        function locateToCountry(country) {
            var geocoder = new google.maps.Geocoder();
            geocoder.geocode({ 'address': country }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    map.setCenter(results[0].geometry.location);
                } else {
                    alert("Geocode was not successful for the following reason: " + status);
                }
            });
        }

        function makeSidebar() {
            var html = "";
            var countries = [];
            var recipientCounter = 0;
            for (var i = 0; i < gmarkers.length; i++) {
                if (gmarkers[i].getVisible()) {
                    recipientCounter = 0;
                    for (var j = 0; j < gmarkers.length; j++) {
                        if (gmarkers[j].getVisible() && (gmarkers[i].markerCountry == gmarkers[j].markerCountry)) {
                            recipientCounter++;
                        }
                    }

                    if (countries.indexOf(gmarkers[i].markerCountry) != -1) {
                        break;
                    } else {
                        countries.push(gmarkers[i].markerCountry);
                    }
                    html += '<a href="javascript:locateToCountry(\'' + gmarkers[i].markerCountry + '\')">' + gmarkers[i].markerCountry + '(' + recipientCounter + ')<\/a><br>';
                }
            }
            $("sideBar").innerHTML = html;
        }

        function showMarkersClaster() {
            var mcOptions = { gridSize: 100, maxZoom: 15 };
            var mcMarkers = [];
            for (var i = 0; i < gmarkers.length; i++) {
                if (gmarkers[i].getVisible()) {
                    mcMarkers.push(gmarkers[i]);
                }
            }
            var markerCluster = new MarkerClusterer(map, mcMarkers, mcOptions);
        }

        function ExportStat(datatype) {
            var url = '/Admin/Module/OMC/Emails/Statistics.aspx?emailId=<%=Request("newsletterID")%>&OpType=ExportToCSV&datatype=' + datatype;

            setTimeout(function () {
                form = new Element('form', { method: 'post', action: url });

                document.body.appendChild(form);
                form.submit();

                document.body.removeChild(form);
            }, 50);
        }

        document.observe("dom:loaded", function () {
            showUniqueLinks();
        });
    </script>    
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
            <dw:ToolbarButton ID="cmdRefresh" Icon="Refresh" Text="Refresh" runat="server" OnClientClick="refreshStatistics()" />
            <dw:ToolbarButton ID="cmdExport" Icon="SignOut" Text="Export" runat="server" OnClientClick="dialog.show('exportDialog')" />
            <dw:ToolbarButton ID="cmdEdit" Icon="Pencil" Text="Email Setup" runat="server" />
            <dw:ToolbarButton ID="cmdRecipients" Icon="Person" Text="Recipients" runat="server" />
            <dw:ToolbarButton ID="cmdShowLog" Icon="InfoCircle" Text="Log" OnClientClick="dialog.show('LogDialog')" runat="server" />
            <dw:ToolbarButton ID="cmdBounces" ImagePath="/Admin/Module/OMC/img/report_export_red_small.png" Text="Failures" OnClientClick="showBounces()" runat="server" />
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <dw:Infobar runat="server" ID="SentCountInfoBar" Visible="False" />
            <dw:Infobar runat="server" ID="infoStatus" Visible="false" />

            <div class="statistics">
                <div class="col-lg-2 col-md-4 col-sm-4">
                    <dwc:GroupBox Title="Recipient activity" runat="server">
                        <div class="col-sm-12 col-xs-7">
                            <dw:Chart ID="cPieOpens" Type="Pie" Width="180" Height="150" Legend="none" AutoDraw="true" runat="server" />
                        </div>
                        <div class="col-sm-12 col-xs-5">
                            <h3>
                                <dw:TranslateLabel ID="TranslateLabel2" Text="Legend" runat="server" />
                            </h3>
                            <ul class="statistics-legend">
                                <li>
                                    <div class="statistics-legend-item" id="legendOpened" runat="server" />
                                    <dw:TranslateLabel ID="TranslateLabel5" Text="Opened emails" runat="server" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendNotOpened" runat="server" />
                                    <dw:TranslateLabel ID="TranslateLabel4" Text="Unopened emails" runat="server" />
                                </li>
                            </ul>
                        </div>
                    </dwc:GroupBox>
                </div>

                <div class="col-lg-7 col-md-12 col-sm-12">
                    <dwc:Groupbox Title="Highlights" runat="server">
                        <asp:Repeater ID="repGeneral" runat="server">
                            <HeaderTemplate>
                                <table class="dashboard-most-visits table table-striped">
                                    <thead>
                                        <tr>
                                            <th class="text-left">
                                                <dw:TranslateLabel ID="lbRate" Text="General" runat="server" />
                                            </th>
                                            <th class="text-left">
                                                <dw:TranslateLabel ID="lbTotal" Text="Total" runat="server" />
                                            </th>
                                        </tr>
                                    </thead>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("IndexName")%></td>
                                    <td><b><%# Eval("EngagementValue")%></b></td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr class="dashboard-row-alternative">
                                    <td><%# Eval("IndexName")%></td>
                                    <td><b><%# Eval("EngagementValue")%></b></td>
                                </tr>
                            </AlternatingItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </dwc:Groupbox>
                </div>

                <div class="col-lg-3 col-md-4 col-sm-5 col-lg-pull-0 col-md-pull-8 col-sm-pull-7">
                    <dwc:Groupbox Title="Links" runat="server" ClassName="full-width">
                        <dwc:RadioGroup runat="server" Name="MsgLinks" Indent="false" SelectedValue="unique">
                            <dwc:RadioButton runat="server" FieldValue="unique" Label="Unique clicks" OnClick="showUniqueLinks('unique');" />
                            <dwc:RadioButton runat="server" FieldValue="total" Label="Total clicks" OnClick="showUniqueLinks('total');" />
                        </dwc:RadioGroup>

                        <div id="originalLinkDiv">
                            <div id="UniqueLinksDiv" class="overflow-table">
                                <dw:List runat="server" ID="uniqueLinksList" ShowHeader="false" ShowPaging="False" ShowTitle="false" PageSize="25">
                                    <Columns>
                                        <dw:ListColumn runat="server" ID="clmUniqueLinkUrl" WidthPercent="90" />
                                        <dw:ListColumn runat="server" ID="clmUniqueLinkClicks" WidthPercent="10" />
                                    </Columns>
                                </dw:List>
                            </div>
                            <div id="TotalLinksDiv" class="overflow-table">
                                <dw:List runat="server" ID="totalLinksList" ShowHeader="false" ShowPaging="False" ShowTitle="false" PageSize="25">
                                    <Columns>
                                        <dw:ListColumn runat="server" ID="clmTotalLinkUrl" WidthPercent="90" />
                                        <dw:ListColumn runat="server" ID="clmTotalLinkClicks" WidthPercent="10" />
                                    </Columns>
                                </dw:List>
                            </div>
                        </div>
                    </dwc:Groupbox>
                </div>

                <div class="col-lg-2 col-md-4 col-sm-4 clear-left">
                    <dwc:Groupbox runat="server" Title="Browser - Opened">
                        <div class="col-sm-12 col-xs-7">
                            <dw:Chart ID="cPieOpenBrowsers" Type="Pie" Width="180" Height="130" Legend="none" AutoDraw="True" runat="server" />
                        </div>
                        <div class="col-sm-12 col-xs-5">
                            <h3><dw:TranslateLabel ID="TranslateLabel22" Text="Legend" runat="server" /></h3>
                            <ul class="statistics-legend">
                                <li>
                                    <div class="statistics-legend-item" id="legendIE" runat="server" />
                                    <dw:Label ID="TranslateLabel25" Title="Internet Explorer" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendChrome" runat="server" />
                                    <dw:Label ID="TranslateLabel26" Title="Chrome" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendFF" runat="server" />
                                    <dw:Label ID="TranslateLabel27" Title="FireFox" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendSafari" runat="server" />
                                    <dw:Label ID="TranslateLabel28" Title="Safari" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendNA" runat="server" />
                                    <dw:TranslateLabel ID="TranslateLabel29" Text="Other" runat="server" />
                                </li>
                            </ul>
                        </div>
                    </dwc:Groupbox>
                </div>

                <div class="col-lg-2 col-md-4 col-sm-4">
                    <dwc:Groupbox runat="server" Title="Browser - Clicked">
                        <div class="col-sm-12 col-xs-7">
                            <dw:Chart ID="cPieClickBrowsers" Type="Pie" Width="180" Height="130" Legend="none" AutoDraw="True" runat="server" />
                        </div>
                        <div class="col-sm-12 col-xs-5">
                            <h3><dw:TranslateLabel ID="TranslateLabel1" Text="Legend" runat="server" /></h3>
                            <ul class="statistics-legend">
                                <li>
                                    <div class="statistics-legend-item" id="legendIE2" runat="server" />
                                    <dw:Label ID="Label1" Title="Internet Explorer" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendChrome2" runat="server" />
                                    <dw:Label ID="Label2" Title="Chrome" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendFF2" runat="server" />
                                    <dw:Label ID="Label3" Title="FireFox" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendSafari2" runat="server" />
                                    <dw:Label ID="Label4" Title="Safari" runat="server" doTranslation="False" />
                                </li>
                                <li>
                                    <div class="statistics-legend-item" id="legendNA2" runat="server" />
                                    <dw:TranslateLabel ID="TranslateLabel31" Text="Other" runat="server" />
                                </li>
                            </ul>
                        </div>
                    </dwc:Groupbox>
                </div>

                <div class="col-lg-2 col-md-4 col-sm-4">
                    <dwc:Groupbox runat="server" Title="Email Client - Opened">
                        <div class="col-sm-12 col-xs-7">
                            <dw:Chart ID="cPieOpenEmailClient" Type="Pie" Width="180" Height="130" Legend="none" AutoDraw="True" runat="server" />
                        </div>
                        <div class="col-sm-12 col-xs-5">
                           <h3><dw:TranslateLabel ID="TranslateLabel7" Text="Legend" runat="server" /></h3>
                            <ul class="statistics-legend">
	                            <li>
		                            <div class="statistics-legend-item" id="legendGmailOpened" runat="server" />
		                            <dw:Label ID="Label15" Title="Gmail" runat="server" doTranslation="False" />
	                            </li>
	                            <li>
		                            <div class="statistics-legend-item" id="legendAndroidOpened" runat="server" />
		                            <dw:Label ID="Label16" Title="Google Android" runat="server" doTranslation="False" />
	                            </li>
	                            <li>
		                            <div class="statistics-legend-item" id="legendIpadOpened" runat="server" />
		                            <dw:Label ID="Label17" Title="Apple iPad" runat="server" doTranslation="False" />
	                            </li>
	                            <li>
		                            <div class="statistics-legend-item" id="legendIphoneOpened" runat="server" />
		                            <dw:Label ID="Label18" Title="Apple iPhone" runat="server" doTranslation="False" />
	                            </li>
	                            <li>
		                            <div class="statistics-legend-item" id="legendAppleMailOpened" runat="server" />
		                            <dw:Label ID="Label19" Title="Apple Mail" runat="server" doTranslation="False" />
	                            </li>
	                            <li>
		                            <div class="statistics-legend-item" id="legendOutlookOpened" runat="server" />
		                            <dw:Label ID="Label20" Title="Outlook" runat="server" doTranslation="False" />
	                            </li>
	                            <li>
		                            <div class="statistics-legend-item" id="legendOutlookcomOpened" runat="server" />
		                            <dw:Label ID="Label21" Title="Outlook.Com" runat="server" doTranslation="False" />
	                            </li>
	                            <li>
		                            <div class="statistics-legend-item" id="legendOtherOpened" runat="server" />
		                            <dw:TranslateLabel ID="TranslateLabel8" Text="Other" runat="server" />
	                            </li>
                            </ul>
                        </div>
                    </dwc:Groupbox>
                </div>
            </div>
            
            <dw:Dialog ShowOkButton="True" OkText="Close" Title="Export" runat="server" ID="exportDialog" Width="500">
                <table class="table table-hover">
                    <tr>
                        <td><a class="toolbar-button" href="#" onclick="ExportStat('Highlights');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Highlights")%></span></a></td>
                    </tr>
                    <tr>
                        <td><a class="toolbar-button" href="#" onclick="ExportStat('Engagement');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Engagement")%></span></a></td>
                    </tr>
                    <tr><td><a class="toolbar-button" href="#" onclick="ExportStat('Recipents');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Recipents")%></span></a></td></tr>
                    <tr><td><a class="toolbar-button" href="#" onclick="ExportStat('Links');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Links")%></span></a></td></tr>
                    <tr><td><a class="toolbar-button" href="#" onclick="ExportStat('Browsers');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Browsers")%></span></a></td></tr>
                    <tr><td><a class="toolbar-button" href="#" onclick="ExportStat('Platforms');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Platforms")%></span></a></td></tr>
                    <tr><td><a class="toolbar-button" href="#" onclick="ExportStat('EmailClient');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Email Client")%></span></a></td></tr>
                    <tr><td><a class="toolbar-button" href="#" onclick="ExportStat('Responses');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("Recipients responses")%></span></a></td></tr>
                    <tr><td><a class="toolbar-button" href="#" onclick="ExportStat('All');">
                            <span class="toolbar-button-container">
                                <img style="vertical-align: middle;" src="/Admin/Images/Ribbon/Icons/Small/export1.png" alt="%20" />
                                <%=Translate.Translate("All (zip folder)")%></span></a></td></tr>
                </table>
            </dw:Dialog>
            <dw:Dialog ShowOkButton="True" OkText="Close" Title="Log" runat="server" ID="LogDialog" Width="500">
                <div style="position:relative;">
                   <iframe src="/Admin/Module/OMC/Emails/StatisticsIncompleteRecipients.aspx?newsletterID=<%= HttpContext.Current.Request("newsletterID") %>" style="z-index:1000;position:relative;">                   
                   </iframe>
                    <i class="fa fa-refresh fa-3x fa-spin" style="position:absolute;top:222px;left:372px;z-index:0;"></i>
                </div>
            </dw:Dialog>
            <dw:Dialog runat="server" ID="pwDialog" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" HidePadding="true">
                <iframe id="pwDialogFrame"></iframe>
            </dw:Dialog>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>

