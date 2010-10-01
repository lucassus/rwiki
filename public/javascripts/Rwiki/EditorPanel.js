Ext.ns('Rwiki');

Rwiki.EditorPanel = Ext.extend(Ext.Panel, {
  constructor: function(config) {
    config = Ext.apply({
      region: 'south',
      contentEl: 'editor-container',
      title: 'Editor',
      split: true,
      collapsible: true,
      collapsed: true,
      height: 400,

      listeners: {
        resize: function(panel, width, height) {
          var offset = 36;
          $('.markItUpContainer').height(height - offset);
          var editorOffset = 73;
          $('#editor').height(height - editorOffset);
        }
      }
    }, config);

    Rwiki.EditorPanel.superclass.constructor.call(this, config);
    this.editor = new Rwiki.EditorPanel.Editor($('textarea#editor'));
    this.initEventHandlers();
  },

  initEventHandlers: function() {
    this.on('pageLoaded', function(data) {
      this.editor.setPagePath(data.path);
      this.editor.setContent(data.raw);
    });

    this.on('nodeRenamed', function(data) {
      if (data.oldPath == this.editor.getPagePath()) {
        this.editor.setPagePath(data.path);
      }
    });

    this.on('nodeDeleted', function(data) {
      if (data.path == this.editor.getPagePath()) {
        this.editor.clearContent();
      }
    });
  }
});
