Rwiki.TreePanel.Menu = Ext.extend(Ext.menu.Menu, {
  constructor: function(config) {
    config = Ext.apply({
      id: 'feeds-ctx',
      items: [{
        text: 'Create directory',
        id: 'create-folder',
        iconCls: 'icon-create-directory',
        scope: this,
        command: 'create-directory'
      }, {
        text: 'Create page',
        id: 'create-page',
        iconCls: 'icon-create-page',
        scope: this,
        command: 'create-page'
      }, '-',  {
        text: 'Rename node',
        id: 'rename-node',
        iconCls: 'icon-rename-node',
        scope: this,
        command: 'rename-node'
      }, {
        text: 'Delete node',
        id: 'delete-node',
        iconCls: 'icon-delete-node',
        scope: this,
        command: 'delete-node'
      }]
    }, config);

    Rwiki.TreePanel.Menu.superclass.constructor.call(this, config);

    // define events
    this.addEvents('createDirecotry', 'createPage', 'renameNode', 'deleteNode');
  },

  show: function(node, xy) {
    this.node = node;
    node.select();

    var isRoot = node.id == Rwiki.rootDirName;
    this.setItemDisabled('delete-node', isRoot);
    this.setItemDisabled('rename-node', isRoot);

    var isPage = node.attributes.cls == 'page';
    this.setItemDisabled('create-folder', isPage);
    this.setItemDisabled('create-page', isPage);

    this.showAt(xy);
  },

  getItemByCommand: function(command) {
    var item = this.items.find(function(item) {
      return command === item.command;
    });

    return item;
  },

  setItemDisabled: function(command, disabled) {
    var item = this.getItemByCommand(command);
    if (item) {
      item.setDisabled(disabled);
    }
  }
});
