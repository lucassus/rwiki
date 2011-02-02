describe("Rwiki.Tree.Menu", function() {
  var menu;

  beforeEach(function() {
    menu = new Rwiki.TreePanel.Menu();
  });

  describe(":show method", function() {
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
          return this.actual.disabled == true;
        },
        toBeEnabled: function() {
          return this.actual.disabled == false;
        }
      });
    });

    describe("when root node is selected", function() {
      beforeEach(function() {
        node.id = Rwiki.rootFolderName;
        node.attributes = {
          cls: 'folder'
        };

        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      });

      itShouldDisable('delete-node');
      itShouldDisable('rename-node');
      itShouldEnable('create-folder');
      itShouldEnable('create-page');
    });

    describe("when folder node is selected", function() {
      beforeEach(function() {
        node.id = './folder';
        node.attributes = {
          cls: 'folder'
        };

        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      })

      itShouldEnable('delete-node');
      itShouldEnable('rename-node');
      itShouldEnable('create-folder');
      itShouldEnable('create-page');
    });

    describe("when page node is selected", function() {
      beforeEach(function() {
        node.id = './page.txt';
        node.attributes = {
          cls: 'page'
        };

        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      })

      itShouldEnable('delete-node');
      itShouldEnable('rename-node');
      itShouldDisable('create-folder');
      itShouldDisable('create-page');
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

    describe("'Create folder' option", function() {
      beforeEach(function() {
        item = menu.findById('create-folder');
      });

      it("should have 'Create folder' title", function() {
        expect(item).toBeTitledAs("Create folder");
      });
    });

    describe("'Create page' option", function() {
      beforeEach(function() {
        item = menu.findById('create-page');
      });

      it("should have 'Create page' title", function() {
        expect(item).toBeTitledAs("Create page");
      });
    });

    describe("'Rename node' option", function() {
      beforeEach(function() {
        item = menu.findById('rename-node');
      });

      it("should have 'Rename node' title", function() {
        expect(item).toBeTitledAs("Rename node");
      });
    });

    describe("'Delete node' option", function() {
      beforeEach(function() {
        item = menu.findById('delete-node');
      });

      it("should have 'Delete node' title", function() {
        expect(item).toBeTitledAs("Delete node");
      });
    });
  });

});
