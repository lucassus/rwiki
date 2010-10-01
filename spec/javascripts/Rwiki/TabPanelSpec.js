describe("Rwiki.TabPanel", function() {
  var tabPanel;

  beforeEach(function() {
    tabPanel = new Rwiki.TabPanel();
  });

  describe("relayed events", function() {
    var observable = new Ext.util.Observable();
    observable.addEvents('pageCreated');
    
    describe("on 'pageCreated'", function() {
      var tab = {};
      
      beforeEach(function() {
        tabPanel.relayEvents(observable, ['pageCreated']);
        spyOn(tabPanel, 'createPageTab').andReturn(tab);
        tab.show = jasmine.createSpy('tab.show');

        observable.fireEvent('pageCreated', {
          path: './page.txt',
          text: 'page'
        });
      });

      it("should create a new tab", function() {
        expect(tabPanel.createPageTab).toHaveBeenCalledWith('./page.txt', 'page');
      });

      it("should open a new tab", function() {
        expect(tab.show).toHaveBeenCalled();
      });
    });
  });
});
