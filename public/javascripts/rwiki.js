Ext.ns('Rwiki');

Ext.onReady(function() {
  Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

  var tabPanel = new Rwiki.TabPanel();
  var treePanel = new Rwiki.TreePanel({
    tabPanel: tabPanel
  });

  var leftPanel = new Ext.Panel({
    region: 'west',
    id: 'west-panel',
    title: 'Pages',
    split: true,
    collapsible: true,
    width: 200,
    minSize: 175,
    maxSize: 400,
    margins: '0 0 0 5',
    items: [treePanel]
  });

  var editorPanel = new Ext.Panel({
    region: 'south',
    contentEl: 'edit-container',
    title: 'Editor',
    split: true,
    collapsible: true,
    collapseMode: 'mini',
    height: 400
  });

  var mainPanel = new Ext.Container({
    region: 'center',
    layout: 'border',
    items: [tabPanel, editorPanel]
  });

  new Ext.Viewport({
    layout: 'border',
    items: [leftPanel, mainPanel]
  });

  // hack for ff
  $('#editor').val('');

  $('#editor').bind('keydown', function() {
    var node = treePanel.getSelectionModel().getSelectedNode();
    if (node == null) return false;
  });

  var timeout = null;
  $('#editor').bind('keyup', function() {
    clearTimeout(timeout);
    
    var node = treePanel.getSelectionModel().getSelectedNode();
    if (node == null) return false;

    timeout = setTimeout(function() {
      var content = $('#editor').val();
      var fileName = node.id;

      $.ajax({
        type: 'POST',
        url: '/node/update',
        dataType: 'json',
        data: {
          node: fileName,
          content: content
        },
        success: function(data) {
          $('#' + node.id).html(data.html);
        }
      });

    }, 900);
  });

});
