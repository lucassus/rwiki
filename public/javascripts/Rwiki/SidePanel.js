Ext.ns('Rwiki');

Rwiki.SidePanel = Ext.extend(Ext.Panel, {
  constructor: function() {
    Ext.apply(this, {
      region: 'west',
      id: 'west-panel',
      header: false,
      split: true,
      width: 255,
      minSize: 255,
      maxSize: 500,
      collapsible: true,
      collapseMode: 'mini',
      autoScroll: true,
      margins: '0 0 5 5',
      cmargins: '0 0 0 0'
    });

    Rwiki.SidePanel.superclass.constructor.apply(this, arguments);

    this.on('treeToggled', function() {
      this.toggleCollapse();
    });
  }
});
