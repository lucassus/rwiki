Rwiki.TreePanel.Menu = Ext.extend(Ext.menu.Menu, {
  constructor: function(config) {
    config = Ext.apply({
      id: 'feeds-ctx',
      items: [{
        text: 'Create folder',
        id: 'create-folder',
        iconCls: 'icon-create-folder',
        scope: this,
        command: 'create-folder'
      }, {
        text: 'Create page',
        id: 'create-page',
        iconCls: 'icon-create-page',
        scope: this,
        command: 'create-page'
      }, '-',  {
        text: 'Rename node',
        id: 'rename-node',
        iconCls: 'icon-rename',
        scope: this,
        command: 'rename-node'
      }, '-', {
        text: 'Delete node',
        id: 'delete-node',
        iconCls: 'icon-delete-node',
        scope: this,
        command: 'delete-node'
      }]
    }, config);

    Rwiki.TreePanel.Menu.superclass.constructor.call(this, config);
  }
});
