Ext.ns('Rwiki');

Rwiki.EditorPanel = Ext.extend(Ext.Panel, {
  constructor: function() {
    Ext.apply(this, {
      region: 'south',
      contentEl: 'editor-container',
      title: 'Page editor',
      titleCollapse: true,
      collapseMode: 'mini',
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
    })

    Rwiki.EditorPanel.superclass.constructor.apply(this, arguments);
    this.editor = new Rwiki.EditorPanel.Editor($('textarea#editor'));
    this.initEventHandlers();
  },

  initEventHandlers: function() {
    this.on('pageLoaded', function(data) {
      this.editor.setPagePath(data.path);
      this.editor.setContent(data.raw);
    });

    this.on('nodeRenamed', function(data) {
      var oldPath = data.oldPath;
      var path = data.path;
      var currentPagePath = this.editor.getPagePath();
      if (currentPagePath == null) return;

      var isPage = oldPath.match(new RegExp('\.txt$'));
      var currentPageWasChanged = isPage && oldPath == currentPagePath;
      if (currentPageWasChanged) {
        this.editor.setPagePath(path);
      } else {
        var parentPathWasChanged = Rwiki.nodeManager.isParent(oldPath, currentPagePath);
        if (parentPathWasChanged) {
          var newPath = currentPagePath.replace(oldPath, path);
          this.editor.setPagePath(newPath);
        }
      }
    });

    this.on('nodeDeleted', function(data) {
      if (data.path == this.editor.getPagePath()) {
        this.editor.clearContent();
      }
    });
  }
});
