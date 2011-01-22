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
    this.on('rwiki:nodeRenamed', this.onNodeRenamed);
    this.on('rwiki:nodeDeleted', this.onNodeDeleted);
    this.on('rwiki:lastPageClosed', this.onLastPageClosed);
    this.on('editorToggled', this.onEditorToggled);
  },

  onPageLoaded: function(data) {
    this.editor.setPagePath(data.path);
    this.editor.setContent(data.rawContent);
  },

  onNodeRenamed: function(data) {
    var oldPath = data.oldPath;
    var currentPagePath = this.editor.getPagePath();
    if (currentPagePath == null) return;

    var isPage = oldPath.match(new RegExp('\.txt$'));
    var currentPageWasChanged = isPage && oldPath == currentPagePath;
    var parentPathWasChanged = Rwiki.NodeManager.getInstance().isParent(oldPath, currentPagePath);

    if (currentPageWasChanged) {
      this.editor.setPagePath(data.path);
    } else if (parentPathWasChanged) {
      var newPath = currentPagePath.replace(oldPath, data.path);
      this.editor.setPagePath(newPath);
    }
  },

  onNodeDeleted: function(data) {
    if (data.path == this.editor.getPagePath()) {
      this.editor.clearContent();
    }
  },

  onLastPageClosed: function() {
    this.editor.clearContent();
  },

  onEditorToggled: function() {
    this.toggleCollapse();
  }
});
