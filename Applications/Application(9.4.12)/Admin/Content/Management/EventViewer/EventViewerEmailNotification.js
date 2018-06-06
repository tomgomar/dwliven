var EventViewerEmailNotification = {    
    save: function () {        
        document.getElementById('MainForm').submit();
    },
    saveAndClose: function () {
        document.getElementById('cmdValue').value = "SaveAndClose";
        this.save();
    },
    cancel: function () {
        location = '/Admin/Content/Management/EventViewer/EventViewerOverview.aspx' + location.search;
    }
}