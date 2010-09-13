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

    var self = this;
    this.editor.container.bind('contentChanged', function() {
      self.fireEvent('contentChanged', self.editor.getContent());
    });
  },

  getEditor: function() {
    return this.editor;
  }
});
