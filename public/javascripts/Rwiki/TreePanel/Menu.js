Ext.ns('Rwiki.TreePanel');

Rwiki.TreePanel.Menu = Ext.extend(Ext.menu.Menu, {
  constructor: function(config) {
    config = Ext.apply({
      id: 'feeds-ctx',
      items: [{
        text: 'Create folder',
        id: 'create-folder',
        iconCls: 'icon-create-folder',
        scope: this,
        handler: function(item, e) {
          this.fireEvent('createFolder', this.node)
        }
      }, {
        text: 'Create page',
        id: 'create-page',
        iconCls: 'icon-create-page',
        scope: this,
        handler: function(item, e) {
          this.fireEvent('createPage', this.node);
        }
      }, '-',  {
        text: 'Rename node',
        id: 'rename-node',
        iconCls: 'icon-rename-node',
        scope: this,
        handler: function(item, e) {
          this.fireEvent('renameNode', this.node);
        }
      }, {
        text: 'Delete node',
        id: 'delete-node',
        iconCls: 'icon-delete-node',
        scope: this,
        handler: function(item, e) {
          this.fireEvent('deleteNode', this.node);
        }
      }]
    }, config);

    Rwiki.TreePanel.Menu.superclass.constructor.call(this, config);

    // define events
    this.addEvents(
      'createFolder',
      'createPage',
      'renameNode',
      'deleteNode');
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

  setItemDisabled: function(id, disabled) {
    var item = this.findById(id);
    if (item == null) return;

    item.setDisabled(disabled);
  }
});
