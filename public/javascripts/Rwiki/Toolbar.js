Ext.ns('Rwiki');

Rwiki.Toolbar = Ext.extend(Ext.Toolbar, {
  constructor: function() {
    var self = this;

    Ext.apply(this, {
      items: [
        new Ext.Action({
          text: 'Toggle tree',
          enableToggle: true,
          pressed: true,
          handler: function() {
            self.fireEvent('treeToggled');
          }
        }),
        new Ext.Action({
          text: 'Toggle editor',
          enableToggle: true,
          pressed: false,
          handler: function() {
            self.fireEvent('editorToggled');
          }
        })
      ]
    });

    Rwiki.Toolbar.superclass.constructor.apply(this, arguments);
    this.addEvents('treeToggled', 'editorToggled');
  }
});
