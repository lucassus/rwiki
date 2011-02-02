Ext.ns('Rwiki.Tree');

Rwiki.Tree.Toolbar = Ext.extend(Ext.Toolbar, {
  constructor: function() {
    var self = this;
    
    var filterField = new Ext.form.TextField({
      width: 200,
      emptyText: 'Find a Page',
      enableKeyEvents: true,
      listeners: {
        keydown: {
          fn: function() {
            var text = this.getValue();
            self.fireEvent('filterFieldChanged', text);
          },
          buffer: 350
        }
      }
    });

    Ext.apply(this, {
      items: [
      filterField,
      {
        iconCls: 'icon-expand-all',
        tooltip: 'Expand All',
        handler: function() {
          self.fireEvent('expandAll');
        }
      }, {
        iconCls: 'icon-collapse-all',
        tooltip: 'Collapse All',
        handler: function() {
          self.fireEvent('collapseAll');
        }
      }]
    });

    Rwiki.Tree.Toolbar.superclass.constructor.apply(this, arguments);

    this.addEvents('filterFieldChanged', 'expandAll', 'collapseAll');
  }
});
