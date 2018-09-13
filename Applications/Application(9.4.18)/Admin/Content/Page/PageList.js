var pageList = {
    pageId: 0,
    areaId: 0,
    parentPageId: 0,

    initialize: function (pageId, areaId, parentPageId) {
        this.pageId = pageId;
        this.areaId = areaId;
        this.parentPageId = parentPageId;
    },

    showPage: function (pageId) {
        if (pageId) {
            this.showWait();
            location = "/Admin/Content/ParagraphList.aspx?PageID=" + pageId;
        }
    },

    createPage: function () {
        this.showWait();
        location = "/Admin/Content/Items/Editing/PageTypeSelect.aspx?ID=0&ParentPageID=" + this.pageId + "&AreaID=" + this.areaId;
    },

    cancel: function () {
        if (this.parentPageId > 0) {
            location = "/Admin/Content/ParagraphList.aspx?PageID=" + this.parentPageId;
        }
        else {
            location = "/Admin/Blank.aspx";
        }
    },

    switchToItem: function () {
        this.showWait();
        location = "/Admin/Content/Items/Editing/ItemEdit.aspx?PageID=" + this.pageId;
    },

    switchToParagraphs: function () {
        this.showWait();
        location = "/Admin/Content/ParagraphList.aspx?PageID=" + this.pageId + "&mode=viewparagraphs";
    },

    showProperties: function () {
        this.showWait();
        location = "/Admin/Content/Page/PageEdit.aspx?ID=" + this.pageId;
    },

    showWait: function () {
        new overlay('PleaseWait').show();
    }
}