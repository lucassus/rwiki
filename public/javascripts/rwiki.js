Ext.ns('Rwiki');

Ext.onReady(function() {
  Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

  var editor = new Rwiki.Editor($('textarea#editor'));
  var tabPanel = new Rwiki.TabPanel();
  tabPanel.setEditor(editor);

  editor.container.bind('contentChanged', function() {
    var currentTab = tabPanel.getActiveTab();
    var content = $(this).val();
    var fileName = currentTab.id;

    $.ajax({
      type: 'POST',
      url: '/node/update',
      dataType: 'json',
      data: {
        node: fileName,
        content: content
      },
      success: function(data) {
        $('#' + currentTab.id).html(data.html);
      }
    });
  });

  var treePanel = new Rwiki.TreePanel();
  treePanel.setTabPanel(tabPanel);

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
    contentEl: 'editor-container',
    title: 'Editor',
    split: true,
    collapsible: true,
    collapsed: true,
    height: 400,
    listeners: {
      resize: function(panel, width, height) {
        var offset = 36;
        $('.markItUpContainer').height(height - offset);
        var editorOffset = 73;
        $('#editor').height(height - editorOffset);
      }
    }
  });

  var pagePanel = new Ext.Container({
    region: 'center',
    layout: 'border',
    items: [tabPanel, editorPanel]
  });

  new Ext.Viewport({
    layout: 'border',
    items: [leftPanel, pagePanel]
  });

});
