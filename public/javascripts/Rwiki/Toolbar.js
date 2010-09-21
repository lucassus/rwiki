Ext.ns('Rwiki');

Rwiki.Toolbar = Ext.extend(Ext.Toolbar, {
  constructor: function(config) {
    config = Ext.apply({
      items: [
      {
        // xtype: 'button', // default for Toolbars, same as 'tbbutton'
        text: 'Button'
      },
      {
        xtype: 'splitbutton', // same as 'tbsplitbutton'
        text: 'Split Button'
      },
      // begin using the right-justified button container
      '->', // same as {xtype: 'tbfill'}, // Ext.Toolbar.Fill
      {
        xtype: 'textfield',
        name: 'field1',
        emptyText: 'enter search term'
      },
      // add a vertical separator bar between toolbar items
      '-', // same as {xtype: 'tbseparator'} to create Ext.Toolbar.Separator
      'text 1', // same as {xtype: 'tbtext', text: 'text1'} to create Ext.Toolbar.TextItem
      {
        xtype: 'tbspacer'
      },// same as ' ' to create Ext.Toolbar.Spacer
      'text 2',
      {
        xtype: 'tbspacer',
        width: 50
      }, // add a 50px space
      'text 3'
      ]

    }, config);

    Rwiki.Toolbar.superclass.constructor.call(this, config);
  }
});
