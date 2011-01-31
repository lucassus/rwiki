Ext.ns('Rwiki');

Rwiki.EditorPanel = Ext.extend(Ext.Panel, {
  constructor: function() {
    Ext.apply(this, {
      contentEl: 'editor-container',
      header: false,
      height: 400,

      listeners: {
        resize: function(panel, width, height) {
          var offset = 36 - 25;
          $('.markItUpContainer').height(height - offset);
          var editorOffset = 73 - 25;
          $('#editor').height(height - editorOffset);
        }
      }
    });

    Rwiki.EditorPanel.superclass.constructor.apply(this, arguments);
    this.editor = new Rwiki.EditorPanel.Editor();
  },

  initEvents: function() {
    Rwiki.EditorPanel.superclass.initEvents.apply(this, arguments);

    this.relayEvents(Rwiki.NodeManager.getInstance(), ['rwiki:pageLoaded']);
    this.on('rwiki:pageLoaded', this.onPageLoaded);
  },

  onPageLoaded: function(page) {
    this.editor.setPagePath(page.getPath());
    this.editor.setContent(page.getRawContent());

    Ext.get('editor-container').unmask();
  },

  getPagePath: function() {
    return this.editor.getPagePath();
  },

  getRawContent: function() {
    return this.editor.getContent();
  }
});
