Ext.ns('Rwiki.TreePanel');

Rwiki.TreePanel.Menu = Ext.extend(Ext.menu.Menu, {
  constructor: function() {
    Ext.apply(this, {
      id: 'feeds-ctx',
      items: [{
        text: 'Create folder',
        id: 'create-folder',
        iconCls: 'icon-create-folder',
        scope: this,
        handler: this.onCreateFolder
      }, {
        text: 'Create page',
        id: 'create-page',
        iconCls: 'icon-create-page',
        scope: this,
        handler: this.onCreatePage
      }, '-',  {
        text: 'Rename node',
        id: 'rename-node',
        iconCls: 'icon-rename-node',
        scope: this,
        handler: this.onRenameNode
      }, {
        text: 'Delete node',
        id: 'delete-node',
        iconCls: 'icon-delete-node',
        scope: this,
        handler: this.onDeleteNode
      }]
    });

    Rwiki.TreePanel.Menu.superclass.constructor.apply(this, arguments);
  },

  show: function(node, xy) {
    this.node = node;
    node.select();

    var isRoot = node.id == Rwiki.rootFolderName;
    this.setItemDisabled('delete-node', isRoot);
    this.setItemDisabled('rename-node', isRoot);

    var isPage = node.attributes.cls == 'page';
    this.setItemDisabled('create-folder', isPage);
    this.setItemDisabled('create-page', isPage);

    this.showAt(xy);
  },

  onCreateFolder: function() {
    var parentNode = this.node;
    if (parentNode.cls == 'file') return;

    Ext.MessageBox.prompt('Create folder', 'New folder name:', function(button, name) {
      if (button != 'ok') return;

      var parentPath = parentNode.getPath('baseName');
      Rwiki.Node.getInstance().fireEvent('createFolder', parentPath, name);
    });
  },

  onCreatePage: function() {
    var parentNode = this.node;
    if (parentNode.cls == 'file') return;

    Ext.MessageBox.prompt('Create page', 'New page name:', function(button, name) {
      if (button != 'ok') return;

      var parentPath = parentNode.getPath('baseName');
      Rwiki.Node.getInstance().fireEvent('createPage', parentPath, name);
    });
  },

  onRenameNode: function() {
    var node = this.node;
    var oldPath = node.getPath('baseName');
    var oldBaseName = node.text;

    var callback = function(button, newName) {
      if (button != 'ok') return;
      Rwiki.Node.getInstance().fireEvent('renameNode', oldPath, newName);
    };

    Ext.MessageBox.prompt('Rename node', 'Enter a new name:', callback, this, false, oldBaseName);
  },

  onDeleteNode: function() {
    var node = this.node;
    var path = node.getPath('baseName');

    var callback = function(button) {
      if (button != 'yes') return;
      Rwiki.Node.getInstance().fireEvent('deleteNode', path);
    }

    var message = 'Delete "' + path + '"?';
    Ext.MessageBox.confirm('Confirm', message, callback);
  },

  setItemDisabled: function(id, disabled) {
    var item = this.findById(id);
    if (item == null) return;

    item.setDisabled(disabled);
  }
});
