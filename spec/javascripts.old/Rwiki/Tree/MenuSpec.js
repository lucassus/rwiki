describe("Rwiki.Tree.Menu", function() {
  var menu;

  beforeEach(function() {
    menu = new Rwiki.Tree.Menu();
  });

  describe(":show", function() {
    var node = {};
    var xy = {};

    var itShouldDisable = function(menuItemId) {
      it("should disable '" + menuItemId + "' option", function() {
        var item = menu.findById(menuItemId);
        expect(item).toBeDisabled();
      });
    };

    var itShouldEnable = function(menuItemId) {
      it("should enable '" + menuItemId + "' option", function() {
        var item = menu.findById(menuItemId);
        expect(item).toBeEnabled();
      });
    };

    beforeEach(function() {
      node.select = jasmine.createSpy('select');
      menu.showAt = jasmine.createSpy('showAt');

      this.addMatchers({
        toBeDisabled: function() {
          return this.actual.disabled;
        },
        toBeEnabled: function() {
          return !this.actual.disabled;
        }
      });
    });

    describe("when root node is selected", function() {
      beforeEach(function() {
        node.isRoot = true;
        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      });

      itShouldEnable('add-page');
      itShouldDisable('delete-page');
      itShouldDisable('rename-page');
    });

    describe("when page node is selected", function() {
      beforeEach(function() {
        node.isRoot = false;
        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      });

      itShouldEnable('delete-page');
      itShouldEnable('rename-page');
      itShouldEnable('add-page');
    });
  });

  describe("menu elements", function() {
    var currentNode = {};
    var item;

    beforeEach(function() {
      menu.node = currentNode;
      menu.fireEvent = jasmine.createSpy('fireEvent');

      this.addMatchers({
        toBeTitledAs: function(title) {
          return this.actual.text == title;
        }
      });
    });

    describe("'Add page' option", function() {
      beforeEach(function() {
        item = menu.findById('add-page');
      });

      it("should have 'Add page' title", function() {
        expect(item).toBeTitledAs("Add page");
      });
    });

    describe("'Rename node' option", function() {
      beforeEach(function() {
        item = menu.findById('rename-page');
      });

      it("should have 'Rename page' title", function() {
        expect(item).toBeTitledAs("Rename page");
      });
    });

    describe("'Delete page' option", function() {
      beforeEach(function() {
        item = menu.findById('delete-page');
      });

      it("should have 'Delete page' title", function() {
        expect(item).toBeTitledAs("Delete page");
      });
    });
  });

});
