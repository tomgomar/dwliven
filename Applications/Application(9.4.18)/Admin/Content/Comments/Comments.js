
function del(id) {
	if (confirm("Delete?")) {
		location = "List.aspx?Delete=" + id + "&Type=" + Type + "&ItemID=" + ItemID + "&LangID=" + LangID;
		return false;
	}
}

function edit(id) {
	location = "Edit.aspx?ID=" + id;
}

function add() {
	location = "Edit.aspx?ID=0&Type=" + Type + "&ItemID=" + ItemID + "&LangID=" + LangID;
}