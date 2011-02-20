Ext.ns('Rwiki.Tree');

Rwiki.Tree.Menu = Ext.extend(Ext.menu.Menu, {
  constructor: function() {
    Ext.apply(this, {
      id: 'feeds-ctx',
      items: [{
        text: 'Add page',
        id: 'add-page',
        iconCls: 'icon-add-page',
        scope: this,
        handler: this.onCreatePage
      }, '-',  {
        text: 'Rename page',
        id: 'rename-page',
        iconCls: 'icon-rename-page',
        scope: this,
        handler: this.onRenameNode
      }, {
        text: 'Delete page',
        id: 'delete-page',
        iconCls: 'icon-delete-page',
        scope: this,
        handler: this.onDeleteNode
      }]
    });

    Rwiki.Tree.Menu.superclass.constructor.apply(this, arguments);
  },

  show: function(node, xy) {
    this.node = node;
    node.select();

    this.setItemDisabled('delete-page', node.isRoot);
    this.setItemDisabled('rename-page', node.isRoot);

    this.showAt(xy);
  },

  onCreatePage: function() {
    var parentNode = this.node;

    Ext.MessageBox.prompt('Add page', 'New page name:', function(button, name) {
      if (button != 'ok') return;

      var parentPath = parentNode.getPath();
      Rwiki.nodeManager.createPage(parentPath, name);
    });
  },

  onRenameNode: function() {
    var node = this.node;
    if (node.isRoot) return;

    var oldPath = node.getPath();
    var oldBaseName = node.text;

    var callback = function(button, newName) {
      if (button != 'ok') return;
      Rwiki.nodeManager.renameNode(oldPath, newName);
    };

    Ext.MessageBox.prompt('Rename page', 'Enter a new name:', callback, this, false, oldBaseName);
  },

  onDeleteNode: function() {
    var node = this.node;
    if (node.isRoot) return;
    
    var path = node.getPath();

    var callback = function(button) {
      if (button != 'yes') return;
      Rwiki.nodeManager.deleteNode(path);
    };

    var message = 'Delete "' + path + '"?';
    Ext.MessageBox.confirm('Confirm', message, callback);
  },

  setItemDisabled: function(id, disabled) {
    var item = this.findById(id);
    item.setDisabled(disabled);
  }
});
