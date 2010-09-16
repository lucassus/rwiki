Rwiki.TreePanel.Toolbar = Ext.extend(Ext.Toolbar, {
  constructor: function(config) {
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

    var defaultConfig = {
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
    };

    var config = Ext.apply(defaultConfig, config);
    Rwiki.TreePanel.Toolbar.superclass.constructor.call(this, config);

    this.addEvents('filterFieldChanged', 'expandAll', 'collapseAll');
  }
});
