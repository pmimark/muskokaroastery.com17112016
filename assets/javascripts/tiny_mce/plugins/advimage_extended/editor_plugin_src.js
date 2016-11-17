/**
 * editor_plugin_src.js
 *
 * Copyright 2009, Moxiecode Systems AB
 * Released under LGPL License.
 *
 * License: http://tinymce.moxiecode.com/license
 * Contributing: http://tinymce.moxiecode.com/contributing
 */

(function() {
	tinymce.create('tinymce.plugins.AdvancedImageExtendedPlugin', {
		init : function(ed, url) {
			// Register commands
			ed.addCommand('mceAdvImageExtended', function() {
				// Internal image object like a flash placeholder
				if (ed.dom.getAttrib(ed.selection.getNode(), 'class').indexOf('mceItem') != -1)
					return;

				ed.windowManager.open({
					file : url + '/image.htm',
					width : 480 + parseInt(ed.getLang('advimage_extended.delta_width', 0)),
					height : 385 + parseInt(ed.getLang('advimage_extended.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			// Register buttons
			ed.addButton('image', {
				title : 'advimage_extended.image_desc',
				cmd : 'mceAdvImageExtended'
			});
		},

		getInfo : function() {
			return {
				longname : 'Advanced image extended',
				author : 'Overdrive (Design Limited)',
				authorurl : 'http://www.overdrivedesign.com',
				infourl : '',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('advimage_extended', tinymce.plugins.AdvancedImageExtendedPlugin);
})();
