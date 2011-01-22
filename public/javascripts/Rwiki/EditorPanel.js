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
    this.editor = new Rwiki.EditorPanel.Editor($('textarea#editor'));
  },

  initEvents: function() {
    Rwiki.EditorPanel.superclass.initEvents.apply(this, arguments);

    this.on('rwiki:pageLoaded', this.onPageLoaded);
  },

  onPageLoaded: function(data) {
    this.editor.setPagePath(data.path);
    this.editor.setContent(data.rawContent);
  },

  getPagePath: function() {
    return this.editor.getPagePath();
  },

  getRawContent: function() {
    return this.editor.getContent();
  }
});
