describe("Rwiki.TreePanel", function() {
  var treePanel;

  beforeEach(function() {
    treePanel = new Rwiki.TreePanel();
  });

  describe("relayed events", function() {
    var node = {};
    var observable = new Ext.util.Observable();
    observable.addEvents('createFolder');

    describe("on 'createFolder'", function() {
      beforeEach(function() {
        treePanel.relayEvents(observable, ['createFolder']);

        observable.fireEvent('createFolder', node);
      });
      
    });
  });
});