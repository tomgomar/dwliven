<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Setup.aspx.vb" Inherits="Dynamicweb.Admin.Setup" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true"
        IncludePrototype="false" />
    <link rel="StyleSheet" href="Setup.css" type="text/css" />
    <script type="text/javascript" src="Setup.js"></script>
    <title></title>
</head>
<body onload="start();">
    <div runat="server" id="closeJs" visible="false">
        <script type="text/javascript">
            close();
        </script>
    </div>
    <form id="experimentSetupForm" method="post" action="Setup.aspx">
        <input type="hidden" runat="server" id="ExperimentType" name="ExperimentType" />
        <input type="hidden" runat="server" id="ExperimentID" name="ExperimentID" />
        <input type="hidden" runat="server" id="StepName" name="StepName" value="" />
        <input type="hidden" runat="server" id="id" name="id" />
        <div id="step1ChooseType" style="display: none;">
            <div class="mainArea">
                <div runat="server" id="ContentBasedTestOption" class="option" onclick="setType(2);">
                    <b><%= Translate.Translate("Content based split test")%></b>
                    <ul>
                        <li><%= Translate.Translate("Test different versions of paragraphs against each other.")%></li>
                        <li><%= Translate.Translate("Use this split test if you want to test different design elements such as buttons.")%></li>
                        <li><%= Translate.Translate("Use this split test if you want to test different texts and images.")%></li>
                        <li><%= Translate.Translate("Copies paragraphs in different version that can be differentiated.")%></li>
                    </ul>
                </div>
                <div class="option" onclick="setType(1);">
                    <b><%= Translate.Translate("Page based split test")%></b>
                    <ul>
                        <li><%= Translate.Translate("Test two different pages against each other.")%></li>
                        <li><%= Translate.Translate("Use this split test if you want to test different layouts.")%></li>
                        <li><%= Translate.Translate("Select another page to test against this one.")%></li>
                    </ul>
                </div>
            </div>
            <div class="footer">
            </div>
        </div>
        <div id="step2ChooseAlternatePage" style="display: none;">
            <div class="mainArea">
                <div class="option2" onclick="observerAlternateLink();">
                    <b><%= Translate.Translate("Alternate page")%></b>
                    <ul>
                        <li><%= Translate.Translate("Choose a page that will be shown as alternative.")%><br />
                            <br />
                            <dw:LinkManager ID="ExperimentAlternatePage" runat="server" DisableFileArchive="true" 
                                DisableParagraphSelector="true" DisableTyping="true" />
                        </li>
                    </ul>
                </div>
            </div>
            <div class="footer">
                <input type="button" class="btn" value="<%= Translate.Translate("Previous")%>" onclick="showStep('step1ChooseType');" />
                <input type="button" class="btn" value="<%= Translate.Translate("Next")%>" id="step2ChooseAlternatePageforwardButton" disabled="disabled"
                    onclick="showStep('step3ChooseGoal');" />
            </div>
        </div>
        <div id="step3ChooseGoal" style="display: none;">
            <div class="mainArea">
                <div class="option2" style="cursor: auto;">
                    <b><%= Translate.Translate("Conversion goal")%></b>
                    <ul>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypePage" FieldValue="Page"
                                runat="server" OnClientClick="showInput('inputAlternativePage');" />
                            <label for="ExperimentGoalTypePage">
                                <%= Translate.Translate("Choose another page as conversion page")%></label><br />
                            <div style="margin-left: 22px; margin-top: 5px; display: none;" id="inputAlternativePage">
                                <dw:LinkManager ID="ExperimentGoalTypePageValue" runat="server" DisableFileArchive="true"
                                    DisableParagraphSelector="true" DisableTyping="true" />
                            </div>
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeItem" FieldValue="Item"
                                runat="server" OnClientClick="showInput('inputItemType');" />
                            <label for="ExperimentGoalTypeItem">
                                <%= Translate.Translate("Create an item")%></label><br />
                            <div style="margin-left: 22px; margin-top: 5px; display: none;" id="inputItemType">
                                <dw:Richselect ID="ItemTypeSelect" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                                </dw:Richselect>
                            </div>
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeForm" FieldValue="Form"
                                runat="server" OnClientClick="showInput('inputForm');" />
                            <label for="ExperimentGoalTypeForm">
                                <%= Translate.Translate("Submitting af form from the forms module")%></label><br />
                            <div style="margin-left: 22px; margin-top: 5px; display: none;" id="inputForm">
                                <select name="ExperimentGoalTypeFormValue" id="ExperimentGoalTypeFormValue">
                                    <asp:Literal ID="FormList" runat="server"></asp:Literal>
                                </select>
                            </div>
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeCart" FieldValue="Cart"
                                runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypeCart">
                                <%= Translate.Translate("Adding products to cart")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeOrder" FieldValue="Order"
                                runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypeOrder">
                                <%= Translate.Translate("Placing an order")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeFile" FieldValue="File"
                                runat="server" OnClientClick="showInput('inputDownloadFile');" />
                            <label for="ExperimentGoalTypeFile">
                                <%= Translate.Translate("Downloading a file")%></label><br />
                            <div id="inputDownloadFile" style="margin-left: 22px; margin-top: 5px; display: none;">
                                <dw:FileManager ID="ExperimentGoalTypeFileValue" runat="server" Folder="Files" />
                                <small><%= Translate.Translate("(Must be in /Files/")%><%= Dynamicweb.Content.Files.FilesAndFolders.GetFilesFolderName()%>
                                    <%= Translate.Translate("folder)")%></small>
                            </div>
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeNewsletter"
                                FieldValue="Newsletter" runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypeNewsletter">
                                <%= Translate.Translate("Signing up for newsletter")%></label><br />
                        </li>
                        <li id="customProviderContentItem" runat="server" style="display: none;">
                            <div id="customProviderContent" runat="server" visible="false">
                                <dw:RadioButton FieldName="ExperimentGoalType" ID="CustomGoalProvider"
                                    FieldValue="CustomGoalProviderType" runat="server" OnClientClick="showInput('inputCustomGoalProvider');" />
                                <label for="ExperimentGoalTypeCustomGoalProviderType"><%= Translate.Translate("Custom providers")%></label><br />
                                <div id="inputCustomGoalProvider" style="margin-left: 22px; margin-top: 5px; display: none;">
                                    <asp:Literal ID="sourceSelectorScripts" runat="server"></asp:Literal>
                                    <de:AddInSelector ID="sourceSelector" runat="server" ShowOnlySelectedGroup="true"
                                        AddInGroupName="ConversionGoalProvider" UseLabelAsName="True" AddInShowNothingSelected="true"
                                        AddInTypeName="Dynamicweb.Analytics.Goals.ConversionGoalProvider" AddInShowFieldset="false" />
                                    <asp:Literal ID="sourceSelectorLoadScript" runat="server"></asp:Literal>
                                </div>
                            </div>
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeTimespent" FieldValue="Timespent"
                                runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypeTimespent">
                                <%= Translate.Translate("Maximize time spent on site")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeHighestAverageValueOrder" FieldValue="HighestAverageValueOrder"
                                runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypeHighestAverageValueOrder">
                                <%= Translate.Translate("Highest average order value")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeHighestAverageMarkupOrder" FieldValue="HighestAverageMarkupOrder"
                                runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypeHighestAverageMarkupOrder">
                                <%= Translate.Translate("Highest average markup order")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypeBounce" FieldValue="Bounce"
                                runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypeBounce">
                                <%= Translate.Translate("Minimize bounce rate")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentGoalType" ID="ExperimentGoalTypePageviews" FieldValue="Pageviews"
                                runat="server" OnClientClick="showInput();" />
                            <label for="ExperimentGoalTypePageviews">
                                <%= Translate.Translate("Maximize page views")%></label><br />
                        </li>
                    </ul>
                </div>
            </div>
            <div class="footer">
                <input type="button" class="btn" value="<%= Translate.Translate("Previous")%>" onclick="showStep('step1ChooseType');" />
                <input type="submit" class="btn" value="" id="step3ChooseGoalNext" disabled="disabled" onclick="return verifyGoal();" runat="server" />
            </div>
        </div>
        <div id="step4Settings" style="display: none;">
            <div class="mainArea">
                <div class="option2" style="cursor: auto;" onclick="observerAlternateLink();">
                    <b><%= Translate.Translate("Settings")%></b>
                    <ul>
                        <li><b><%= Translate.Translate("Split test name")%></b></li>
                        <li>
                            <input type="text" class="NewUIinput" name="ExperimentName" id="ExperimentName" runat="server"
                                onkeyup="validateName();" />
                        </li>
                    </ul>
                    <ul>
                        <input type="hidden" runat="server" id="ExperimentGoalTypeFormValueHidden" name="ExperimentGoalTypeFormValueHidden" />
                        <li><b><%= Translate.Translate("Split test type: ")%></b><label id="TranslatelabelType" runat="server"></label></li>
                    </ul>
                    <ul>
                        <li><b><%= Translate.Translate("Conversion goal: ")%></b><label id="TranslatelabelGoal" runat="server"></label></li>
                    </ul>
                    <ul>
                        <li><b><%= Translate.Translate("Active")%></b></li>
                        <li>
                            <dw:CheckBox FieldName="ExperimentActive" Value="True" Checked="True" runat="server" ID="ExperimentActive" />
                            <label for="ExperimentActive">
                                <%= Translate.Translate("This split test is active")%></label></li>
                    </ul>
                    <ul id="ExperimentMeasureSettings" runat="server">
                        <li><b><%= Translate.Translate("Conversion metrics")%></b></li>
                        <li>
                            <dw:RadioButton ID="ExperimentConversionMetric1200" FieldName="ExperimentConversionMetric"
                                FieldValue="1200" runat="server" />
                            <label for="ExperimentConversionMetric1200">
                                <%= Translate.Translate("Register conversion through entire visit.")%>
                            </label>
                            <br />
                        </li>
                        <li>
                            <dw:RadioButton ID="ExperimentConversionMetric0" FieldName="ExperimentConversionMetric"
                                FieldValue="0" runat="server" />
                            <label for="ExperimentConversionMetric0">
                                <%= Translate.Translate("Register conversion in next step only.")%></label><br />
                        </li>
                    </ul>
                    <ul>
                        <li><b><%= Translate.Translate("Traffic sent through this split test")%></b></li>
                        <li><%= Translate.Translate("Visitors to include")%>
                            <dw:RadioButton ID="ExperimentIncludes100" FieldName="ExperimentIncludes" FieldValue="100"
                                SelectedFieldValue="0" runat="server" />
                            <label for="ExperimentIncludes100">
                                100%</label>
                            <dw:RadioButton ID="ExperimentIncludes75" FieldName="ExperimentIncludes" FieldValue="75"
                                SelectedFieldValue="0" runat="server" />
                            <label for="ExperimentIncludes75">
                                75%</label>
                            <dw:RadioButton ID="ExperimentIncludes50" FieldName="ExperimentIncludes" FieldValue="50"
                                SelectedFieldValue="0" runat="server" />
                            <label for="ExperimentIncludes50">
                                50%</label>
                            <dw:RadioButton ID="ExperimentIncludes25" FieldName="ExperimentIncludes" FieldValue="25"
                                SelectedFieldValue="0" runat="server" />
                            <label for="ExperimentIncludes25">
                                25%</label>
                            <dw:RadioButton ID="ExperimentIncludes10" FieldName="ExperimentIncludes" FieldValue="10"
                                SelectedFieldValue="0" runat="server" />
                            <label for="ExperimentIncludes10">
                                10%</label>
                        </li>
                    </ul>
                    <ul style="display: none;">
                        <!--Not implemented yet - does it make sense?-->
                        <li><b><%= Translate.Translate("Subsequent visiting behavior")%></b></li>
                        <li>
                            <dw:RadioButton ID="ExperimentPatternSticky" FieldName="ExperimentPattern" FieldValue="1"
                                runat="server" />
                            <label for="ExperimentPattern1">
                                <%= Translate.Translate("Sticky")%></label><br />
                            <dw:RadioButton ID="ExperimentPatternRandom" FieldName="ExperimentPattern" FieldValue="2"
                                runat="server" />
                            <label for="ExperimentPattern2">
                                <%= Translate.Translate("Random")%></label>
                        </li>
                    </ul>
                    <ul id="ShowToSearchEngineBotsSettings" runat="server">
                        <li><b><%= Translate.Translate("Show to search engine bots")%></b></li>
                        <li>
                            <dw:RadioButton ID="ExperimentShowToBots1" FieldName="ExperimentShowToBots" FieldValue="0"
                                runat="server" />
                            <label for="ExperimentShowToBots1">
                                <%= Translate.Translate("Show original to search engines.")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton ID="ExperimentShowToBots0" FieldName="ExperimentShowToBots" FieldValue="1"
                                runat="server" />
                            <label for="ExperimentShowToBots0">
                                <%= Translate.Translate("Show all versions to search engines.")%></label><br />
                        </li>
                    </ul>
                </div>
            </div>
            <div class="footer">
                <input type="button" class="btn" value="" id="SettingsPreviousBtn" runat="server" onclick="showStep('step3ChooseGoal');" />
                <input type="button" class="btn" value="" id="SettingNextBtn" disabled="disabled" runat="server" onclick="showStep('step5ExperimentEnding');" />
            </div>
        </div>

        <div id="step5ExperimentEnding" style="display: none;">
            <div class="mainArea">
                <div class="option2" style="cursor: auto;">
                    <b><%= Translate.Translate("End split test")%></b>
                    <ul>
                        <li>
                            <dw:RadioButton FieldName="ExperimentEndingType" ID="ExperimentEndingTypeManually" FieldValue="1"
                                runat="server" OnClientClick="showEndingTypeParams('divActionAndNotification');" />
                            <label for="ExperimentEndingTypeManually">
                                <%= Translate.Translate("Manually")%></label><br />
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentEndingType" ID="ExperimentEndingTypeAtGivenTime" FieldValue="2"
                                runat="server" OnClientClick="showEndingTypeParams('divAtGivenTime');" />
                            <label for="ExperimentEndingTypeAtGivenTime">
                                <%= Translate.Translate("At given time")%></label><br />
                            <div id="divAtGivenTime" style="margin-left: 22px; margin-top: 5px; display: none;">
                                <dw:DateSelector ID="sdEndDate" runat="server" IncludeTime="True" />
                                <br />
                                <select name="ExperimentEndingTypeTimeZone" id="SelectExperimentEndingTypeTimeZone" style="width: 350px;">
                                    <asp:Literal ID="LiteralTimeZone" runat="server"></asp:Literal>
                                </select>
                            </div>
                        </li>
                        <li>
                            <dw:RadioButton FieldName="ExperimentEndingType" ID="ExperimentEndingTypeAfterXViews" FieldValue="3"
                                runat="server" OnClientClick="showEndingTypeParams('divAfterXViews');" />
                            <label for="ExperimentEndingTypeAfterXViews">
                                <%= Translate.Translate("After x views")%></label><br />
                            <div id="divAfterXViews" style="margin-left: 22px; margin-top: 5px; display: none;">
                                <omc:NumberSelector ID="endViewsAmount" AllowNegativeValues="false" MinValue="1" MaxValue="1000000" runat="server" />
                            </div>
                        </li>
                        <% If IsProbabilityAvailable() Then%>
                        <li>
                            <dw:RadioButton FieldName="ExperimentEndingType" ID="ExperimentEndingTypeIsSignificant" FieldValue="4"
                                runat="server" OnClientClick="showEndingTypeParams();" />
                            <label for="ExperimentEndingTypeIsSignificant">
                                <%= Translate.Translate("When result is significant")%></label><br />
                        </li>
                        <%End If%>
                    </ul>
                    <div id="divActionAndNotification" style="display: none;">
                        <ul>
                            <li><b><%= Translate.Translate("Action after split test ends")%></b></li>
                            <li>
                                <dw:CheckBox FieldName="DeleteExperiment" Value="True" runat="server" ID="cbDeleteExperiment" />
                                <label for="cbDeleteExperiment">
                                    <%= Translate.Translate("Stop experiment (all data on visitors and conversions will be deleted)")%>
                                </label>
                            </li>
                        </ul>
                        <div id="divKeepVersions">
                            <ul>
                                <li>
                                    <dw:RadioButton FieldName="ExperimentEndingActionType" ID="ExperimentEndingActionTypeKeepAll" FieldValue="1" runat="server" />
                                    <label for="ExperimentEndingActionTypeKeepAll">
                                        <%= Translate.Translate("Keep all versions with the best performing published")%></label><br />
                                </li>
                                <li>
                                    <dw:RadioButton FieldName="ExperimentEndingActionType" ID="ExperimentEndingActionTypeKeepBestPerforming" FieldValue="2" runat="server" />
                                    <label for="ExperimentEndingActionTypeKeepBestPerforming">
                                        <%= Translate.Translate("Keep the best performing version and delete the other")%></label><br />
                                </li>
                            </ul>
                        </div>
                        <ul>
                            <li><b><%= Translate.Translate("Notification e-mail template:")%></b></li>
                            <li>
                                <dw:FileManager ID="fmTemplate" runat="server" Folder="Templates/OMC/Notifications" File="EmailExperimentAutoStop.html" />
                            </li>
                            <li><b><%= Translate.Translate("Notify following people:")%></b></li>
                            <li>
                                <omc:EditableListBox ID="editNotify" runat="server" />
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="footer">
                <input type="button" class="btn" value="<%= Translate.Translate("Previous")%>" onclick="showStep('step4Settings');" />
                <input type="button" class="btn" value="" id="SaveExperimentBtn" runat="server" onclick="saveExperiment();" />
            </div>
        </div>
    </form>
    <script type="text/javascript">
        <%= _ErrorMsgJS%>
        var PageBasedSplitTestTranslated = '<%= Translate.Translate("Page based split test.")%>';
        var ContentBasedSplitTestTranslated = '<%= Translate.Translate("Content based split test.")%>';
        var OpenAnotherPageAsConversionPage = '<%= Translate.Translate("Open another page as conversion page")%>';
        var AnyItemType = '<%= Translate.Translate("Any item type")%>';
        var SubmittingAnItemFromTheItemCreatorModule = '<%= Translate.Translate("Create an item")%>';
        var SubmittingAFormFromTheFormsModule = '<%= Translate.Translate("Submitting af form from the forms module")%>';
        var AddingProductsToCart = '<%= Translate.Translate("Adding products to cart")%>';
        var PlacingAnOrder = '<%= Translate.Translate("Placing an order")%>';
        var DownloadingFile = '<%= Translate.Translate("Downloading file")%>';
        var SigningUpForNewsletter = '<%= Translate.Translate("Signing up for newsletter")%>';
        var MaximizeTimeSpentOnSite = '<%= Translate.Translate("Maximize time spent on site")%>';
        var MinimizeBounceRate = '<%= Translate.Translate("Minimize bounce rate")%>';
        var MaximizePageViews = '<%= Translate.Translate("Maximize page views")%>';
        var HighestAverageOrderValueGoalProvider = '<%= Translate.Translate("Highest average order value")%>';
        var HighestAverageMarkupGoalProvider = '<%= Translate.Translate("Highest average markup order")%>';

        validateName();
        if ($('ExperimentEndingType2') && $('ExperimentEndingType2').checked) {
            showEndingTypeParams('divAtGivenTime');
        } else if ($('ExperimentEndingType3') && $('ExperimentEndingType3').checked) {
            showEndingTypeParams('divAfterXViews');
        } else if ($('ExperimentEndingType4') && $('ExperimentEndingType4').checked) {
            showEndingTypeParams();
        }
    </script>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
