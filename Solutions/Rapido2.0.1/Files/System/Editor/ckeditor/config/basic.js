CKEDITOR.editorConfig = function (config) {
	// Define changes to default configuration here.
	// For the complete reference:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config

	// The toolbar groups arrangement, optimized for two toolbar rows.
	config.toolbarGroups = [{
		name: 'styles'
	}, {
		name: 'basicstyles',
		groups: ['basicstyles', 'cleanup']
	}, {
		name: 'paragraph',
		groups: ['list', 'indent', 'blocks', 'align']
	}, {
		name: 'clipboard',
		groups: [
			'clipboard', 'undo'
		]
	}, {
		name: 'editing',
		groups: ['find', 'selection', 'spellchecker']
	}, {
		name: 'links'
	}, {
		name: 'insert'
	}, {
		name: 'tools'
	}, {
		name: 'document',
		groups: ['mode', 'document', 'doctools']
		// }, {
		// 	name: 'others'
	}, {
		name: 'about'
	}];

	// Remove some buttons, provided by the standard plugins, which we don't need to have in the Standard(s) toolbar.
	config.removeButtons = 'Strike,Underline,Subscript,Superscript,Indent,Outdent,Styles';

	config.entities = false;

	config.filebrowserBrowseUrl = '/Admin/Editor/ckeditor/browser.aspx?type=link';
	config.filebrowserImageBrowseUrl = '/Admin/Editor/ckeditor/browser.aspx?type=image';
};
